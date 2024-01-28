import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:philanthrobid/signUpScreen.dart';
import 'package:philanthrobid/homeScreen.dart';
import 'package:google_fonts/google_fonts.dart';
class MyLoginPage extends StatefulWidget{
  const MyLoginPage({super.key});
  @override

  _MyLoginState createState(){
    return _MyLoginState();
  }
}

class _MyLoginState extends State<MyLoginPage>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth=FirebaseAuth.instance;
  String? errorMessage="";
  @override

  Widget build (BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:
        Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              ]
          ),
        ),
          child: Column(
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                SizedBox(height: 130),
                Text("Login",style:GoogleFonts.ubuntu(textStyle: TextStyle(fontSize:38,color:Theme.of(context).colorScheme.outline,)),),
                Text("Welcome to Philanthrobid",style:GoogleFonts.ubuntu(textStyle:TextStyle(fontSize:23,color:Theme.of(context).colorScheme.outline,)),),
                const SizedBox(height: 70),
                ]
                ),

                Expanded(child:
                Container(
          decoration:  BoxDecoration(
            color: Theme.of(context).colorScheme.background,//white12.withOpacity(0.8),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          ),
        child: SingleChildScrollView(
          child: Column(
          
            children: [
              const SizedBox(height: 30),
          Container(margin:const EdgeInsetsDirectional.only(start:20,end:20,top:20),
                child:TextField(
                controller: _emailController,
          
                decoration:InputDecoration(
                  hintText:"E-Mail ID",
                  enabledBorder:OutlineInputBorder(
                      borderSide:BorderSide(color:Theme.of(context).colorScheme.tertiary),
                      borderRadius:BorderRadius.circular(20)),
                ),
              ),
              ),
          Container(margin:const EdgeInsetsDirectional.only(start:20,end:20,top:10,bottom:25),
                  child:TextField(
                  controller:_passwordController,
                  decoration:InputDecoration(
                    hintText:"Password",
                    helperText:errorMessage,
                    helperStyle:TextStyle(color:Theme.of(context).colorScheme.outline,),
                    enabledBorder:OutlineInputBorder(
                        borderSide:BorderSide(color:Theme.of(context).colorScheme.tertiary),
                        borderRadius:BorderRadius.circular(20)),
                  ),
                  obscureText:true,),
                ),
                TextButton(onPressed:()async{
                  String email=_emailController.text.trim();
                  String password=_passwordController.text.trim();
                  try{
                    UserCredential userCredential= await _auth.signInWithEmailAndPassword(
                      email:email,
                      password: password,
                    );
                    Navigator.pushNamedAndRemoveUntil(context,
                        "/homePage",
                            (route)=>false); //tells remove everything until nothing left
                  }catch(e){
                    print("Wrong Credentials");
                    setState((){errorMessage="Invalid Credentials";});
                  }
                } ,style:ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.tertiary)),
                    child:Text("Login",style:TextStyle(color:Theme.of(context).colorScheme.outline,fontSize:20),)),
                TextButton(
                  onPressed:(){
                  Navigator.pushNamed(context,
                    "/signUpPage",);
                },
                    child:Text("Don't have an account? Register", style: TextStyle(color: Colors.grey.shade400, fontSize: 15)),)
          
          ]),
        )
                ))]
        )
                )

    );
  }
}
