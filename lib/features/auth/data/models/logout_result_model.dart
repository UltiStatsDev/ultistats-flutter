class LogoutResultModel {
  const LogoutResultModel({required this.sessionId, required this.status});

  final String sessionId;
  final String status;

  factory LogoutResultModel.fromJson(Map<String, dynamic> json) {
    return LogoutResultModel(
      sessionId: json['sessionId'] as String,
      status: json['status'] as String? ?? '',
    );
  }
}
