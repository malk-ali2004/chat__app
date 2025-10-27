import 'package:chat_app/core/utils/style/screen_size.dart';
import 'package:chat_app/data/user_types.dart';
import 'package:chat_app/features/Auth/cubit/auth_cubit.dart';
import 'package:chat_app/features/Auth/views/login_view.dart';
import 'package:chat_app/features/Auth/widgets/header_widget.dart';
import 'package:chat_app/features/Auth/widgets/normal_text_field.dart';
import 'package:chat_app/features/Auth/widgets/secret_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  static String routeName = "register-view";

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> nameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();

  UserType? selectedUserType;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          Navigator.pushReplacementNamed(context, LoginView.routeName);
        } else if (state is RegisterError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is RegisterLoading,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenSize.width / 15,
                  vertical: ScreenSize.height / 40,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new),
                      ),

                      HeaderWidget(
                        title: "Join Us Today",
                        subtitle:
                            "Sign up now and start connecting with people around you easily and securely.",
                      ),

                      SizedBox(height: ScreenSize.height / 20),

                      NormalTextField(
                        title: "Name",
                        controller: nameController,
                        formKey: nameFormKey,
                      ),
                      SizedBox(height: ScreenSize.height / 25),

                      NormalTextField(
                        title: "Email Address",
                        controller: emailController,
                        formKey: emailFormKey,
                      ),
                      SizedBox(height: ScreenSize.height / 25),

                      SecretTextField(
                        title: "Password",
                        controller: passwordController,
                        formKey: passwordFormKey,
                      ),
                      SizedBox(height: ScreenSize.height / 25),

                      Padding(
                        padding: EdgeInsets.only(left: ScreenSize.width / 40),
                        child: Text(
                          "Select Your Position",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      SizedBox(height: ScreenSize.height / 80),

                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        children: [
                          _positionOption(UserType.instructor, "Instructor"),
                          _positionOption(UserType.student, "Student"),
                          _positionOption(UserType.developer, "Developer"),
                        ],
                      ),

                      SizedBox(height: ScreenSize.height / 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7A1FA2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            if (nameFormKey.currentState!.validate() &&
                                emailFormKey.currentState!.validate() &&
                                passwordFormKey.currentState!.validate() &&
                                selectedUserType != null) {
                              context.read<AuthCubit>().register(
                                email: emailController.text,
                                password: passwordController.text,
                                name: nameController.text,
                                position: selectedUserType!.name,
                              );
                            } else if (selectedUserType == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please select your position"),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: ScreenSize.height / 25),

                      Row(
                        children: [
                          const Expanded(
                            child: Divider(thickness: 1, color: Colors.grey),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "Or Sign Up with",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const Expanded(
                            child: Divider(thickness: 1, color: Colors.grey),
                          ),
                        ],
                      ),

                      SizedBox(height: ScreenSize.height / 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialIconButton("assets/icons/google.jpeg", () {
                            context.read<AuthCubit>().signInWithGoogle();
                          }),
                          SizedBox(width: ScreenSize.width / 15),

                          _socialIconButton("assets/icons/apple.png", () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Apple login not available yet"),
                              ),
                            );
                          }),
                          SizedBox(width: ScreenSize.width / 15),

                          _socialIconButton("assets/icons/facebook.png", () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Facebook login not available yet",
                                ),
                              ),
                            );
                          }),
                        ],
                      ),

                      SizedBox(height: ScreenSize.height / 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                LoginView.routeName,
                              );
                            },
                            child: const Text("Sign In"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _positionOption(UserType type, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<UserType>(
          fillColor: WidgetStateProperty.all(const Color(0xFF7A1FA2)),
          value: type,
          groupValue: selectedUserType,
          onChanged: (v) {
            setState(() {
              selectedUserType = v;
            });
          },
        ),
        Text(label),
      ],
    );
  }

  Widget _socialIconButton(String asset, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey.shade100,
        child: Image.asset(asset, height: 28),
      ),
    );
  }
}
