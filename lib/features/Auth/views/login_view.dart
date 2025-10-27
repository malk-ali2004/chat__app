import 'package:chat_app/core/utils/style/screen_size.dart';
import 'package:chat_app/features/Auth/cubit/auth_cubit.dart';
import 'package:chat_app/features/Home/views/home_view.dart';
import 'package:chat_app/features/Auth/widgets/header_widget.dart';
import 'package:chat_app/features/Auth/widgets/normal_text_field.dart';
import 'package:chat_app/features/Auth/widgets/secret_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  static String routeName = 'login-view';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushReplacementNamed(context, HomeView.routeName);
        } else if (state is LoginError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is LoginLoading,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Padding(
              padding: EdgeInsets.only(top: ScreenSize.height / 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HeaderWidget(
                      title: "Hello, Welcome Back",
                      subtitle:
                          "Happy to see you again, to use your account please login first.",
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: ScreenSize.height / 15,
                        left: ScreenSize.width / 30,
                        right: ScreenSize.width / 30,
                      ),
                      child: Column(
                        children: [
                          NormalTextField(
                            title: "Email Address",
                            controller: emailController,
                            formKey: emailFormKey,
                          ),
                          SizedBox(height: ScreenSize.height / 20),
                          SecretTextField(
                            title: "Password",
                            controller: passwordController,
                            formKey: passwordFormKey,
                          ),
                          SizedBox(height: ScreenSize.height / 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Forgot Password?",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenSize.height / 20),
                          SizedBox(
                            width: ScreenSize.width / 1.2,
                            child: ElevatedButton(
                              onPressed: () {
                                if (emailFormKey.currentState!.validate() &&
                                    passwordFormKey.currentState!.validate()) {
                                  context.read<AuthCubit>().login(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              style: Theme.of(
                                context,
                              ).elevatedButtonTheme.style,
                              child: const Text("Login"),
                            ),
                          ),
                          SizedBox(height: ScreenSize.height / 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    'register-view',
                                  );
                                },
                                child: const Text("Sign Up"),
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenSize.height / 20),

                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  "Or Login with",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
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
                                    content: Text(
                                      "Apple login not available yet",
                                    ),
                                  ),
                                );
                              }),
                              SizedBox(width: ScreenSize.width / 15),

                              _socialIconButton(
                                "assets/icons/facebook.png",
                                () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Facebook login not available yet",
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
