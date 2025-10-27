import 'package:bloc/bloc.dart';
import 'package:chat_app/features/Auth/data/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

  // 🔹 Email & Password Login
  Future<void> login({required String email, required String password}) async {
    try {
      emit(LoginLoading());
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginError(e.code));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  // 🔹 Register New User
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String position,
  }) async {
    try {
      emit(RegisterLoading());

      // إنشاء مستخدم جديد في Firebase
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // إرسال إيميل التحقق
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      // حفظ بيانات المستخدم في Firestore
      final userModel = UserModel(
        email: email,
        password: password,
        name: name,
        postiton: position,
      );

      await users.doc(email).set(userModel.toJson());

      emit(RegisterSuccess("Please check your email to verify your account"));
    } on FirebaseAuthException catch (e) {
      emit(RegisterError(e.code));
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }

  // 🔹 Google Login
  Future<void> signInWithGoogle() async {
    try {
      emit(LoginLoading());
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      // حفظ بيانات المستخدم في Firestore لو أول مرة
      await _saveSocialUser(userCred.user);

      emit(LoginSuccess());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  // 🔹 حفظ بيانات المستخدم بعد تسجيل الدخول بالسوشيال
  Future<void> _saveSocialUser(User? user) async {
    if (user == null) return;
    final userDoc = await users.doc(user.email).get();

    if (!userDoc.exists) {
      final userModel = UserModel(
        email: user.email ?? "",
        name: user.displayName ?? "",
        password: "",
        postiton: "social_user",
      );
      await users.doc(user.email).set(userModel.toJson());
    }
  }
}
