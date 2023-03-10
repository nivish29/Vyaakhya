import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/utils/Routes/Route_name.dart';
import 'package:movie_app/utils/Routes/routes.dart';
import 'package:camera/camera.dart';
import 'package:movie_app/view_model/Provider/password_provider.dart';
import 'package:movie_app/view_model/popular_tv_viewModel.dart';
import 'package:provider/provider.dart';

List<CameraDescription>? cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PasswordProvider()),
        ChangeNotifierProvider<popularTvViewModel>(
            create: (_) => popularTvViewModel()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const MyHomePage(title: 'Flutter Demo Home Page')
        //routes
        initialRoute: RouteName.entry,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
