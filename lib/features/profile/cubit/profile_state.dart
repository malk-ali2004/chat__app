// part of 'profile_cubit.dart';

// @immutable
// sealed class ProfileState {}

// final class ProfileInitial extends ProfileState {}

// final class GetProfileLoading extends ProfileState {}

// final class GetProfileSuccess extends ProfileState {
//   final UserModel userModel;
//   GetProfileSuccess(this.userModel);
// }

// final class GetProfileError extends ProfileState {
//   final String message;
//   GetProfileError(this.message);
// }

// class PickProfileImageLoading extends ProfileState {}

// class PickProfileImageSuccess extends ProfileState {
//   final File image;
//   PickProfileImageSuccess(this.image);
// }

// class PickProfileImageError extends ProfileState {
//   final String message;
//   PickProfileImageError(this.message);
// }

// class UpdateProfileImageLoading extends ProfileState {}

// class UpdateProfileImageSuccess extends ProfileState {}

// class UpdateProfileImageError extends ProfileState {
//   final String message;
//   UpdateProfileImageError(this.message);
// }

part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class GetProfileLoading extends ProfileState {}

final class GetProfileSuccess extends ProfileState {
  final UserModel userModel;
  GetProfileSuccess(this.userModel);
}

final class GetProfileError extends ProfileState {
  final String message;
  GetProfileError(this.message);
}

class PickProfileImageLoading extends ProfileState {}

class PickProfileImageSuccess extends ProfileState {
  final File image;
  PickProfileImageSuccess(this.image);
}

class PickProfileImageError extends ProfileState {
  final String message;
  PickProfileImageError(this.message);
}

class UpdateProfileImageLoading extends ProfileState {}

class UpdateProfileImageSuccess extends ProfileState {}

class UpdateProfileImageError extends ProfileState {
  final String message;
  UpdateProfileImageError(this.message);
}

// 🔹 حالات تسجيل الخروج
class SignOutLoading extends ProfileState {}

class SignOutSuccess extends ProfileState {}

class SignOutError extends ProfileState {
  final String message;
  SignOutError(this.message);
}
