import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:philanthrobid/MyLoginPage.dart';
import 'package:philanthrobid/addAListing.dart';
import 'package:philanthrobid/biddingPage.dart';
import 'package:philanthrobid/homeScreen.dart';
import 'package:philanthrobid/leaderboard.dart';
import 'package:philanthrobid/settings.dart';
import 'package:philanthrobid/signUpScreen.dart';
import 'package:philanthrobid/winningPage.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_stripe/flutter_stripe.dart";

Future<void> main()async{
  
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey=dotenv.env["stripePublishableKey"]??"123";
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
      home:MainPage(),
      theme:ThemeData(
        primarySwatch:Colors.lightBlue,

      ),
      routes:{
        "/loginPage":(context)=> const MyLoginPage(),
        "/signUpPage":(context)=> const signUpScreen(),
        "/settingsPage":(context)=> const settings(),
        "/homePage":(context)=>const homeScreen(),
        "/addListingPage":(context)=>const addAListing(),
        "/leaderboardPage":(context)=>Leaderboard(),
        
      }
      
    );
  }
}
class MainPage extends StatelessWidget{
  const MainPage({super.key});
@override
  
  Widget build(BuildContext context){

    return Scaffold(
      body:StreamBuilder<User?>(stream:FirebaseAuth.instance.authStateChanges(),
      builder: (context,snapshot){
        if(snapshot.hasData){
          return const homeScreen();
        }else{
          return const  MyLoginPage();
        }
        
        
      },
      
      )
    
    );
  }
}
