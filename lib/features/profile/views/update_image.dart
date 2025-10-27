import 'package:chat_app/core/utils/style/screen_size.dart';
import 'package:chat_app/features/profile/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UpdateImage extends StatefulWidget {
  const UpdateImage({super.key});
  static String routeName = '/updateImage';
  @override
  State<UpdateImage> createState() => _UpdateImageState();
}

class _UpdateImageState extends State<UpdateImage> {
  @override
  Widget build(BuildContext context) {
    String image = ModalRoute.of(context)!.settings.arguments as String;
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is UpdateProfileImageSuccess) {
          Navigator.pop(context);
        } else if (state is UpdateProfileImageError) {
          {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is UpdateProfileImageLoading,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    BlocProvider.of<ProfileCubit>(context).updateImageProfile();
                  },
                  icon: const Icon(Icons.done),
                ),
              ],
            ),
            body: Center(
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<ProfileCubit>(context).pickImage();
                },
                child: CircleAvatar(
                  radius: ScreenSize.width / 2,
                  backgroundImage:
                      BlocProvider.of<ProfileCubit>(context).profileImage !=
                          null
                      ? FileImage(
                          BlocProvider.of<ProfileCubit>(context).profileImage!,
                        )
                      : NetworkImage(image),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
