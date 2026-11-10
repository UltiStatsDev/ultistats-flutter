class CsrfTokenModel {
  const CsrfTokenModel({required this.headerName, required this.token});

  final String headerName;
  final String token;

  factory CsrfTokenModel.fromJson(Map<String, dynamic> json) {
    return CsrfTokenModel(
      headerName: json['headerName'] as String? ?? 'X-CSRF-TOKEN',
      token: json['token'] as String,
    );
  }
}
