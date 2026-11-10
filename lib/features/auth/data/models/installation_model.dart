class InstallationModel {
  const InstallationModel({
    required this.contractVersion,
    required this.installationId,
    required this.entryMode,
    required this.publicOrigin,
    required this.secureOrigin,
  });

  final String contractVersion;
  final String installationId;
  final String entryMode;
  final String publicOrigin;
  final String secureOrigin;

  factory InstallationModel.fromJson(Map<String, dynamic> json) {
    return InstallationModel(
      contractVersion: json['contractVersion'] as String? ?? '',
      installationId: json['installationId'] as String,
      entryMode: json['entryMode'] as String? ?? '',
      publicOrigin: json['publicOrigin'] as String? ?? '',
      secureOrigin: json['secureOrigin'] as String? ?? '',
    );
  }
}
