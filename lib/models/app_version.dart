class AppVersion {
  final String appKey;
  final String latestVersion;
  final String minVersion;
  final bool forceUpdate;
  final String storeUrl;
  final String changelog;

  AppVersion({
    required this.appKey,
    required this.latestVersion,
    required this.minVersion,
    required this.forceUpdate,
    required this.storeUrl,
    required this.changelog,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) => AppVersion(
        appKey: json['app_key']?.toString() ?? '',
        latestVersion: json['latest_version']?.toString() ?? '0.0.0',
        minVersion: json['min_version']?.toString() ?? '0.0.0',
        forceUpdate: json['force_update'] == true || json['force_update'] == '1' || json['force_update'] == 1,
        storeUrl: json['store_url']?.toString() ?? '',
        changelog: json['changelog']?.toString() ?? '',
      );

  AppVersion copyWith({
    String? latestVersion,
    String? minVersion,
    bool? forceUpdate,
    String? storeUrl,
    String? changelog,
  }) =>
      AppVersion(
        appKey: appKey,
        latestVersion: latestVersion ?? this.latestVersion,
        minVersion: minVersion ?? this.minVersion,
        forceUpdate: forceUpdate ?? this.forceUpdate,
        storeUrl: storeUrl ?? this.storeUrl,
        changelog: changelog ?? this.changelog,
      );
}
