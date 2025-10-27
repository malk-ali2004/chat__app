// import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
// import 'package:meta/meta.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);
  void toggleTheme() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    String mode = json["mode"] as String;
    return mode == "light" ? ThemeMode.light : ThemeMode.dark;
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    final mode = state == ThemeMode.light ? "light" : "dark";
    return {"mode": mode};
  }
}
