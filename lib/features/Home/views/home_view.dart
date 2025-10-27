import 'package:chat_app/core/cubit/theme_cubit.dart';
import 'package:chat_app/core/utils/style/screen_size.dart';
import 'package:chat_app/data/chat_view_model.dart';
import 'package:chat_app/features/Home/cubit/chat_cubit.dart';
import 'package:chat_app/features/Home/data/chat_model.dart';
import 'package:chat_app/features/Home/views/chat_view.dart';
import 'package:chat_app/features/Home/widgets/chat_card.dart';
import 'package:chat_app/features/profile/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static String routeName = 'home-view';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    context.select((ThemeCubit cubit) => cubit.state == ThemeMode.dark);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenSize.width / 25,
            vertical: ScreenSize.height / 50,
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search Chat",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: ScreenSize.height / 50),

              TabBar(
                controller: _tabController,
                indicatorColor: Colors.purple,
                labelColor: Colors.purple,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: "Chats"),
                  Tab(text: "Friends"),
                  Tab(text: "Calls"),
                ],
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    StreamBuilder<List<ChatModel>>(
                      stream: BlocProvider.of<ChatCubit>(
                        context,
                      ).getLastTimeMessages(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          List<ChatModel> chatList = snapshot.data!;

                          final filteredChats = chatList.where((chat) {
                            final name = chat.user.name.toLowerCase();
                            final lastMsg = chat.lastMessage.toLowerCase();
                            return name.contains(searchQuery) ||
                                lastMsg.contains(searchQuery);
                          }).toList();

                          return ListView.builder(
                            itemCount: filteredChats.length,
                            itemBuilder: (context, index) {
                              final chat = filteredChats[index];
                              return ChatCardWidget(
                                chatViewModel: ChatViewModel(
                                  name: chat.user.name,
                                  message: chat.lastMessage,
                                  time: DateFormat.Hm().format(
                                    chat.lastMessageTime,
                                  ),
                                  avatarUrl: chat.user.image ?? "",
                                  unReadMessageCount: 0,
                                  isOnline: true,
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ChatView.routeName,
                                    arguments: chat.user,
                                  );
                                },
                              );
                            },
                          );
                        }
                        return const Center(child: Text("No chats found"));
                      },
                    ),

                    Center(
                      child: Text(
                        "Friends list coming soon...",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),

                    Center(
                      child: Text(
                        "Calls will be here...",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        height: ScreenSize.height / 10,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ScreenSize.width / 15),
            topRight: Radius.circular(ScreenSize.width / 15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
              onPressed: () {},
            ),

            IconButton(
              icon: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
              onPressed: () {
                Navigator.pushNamed(context, ProfileView.routeName);
              },
            ),

            IconButton(
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    bool isDark =
                        context.read<ThemeCubit>().state == ThemeMode.dark;
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text("Choose Theme"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.light_mode,
                              color: Colors.orange,
                            ),
                            title: const Text("Light Mode"),
                            onTap: () {
                              if (isDark) {
                                context.read<ThemeCubit>().toggleTheme();
                              }
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.dark_mode,
                              color: Colors.purple,
                            ),
                            title: const Text("Dark Mode"),
                            onTap: () {
                              if (!isDark) {
                                context.read<ThemeCubit>().toggleTheme();
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
