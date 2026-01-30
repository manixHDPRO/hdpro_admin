import 'package:equatable/equatable.dart';

class AuthCredentials extends Equatable {
  final String email;
  final String password;
  final String? confirmPassword;
  final String? phoneNumber;
  final String? displayName;

  const AuthCredentials({
    required this.email,
    required this.password,
    this.confirmPassword,
    this.phoneNumber,
    this.displayName,
  });

  @override
  List<Object?> get props => [
    email,
    password,
    confirmPassword,
    phoneNumber,
    displayName,
  ];

  bool get isRegistration => confirmPassword != null;
  bool get hasValidPassword {
    if (isRegistration) {
      return password.isNotEmpty && password == confirmPassword;
    }
    return password.isNotEmpty;
  }

  bool get hasValidEmail => email.contains('@') && email.contains('.');

  AuthCredentials copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? phoneNumber,
    String? displayName,
  }) {
    return AuthCredentials(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
    );
  }
}
