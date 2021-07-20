import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:game_trophy_manager/Provider/internal_db_provider.dart';
import 'package:game_trophy_manager/Router/router.dart' as router;
import 'package:game_trophy_manager/Router/router_constant.dart';
import 'package:game_trophy_manager/Utilities/colors.dart';
import 'package:provider/provider.dart';
import 'Provider/game_provider.dart';
import 'Provider/guide_provider.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<GameProvider>(
            create: (context) => GameProvider(),
          ),
          ChangeNotifierProvider<GuideProvider>(
            create: (context) => GuideProvider(),
          ),
          ChangeNotifierProvider<InternalDbProvider>(
            create: (context) => InternalDbProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
              primaryColor: primaryColor,
              scaffoldBackgroundColor: primaryColor,
              accentColor: primaryColor),
          onGenerateRoute: router.generateRoute,
          initialRoute: splashScreenRoute,
        ),
      ),
    );
  }
}
