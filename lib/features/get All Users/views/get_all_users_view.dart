import 'package:chat_app/features/Home/views/chat_view.dart';
import 'package:chat_app/features/get%20All%20Users/cubit/get_all_users_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetAllUsersView extends StatefulWidget {
  const GetAllUsersView({super.key});
  static String routeName = 'GetAllUsersView';
  @override
  State<GetAllUsersView> createState() => _GetAllUsersViewState();
}

class _GetAllUsersViewState extends State<GetAllUsersView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetAllUsersCubit()..getAllUsers(),
      child: Scaffold(
        body: BlocBuilder<GetAllUsersCubit, GetAllUsersState>(
          builder: (context, state) {
            if (state is GetAllUsersSuccess) {
              return ListView.builder(
                itemCount: state.usersList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ChatView.routeName,
                        arguments: state.usersList[index],
                      );
                    },
                    leading: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        state.usersList[index].image!,
                      ),
                    ),
                    title: Text(state.usersList[index].name),
                    subtitle: Text(state.usersList[index].postiton),
                  );
                },
              );
            } else if (state is GetAllUsersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text('Error'));
            }
          },
        ),
      ),
    );
  }
}
