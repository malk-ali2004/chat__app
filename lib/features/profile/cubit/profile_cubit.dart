import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chat_app/core/database/cachhelper.dart';
import 'package:chat_app/features/Auth/views/login_view.dart';
import 'package:chat_app/features/Auth/data/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> getUser() async {
    try {
      emit(GetProfileLoading());
      var user = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get();

      UserModel userModel = UserModel.fromJson(user.data()!);
      emit(GetProfileSuccess(userModel));
    } catch (e) {
      emit(GetProfileError(e.toString()));
      log("Get User Error: $e");
    }
  }

  File? profileImage;
  String? url;
  String? path;
  SupabaseClient supabase = Supabase.instance.client;

  Future<void> pickImage() async {
    emit(PickProfileImageLoading());
    XFile? xFileImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (xFileImage != null) {
      profileImage = File(xFileImage.path);
      emit(PickProfileImageSuccess(profileImage!));
    } else {
      emit(PickProfileImageError("No Image Selected"));
    }
  }

  Future<String?> uploadImageToSupabase() async {
    try {
      path = basename(profileImage!.path);
      DateTime date = DateTime.now();

      await supabase.storage
          .from("chat_app")
          .upload("${path!}_$date", profileImage!);

      url = supabase.storage.from('chat_app').getPublicUrl("${path!}_$date");
      return url;
    } catch (e) {
      log("Upload Error: $e");
      emit(UpdateProfileImageError(e.toString()));
      return null;
    }
  }

  Future<void> updateImageProfile() async {
    try {
      emit(UpdateProfileImageLoading());
      final imageUrl = await uploadImageToSupabase();
      if (imageUrl != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .update({'image': imageUrl});

        await CacheHelper.saveData(key: 'image', value: imageUrl);
        emit(UpdateProfileImageSuccess());
      } else {
        emit(UpdateProfileImageError("Failed to upload image"));
      }
    } catch (e) {
      emit(UpdateProfileImageError(e.toString()));
      log("Update Image Error: $e");
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      emit(SignOutLoading());

      await FirebaseAuth.instance.signOut();
      await CacheHelper.clearData();

      // close();

      emit(SignOutSuccess());

      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginView.routeName,
        (route) => false,
      );
    } catch (e) {
      emit(SignOutError(e.toString()));
      log("SignOut Error: $e");
    }
  }
}
