import 'package:chat_app/core/utils/style/screen_size.dart';
import 'package:chat_app/features/Auth/views/login_view.dart';
import 'package:chat_app/features/profile/cubit/profile_cubit.dart';
import 'package:chat_app/features/profile/views/update_image.dart';
import 'package:chat_app/features/profile/widgets/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  static String routeName = '/profile';

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getUser(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is SignOutSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "تم تسجيل الخروج بنجاح ",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.purple,
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              LoginView.routeName,
              (route) => false,
            );
          } else if (state is SignOutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("حدث خطأ أثناء تسجيل الخروج \n${state.message}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GetProfileLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is GetProfileSuccess) {
            final user = state.userModel;
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Profile",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          UpdateImage.routeName,
                          arguments: user.image,
                        );
                      },
                      child: CircleAvatar(
                        radius: ScreenSize.width / 3.5,
                        backgroundColor: Colors.purple.shade100,
                        backgroundImage: user.image != null
                            ? NetworkImage(user.image!)
                            : null,
                        child: user.image == null
                            ? const Icon(
                                Icons.person,
                                size: 90,
                                color: Colors.purple,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ProfileCardWidget(vKey: "Name", value: user.name),
                    ProfileCardWidget(vKey: "Email", value: user.email),
                    ProfileCardWidget(vKey: "Position", value: user.postiton),
                    const SizedBox(height: 30),
                    if (state is SignOutLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<ProfileCubit>().signOut(context);
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text("Sign Out"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          minimumSize: Size(ScreenSize.width / 1.5, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }

          // 🔹 في حالة الخطأ
          if (state is GetProfileError) {
            return Scaffold(
              body: Center(
                child: Text(
                  "حدث خطأ أثناء تحميل الملف الشخصي ",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
