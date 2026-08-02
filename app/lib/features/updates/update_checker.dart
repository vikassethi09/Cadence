import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../../data/db/database.dart';
import '../../providers/settings_providers.dart';
import 'update_info.dart';

const _releasesApiUrl = 'https://api.github.com/repos/vikassethi09/Cadence/releases/latest';
const _recheckInterval = Duration(hours: 24);

/// Checks GitHub for a newer release than the one currently running.
///
/// Does nothing — no network call at all — unless the user has opted in via
/// Settings. Even then, it re-checks GitHub at most once every 24 hours;
/// between checks it answers from the cached result in Settings so opening
/// the app never means a guaranteed network round-trip.
///
/// Returns null if updates are off, nothing newer was found, the newer
/// version was already dismissed, or the check failed for any reason (a
/// broken network call must never surface as an error in this app).
Future<UpdateInfo?> checkForUpdate(AppDatabase db) async {
  final enabled = (await db.getSetting(SettingsKeys.updateCheckEnabled)) == 'true';
  if (!enabled) return null;

  try {
    final lastCheckedRaw = await db.getSetting(SettingsKeys.updateLastCheckedAt);
    final lastChecked = lastCheckedRaw != null ? DateTime.tryParse(lastCheckedRaw) : null;
    final dueForRecheck = lastChecked == null || DateTime.now().difference(lastChecked) > _recheckInterval;

    String? latestVersion;
    String? latestUrl;

    if (dueForRecheck) {
      final response = await http.get(Uri.parse(_releasesApiUrl)).timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final tag = json['tag_name'] as String?;
        latestUrl = json['html_url'] as String?;
        latestVersion = tag?.startsWith('v') == true ? tag!.substring(1) : tag;
        if (latestVersion != null && latestUrl != null) {
          await db.setSetting(SettingsKeys.updateLatestKnownVersion, latestVersion);
          await db.setSetting(SettingsKeys.updateLatestKnownUrl, latestUrl);
        }
      }
      await db.setSetting(SettingsKeys.updateLastCheckedAt, DateTime.now().toIso8601String());
    } else {
      latestVersion = await db.getSetting(SettingsKeys.updateLatestKnownVersion);
      latestUrl = await db.getSetting(SettingsKeys.updateLatestKnownUrl);
    }

    if (latestVersion == null || latestUrl == null) return null;

    final packageInfo = await PackageInfo.fromPlatform();
    final dismissed = await db.getSetting(SettingsKeys.updateDismissedVersion);

    final isNewer = _isVersionNewer(latestVersion, packageInfo.version);
    final alreadyDismissed = dismissed != null && !_isVersionNewer(latestVersion, dismissed);
    if (!isNewer || alreadyDismissed) return null;

    return UpdateInfo(version: latestVersion, url: latestUrl);
  } catch (_) {
    // Offline, GitHub unreachable, malformed response — any failure here
    // just means "no update found this time," never a visible error.
    return null;
  }
}

/// True if [a] is a strictly newer semver than [b] (e.g. "1.2.0" > "1.1.0").
bool _isVersionNewer(String a, String b) {
  final partsA = a.split('.').map((p) => int.tryParse(p) ?? 0).toList();
  final partsB = b.split('.').map((p) => int.tryParse(p) ?? 0).toList();
  for (var i = 0; i < 3; i++) {
    final valA = i < partsA.length ? partsA[i] : 0;
    final valB = i < partsB.length ? partsB[i] : 0;
    if (valA != valB) return valA > valB;
  }
  return false;
}
