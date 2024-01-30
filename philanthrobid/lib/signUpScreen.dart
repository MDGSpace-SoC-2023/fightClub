/*import 'package:flutter/material.dart';
import 'package:philanthrobid/MyLoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:philanthrobid/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:http/http.dart" as http;
import "dart:convert";

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
  String sendUserApiURL = "http://10.0.2.2:8000/philanthrobid/users"; //will be changed from usual 8000
  //bool dataSentToback=false;//created so that state can be set on sending data to backend whcih can be used as a condition to send data to firestore,
  //allows to ensure no two people with same user name can be created 



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
          String email=_emailController.text.toLowerCase().trim();
          String password=_passwordController.text.trim();
          String repassword=_repasswordController.text.trim();
          String userName=_usernameController.text.trim();
          
          void sendUserToBack()async{
              var sendingData={
              "username":userName,
              "email":email,
              
            };
            try{
            var response = await http.post(Uri.parse(sendUserApiURL),
            headers: {
              "Content-Type":"application/json" //can add other headers 
            },
            body: jsonEncode(sendingData),);
            if (response.statusCode ==201){
              print("Data sent to backend");
              //setState(() {
              //  dataSentToback=true;
              //});
              UserCredential userCredential= await _auth.createUserWithEmailAndPassword(email: email, password: password);
            Navigator.pushNamedAndRemoveUntil(context,
            "/homePage",
            (route)=>false);
            await _firestore.collection("users").doc(userCredential.user?.uid).set({
              "Username":userName,
              "ProfilePicture":"https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg?w=740&t=st=1703611707~exp=1703612307~hmac=d5c08a37edb8913608611752171bd6796bcdf0e1ff8ea65fb13a5e0475c36135"
              
            });
            }
            else{
              print("An error happened ${response.statusCode}");
              print("Response body ${response.body}");
              if (response.body=='{"username":["user with this username already exists."]}'){
                setState((){
                  errorPass="Sorry that username is already taken!";
                });
              }
              else if((response.body=='{"email":["This field may not be blank."]}')||(response.body=='{"username":["This field may not be blank."]}')||(response.body=='{"username":["This field may not be blank."],"email":["user with this email already exists."]}')||(response.body=='{"username":["user with this username already exists."],"email":["This field may not be blank."]}')){
                setState((){
                  errorPass="No value may be null";

                });

              }
              else if ((response.body=='{"email":["user with this email already exists."]}')||(response.body=='{"username":["user with this username already exists."],"email":["user with this email already exists."]}')){
                setState((){
                  errorPass="That email-id has already been registered.";
                  });}
              else if (response.body.contains('{"email":["Enter a valid email address."]}')){
                setState(() {
                  errorPass="Please enter a valid e-mail address";
                });
              }
              else{
                setState(() {
                  errorPass="Please enter valid credentials for Sign-up";
                });
              }
              
            }
            }catch(e){
              print("Error happended $e");
              
            }
            }

          if ((repassword==password)&&(password!="")){
          try{
            sendUserToBack();
            //if(dataSentToback==true){
            //UserCredential userCredential= await _auth.createUserWithEmailAndPassword(email: email, password: password);
            //Navigator.pushAndRemoveUntil(context,
            //MaterialPageRoute(builder: (BuildContext context){
            //  return const homeScreen();
            //},),
            //(route)=>false);
            //await _firestore.collection("users").doc(userCredential.user?.uid).set({
              //"Username":userName,
              //"ProfilePicture":"https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg?w=740&t=st=1703611707~exp=1703612307~hmac=d5c08a37edb8913608611752171bd6796bcdf0e1ff8ea65fb13a5e0475c36135"
              
           // });
            //}
            //stuff here for sending to api
            

            
          }
          catch(e){
            print("REG ERROR");
            print("This is e:$e");
            
          }
          }
          else{
            if((password!="")||(repassword!="")){
            setState((){errorPass="Password and Confirmed Passwords don't match";});}
            else{
              setState((){
                errorPass="Password can't be empty";

              });
            }
          }
        } ,style:ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(255, 246, 179, 202),)), child:const Text("REGISTER",style:TextStyle(color:Colors.white,fontSize:20),)),
        
        TextButton(onPressed:(){
          Navigator.pushNamed(context,
          "/loginPage");
        },child:const Text("Have an account?Login"))
      ],
    ),
    )
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:philanthrobid/MyLoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:philanthrobid/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:http/http.dart" as http;
import "dart:convert";
import 'package:google_fonts/google_fonts.dart';

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
  String sendUserApiURL = "http://10.0.2.2:8000/philanthrobid/users"; //will be changed from usual 127.0.0.1
  //bool dataSentToback=false;//created so that state can be set on sending data to backend whcih can be used as a condition to send data to firestore,
  //allows to ensure no two people with same user name can be created 



  @override

  Widget build (BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:
        Container(
        height:double.infinity,
        decoration:BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,]
        )
        ),
        
        child: Column(
        children: 
        [ Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [const SizedBox(height: 80),
                Text("Register",style:GoogleFonts.ubuntu(textStyle:TextStyle(fontSize:38,color:Theme.of(context).colorScheme.outline,)),),
                Text("Welcome to Philanthrobid",style:GoogleFonts.ubuntu(textStyle:TextStyle(fontSize:23,color:Theme.of(context).colorScheme.outline,)),),
                const SizedBox(height: 40),
        
          ],
        ),

          Expanded(child: Container(
            decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 25),//add empty space
                  Container(margin:const EdgeInsetsDirectional.only(start:20,end:20,top:20),
                  child:TextField(
                controller:_usernameController,
                decoration:InputDecoration(
                hintText:"Username",
                enabledBorder:OutlineInputBorder(
                borderSide:BorderSide(color:Theme.of(context).colorScheme.tertiary),
                borderRadius:BorderRadius.circular(20)),    
              ),
              ),
                      ),
                      Container(margin:const EdgeInsetsDirectional.only(start:20,end:20,top:10),child:TextField(
              controller:_emailController,
              decoration:InputDecoration(
                hintText:"E-Mail ID",
                enabledBorder:OutlineInputBorder(
                borderSide:BorderSide(color:Theme.of(context).colorScheme.tertiary),
                borderRadius:BorderRadius.circular(20)),    
              ),
              ),
                      ),   
                      Container(margin:const EdgeInsetsDirectional.only(start:20,end:20,top:10,),child:TextField(
              controller:_passwordController,
              decoration:InputDecoration(
                hintText:"Password",
                enabledBorder:OutlineInputBorder(
                  borderSide:BorderSide(color:Theme.of(context).colorScheme.tertiary,),
                borderRadius:BorderRadius.circular(20)),    
              ),
              obscureText:true,
              ),
                      ),
                      Container(margin:const EdgeInsetsDirectional.only(start:20,end:20,top:10,bottom:25),child:TextField(
              controller: _repasswordController,
              decoration:InputDecoration(
                helperText:errorPass,
                helperStyle:TextStyle(color:Theme.of(context).colorScheme.error,),
                hintText:"Re-enter Password",
                enabledBorder:OutlineInputBorder(
                borderSide:BorderSide(color:Theme.of(context).colorScheme.tertiary),
                borderRadius:BorderRadius.circular(20)),    
              ),
              obscureText: true,
              
              ),
                      ),
                      TextButton(onPressed:()async{
              String email=_emailController.text.toLowerCase().trim();
              String password=_passwordController.text.trim();
              String repassword=_repasswordController.text.trim();
              String userName=_usernameController.text.trim();
              
              void sendUserToBack()async{
                  var sendingData={
                  "username":userName,
                  "email":email,
                  
                };
                try{
                var response = await http.post(Uri.parse(sendUserApiURL),
                headers: {
                  "Content-Type":"application/json" //can add other headers 
                },
                body: jsonEncode(sendingData),);
                if (response.statusCode ==201){
                  //setState(() {
                  //  dataSentToback=true;
                  //});
                  UserCredential userCredential= await _auth.createUserWithEmailAndPassword(email: email, password: password);
                Navigator.pushNamedAndRemoveUntil(context,
                "/homePage",
                (route)=>false);
                await _firestore.collection("users").doc(userCredential.user?.uid).set({
                  "Username":userName,
                  "ProfilePicture":"https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg?w=740&t=st=1703611707~exp=1703612307~hmac=d5c08a37edb8913608611752171bd6796bcdf0e1ff8ea65fb13a5e0475c36135"
                  
                });
                }
                else{
                  print("An error happened ${response.statusCode}");
                  print("Response body ${response.body}");
                  if (response.body=='{"username":["user with this username already exists."]}'){
                    setState((){
                      errorPass="Sorry that username is already taken!";
                    });
                  }
                  else if((response.body=='{"email":["This field may not be blank."]}')||(response.body=='{"username":["This field may not be blank."]}')||(response.body=='{"username":["This field may not be blank."],"email":["user with this email already exists."]}')||(response.body=='{"username":["user with this username already exists."],"email":["This field may not be blank."]}')){
                    setState((){
                      errorPass="No value may be null";
                      
                    });
                      
                  }
                  else if ((response.body=='{"email":["user with this email already exists."]}')||(response.body=='{"username":["user with this username already exists."],"email":["user with this email already exists."]}')){
                    setState((){
                      errorPass="That email-id has already been registered.";
                      });}
                  else if (response.body.contains('{"email":["Enter a valid email address."]}')){
                    setState(() {
                      errorPass="Please enter a valid e-mail address";
                    });
                  }
                  else{
                    setState(() {
                      errorPass="Please enter valid credentials for Sign-up";
                    });
                  }
                  
                }
                }catch(e){
                  print("Error happended $e");
                  
                }
                }
                      
              if ((repassword==password)&&(password!="")){
              try{
                sendUserToBack();
                //if(dataSentToback==true){
                //UserCredential userCredential= await _auth.createUserWithEmailAndPassword(email: email, password: password);
                //Navigator.pushAndRemoveUntil(context,
                //MaterialPageRoute(builder: (BuildContext context){
                //  return const homeScreen();
                //},),
                //(route)=>false);
                //await _firestore.collection("users").doc(userCredential.user?.uid).set({
                  //"Username":userName,
                  //"ProfilePicture":"https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg?w=740&t=st=1703611707~exp=1703612307~hmac=d5c08a37edb8913608611752171bd6796bcdf0e1ff8ea65fb13a5e0475c36135"
                  
               // });
                //}
                //stuff here for sending to api
                
                      
                
              }
              catch(e){
                print("REG ERROR");
                print("This is e:$e");
                
              }
              }
              else{
                if((password!="")||(repassword!="")){
                setState((){errorPass="Password and Confirmed Passwords don't match";});}
                else{
                  setState((){
                    errorPass="Password can't be empty";
                      
                  });
                }
              }
                      } ,style:ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.tertiary,)), 
                      child:Text("Register",style:TextStyle(color:Theme.of(context).colorScheme.outline,fontSize:20),)),
                      
                      TextButton(onPressed:(){
              Navigator.pushNamed(context,
              "/loginPage");
                      },child:Text("Have an account? Login", style: TextStyle(color: Colors.grey.shade400, fontSize: 15),))
                  ]
                  ),
            ),
          )
              )
        
        ],
            )
    ),
    )
      ;
  }
}
