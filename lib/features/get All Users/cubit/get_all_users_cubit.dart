import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app/features/Auth/data/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'get_all_users_state.dart';

class GetAllUsersCubit extends Cubit<GetAllUsersState> {
  GetAllUsersCubit() : super(GetAllUsersInitial());
  getAllUsers() async {
    try {
      emit(GetAllUsersLoading());
      final usersdocs = await FirebaseFirestore.instance
          .collection('users')
          .get();
      List<UserModel> users = usersdocs.docs
          .where(
            (e) =>
                e.data()['email'] != FirebaseAuth.instance.currentUser!.email,
          )
          .map((e) => UserModel.fromJson(e.data()))
          .toList();
      emit(GetAllUsersSuccess(users));
    } catch (e) {
      emit(GetAllUsersError(e.toString()));
      log(e.toString());
    }
  }
}
