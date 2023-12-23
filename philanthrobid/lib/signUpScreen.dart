import 'package:flutter/material.dart';
import 'package:philanthrobid/MyLoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:philanthrobid/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class signUpScreen extends StatefulWidget{
  const signUpScreen({super.key});
  @override

  _signUpScreen createState(){
    return _signUpScreen();
  }
}

class _signUpScreen extends State<signUpScreen>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController =TextEditingController();
  final TextEditingController _usernameController =TextEditingController();
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? errorPass;
  @override

  Widget build (BuildContext context){
    return Scaffold(
      body:SingleChildScrollView(child:Column(children: [
        Container(alignment:Alignment.center ,
        height:200,
        margin:const EdgeInsetsDirectional.only(bottom:20),
        decoration:BoxDecoration(
          color:const Color.fromARGB(255, 246, 179, 202),
          border:Border.all(color:Colors.white,),
          borderRadius: BorderRadius.circular(25)
        ),child:const Text("Welcome to Philanthrobid",style:TextStyle(fontSize:30,color:Colors.white,),),
        
        ),
        
        const Text("Register",style:TextStyle(fontSize:20,decoration:TextDecoration.underline)), 
        Container(margin:const EdgeInsetsDirectional.only(start:20,end:20,top:20),child:TextField(
          controller:_usernameController,
          decoration:InputDecoration(
            hintText:"Username",
            enabledBorder:OutlineInputBorder(
            borderSide:const BorderSide(color:Color.fromARGB(255, 246, 179, 202),),
            borderRadius:BorderRadius.circular(20)),    
          ),
          ),
        ),
        Container(margin:const EdgeInsetsDirectional.only(start:20,end:20,top:10),child:TextField(
          controller:_emailController,
          decoration:InputDecoration(
            hintText:"E-Mail ID",
            enabledBorder:OutlineInputBorder(
            borderSide:const BorderSide(color:Color.fromARGB(255, 246, 179, 202),),
            borderRadius:BorderRadius.circular(20)),    
          ),
          ),
        ),   
        Container(margin:const EdgeInsetsDirectional.only(start:20,end:20,top:10,),child:TextField(
          controller:_passwordController,
          decoration:InputDecoration(
            hintText:"Password",
            enabledBorder:OutlineInputBorder(
              borderSide:const BorderSide(color:Color.fromARGB(255, 246, 179, 202),),
            borderRadius:BorderRadius.circular(20)),    
          ),
          obscureText:true,
          ),
        ),
        Container(margin:const EdgeInsetsDirectional.only(start:20,end:20,top:10,bottom:25),child:TextField(
          controller: _repasswordController,
          decoration:InputDecoration(
            helperText:errorPass,
            helperStyle:TextStyle(color:Colors.red,),
            hintText:"Re-enter Password",
            enabledBorder:OutlineInputBorder(
            borderSide:const BorderSide(color:Color.fromARGB(255, 246, 179, 202),),
            borderRadius:BorderRadius.circular(20)),    
          ),
          obscureText: true,
          
          ),
        ),
        TextButton(onPressed:()async{
          String email=_emailController.text.trim();
          String password=_passwordController.text.trim();
          String repassword=_repasswordController.text.trim();
          String userName=_usernameController.text.trim();
          if (repassword==password){
          try{
            
            UserCredential userCredential= await _auth.createUserWithEmailAndPassword(email: email, password: password);
            Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context){
              return const homeScreen();
            },),);
            await _firestore.collection("users").doc(userCredential.user?.uid).set({
              "Username":userName,
              "Email id":email,
            });
            
          }
          catch(e){
            print("REG ERROR");
            setState(() {
              errorPass="No value may be null";
            });
          }
          }
          else{
            setState((){errorPass="Password and Confirmed Passwords don't match";});
          }
        } ,style:ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(255, 246, 179, 202),)), child:const Text("REGISTER",style:TextStyle(color:Colors.white,fontSize:20),)),
        
        TextButton(onPressed:(){
          Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context){
            return const MyLoginPage();
          },
          ),);
        },child:const Text("Have an account?Login"))
      ],
    ),
    )
    );
  }
}
