import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:philanthrobid/MyLoginPage.dart';
import 'package:philanthrobid/biddingPage.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main()async{
  
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override

  _MyAppState createState(){
    return _MyAppState();
    }
}

class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title:"Philanthrobid",
      home:MyLoginPage(),
      theme:ThemeData(
        primarySwatch:Colors.lightBlue,

      ),
    );
  }
}