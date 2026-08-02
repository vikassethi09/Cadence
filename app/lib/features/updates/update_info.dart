/// A GitHub release newer than the running app, if one was found.
class UpdateInfo {
  const UpdateInfo({required this.version, required this.url});

  final String version;
  final String url;
}
