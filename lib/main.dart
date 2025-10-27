import 'package:chat_app/core/cubit/theme_cubit.dart';
import 'package:chat_app/core/database/cachhelper.dart';
import 'package:chat_app/core/utils/style/screen_size.dart';
import 'package:chat_app/core/utils/theme/app_theme.dart';
import 'package:chat_app/features/Auth/cubit/auth_cubit.dart';
import 'package:chat_app/features/Auth/data/user_model.dart';
import 'package:chat_app/features/Home/cubit/chat_cubit.dart';
import 'package:chat_app/features/Home/views/chat_view.dart';
import 'package:chat_app/features/Auth/views/get_started_view.dart';
import 'package:chat_app/features/Home/views/home_view.dart';
import 'package:chat_app/features/Auth/views/login_view.dart';
import 'package:chat_app/features/Auth/views/register_view.dart';
import 'package:chat_app/features/get%20All%20Users/views/get_all_users_view.dart';
import 'package:chat_app/features/profile/cubit/profile_cubit.dart';
import 'package:chat_app/features/profile/views/profile_view.dart';
import 'package:chat_app/features/profile/views/update_image.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    Supabase.initialize(
      url: 'https://toriwtbbwrwllstyceyr.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRvcml3dGJid3J3bGxzdHljZXlyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk5MjI0MTMsImV4cCI6MjA3NTQ5ODQxM30.cM2PxuynSrUrwoF-HOpKNIvxrawSJlHKkL1gCjxc3Xc',
    ),
    CacheHelper.init(),
  ]);
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    ScreenSize.initialize(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => ChatCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              final mq = MediaQuery.of(context);
              final width = mq.size.width;

              final baseScale = (width / 375).clamp(0.85, 1.25);

              final systemFactor = mq.textScaler.scale(baseScale);
              final isTablet = width >= 600;
              final tunedFactor =
                  (systemFactor * baseScale) * (isTablet ? 1.05 : 1.0);

              return MediaQuery(
                data: mq.copyWith(textScaler: TextScaler.linear(tunedFactor)),
                child: child!,
              );
            },
            routes: {
              GetStartedView.routeName: (context) => GetStartedView(),
              LoginView.routeName: (context) => LoginView(),
              RegisterView.routeName: (context) => RegisterView(),
              HomeView.routeName: (context) => HomeView(),
              ChatView.routeName: (context) {
                final user =
                    ModalRoute.of(context)!.settings.arguments as UserModel;
                return ChatView(receiverEmail: user.email, receiverUser: user);
              },
              ProfileView.routeName: (context) => ProfileView(),
              UpdateImage.routeName: (context) => UpdateImage(),
              GetAllUsersView.routeName: (context) => GetAllUsersView(),
            },

            initialRoute: FirebaseAuth.instance.currentUser == null
                ? GetStartedView.routeName
                : HomeView.routeName,
            theme: AppThemes.lightTheme,
            themeMode: mode,
            darkTheme: AppThemes.darkTheme,
          );
        },
      ),
    );
  }
}
