class FeedbackInfo{
  final String firstName;
  final String surname;
  final String fId;
  final String email;
  final String message;

//<editor-fold desc="Data Methods">
  const FeedbackInfo({
    required this.firstName,
    required this.surname,
    required this.fId,
    required this.email,
    required this.message,
  });


  FeedbackInfo copyWith({
    String? firstName,
    String? surname,
    String? fId,
    String? email,
    String? message,
  }) {
    return FeedbackInfo(
      firstName: firstName ?? this.firstName,
      surname: surname ?? this.surname,
      fId: fId ?? this.fId,
      email: email ?? this.email,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'surname': surname,
      'fId': fId,
      'email': email,
      'message': message,
    };
  }

  factory FeedbackInfo.fromMap(Map<String, dynamic> map) {
    return FeedbackInfo(
      firstName: map['firstName'] as String,
      surname: map['surname'] as String,
      fId: map['fId'] as String,
      email: map['email'] as String,
      message: map['message'] as String,
    );
  }

//</editor-fold>
}