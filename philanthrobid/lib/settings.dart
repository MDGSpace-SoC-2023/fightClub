import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:philanthrobid/MyLoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:philanthrobid/crud.dart";

class settings extends StatefulWidget{
  const settings({super.key});
  @override

  _settingsState createState(){
   return _settingsState(); 
  }

}
   
class _settingsState extends State<settings>{
  void selectImage(){}
  @override
  Widget build (BuildContext context)
  {
    return Scaffold(
      appBar:AppBar(
        title:const Text("Settings",style:TextStyle(color:Colors.white,)),
        backgroundColor:const Color.fromARGB(255, 246, 179, 202),
        centerTitle:true,
      ),
      body:Column(children:[Text("Personal Details",style:TextStyle(fontSize: 20,)),

      Stack(clipBehavior:Clip.none,children:<Widget>[CircleAvatar(radius:60,backgroundColor:Color.fromARGB(255, 246, 179, 202),child:CircleAvatar(radius:55,backgroundImage: NetworkImage("https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg?w=826&t=st=1702759064~exp=1702759664~hmac=23fda1ea7c53e7731fd76b69a2d6cda0b0f389c4f30fb6445f72acd274d2a5a1"),),
      
      ),
      Positioned(top:80,left:80,child:CircleAvatar(backgroundColor:Color.fromARGB(255, 246, 179, 202),child:IconButton(icon:Icon(Icons.add_a_photo,color:Colors.white,),onPressed:selectImage,splashColor:Colors.black,),),)
      ],
      ),
      Container(child:Text(""),),

      Center(child:TextButton(child:Text("Logout",style:TextStyle(fontSize:20,),),
      onPressed:(){Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context){
          return MyLoginPage();
        },)
      );

      },
      style:ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(255, 246, 179, 202),),foregroundColor:MaterialStateProperty.all<Color>(Colors.white),)
      
      ), 
      ),
      ]
    )
    );

  }
}