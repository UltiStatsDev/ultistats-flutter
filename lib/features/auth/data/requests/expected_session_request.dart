class ExpectedSessionRequest {
  const ExpectedSessionRequest({required this.expectedSessionId});

  final String expectedSessionId;

  Map<String, dynamic> toJson() => {'expectedSessionId': expectedSessionId};
}
