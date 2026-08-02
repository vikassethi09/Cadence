import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'update_info.dart';

/// Holds this session's update-check result, if any. Set once at startup
/// by main.dart after calling [checkForUpdate]; cleared when the Today
/// screen banner is dismissed.
final latestUpdateProvider = StateProvider<UpdateInfo?>((ref) => null);
