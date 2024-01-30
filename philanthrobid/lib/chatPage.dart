import "dart:developer";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "dart:convert";
import 'package:philanthrobid/listings.dart';
import "package:philanthrobid/messagingPage.dart";
import "package:philanthrobid/winningPage.dart";

class chatPage extends StatefulWidget{
  const chatPage({super.key});

  @override
  
  chatPageState createState(){
    return chatPageState();
  }
}

class chatPageState extends State<chatPage>{
  @override
  void initState(){
    super.initState();
    chckIfInGrp();
  }
  String name="";
  int no_of_conv=0;
  List<Conversation>? convList=[];
  Future<void> getName()async{
    DocumentSnapshot named =await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).get();

      name=named["Username"];

  }
   Future <void>chckIfInGrp()async{
    print ("funcn accesed");
    await getName();
    var response=await http.get(Uri.parse("http://10.0.2.2:8000/philanthrobid/Conversations/?username=$name"));
    if (response.statusCode==200){
      final List<dynamic> jsonList=json.decode(response.body);
      setState(() {
        no_of_conv=jsonList.length;
        convList=jsonList.map((item)=>Conversation.fromJson(item)).toList();//converts from list of dictionary to list of MessageGroup
        
      });
      
    }


   }


  Widget build (BuildContext context){   
    return Scaffold(
      
      body:Column(
        
        children: [
        
        (convList!.isNotEmpty)?(Expanded(child:ListView.builder(itemCount:convList!.length,
        itemBuilder: (context,index){
          return Container(
            margin:const EdgeInsetsDirectional.only(start:5,end:5),
            child: Card(child:ListTile(
              onTap:()async{
                
                Navigator.push(context,
                MaterialPageRoute(builder:( BuildContext context){
                  return messagingPage(sendingData: {
                    "group_id":convList![index].group_id,
                    "created_at":convList![index].created_at,
                    "winner":convList![index].winner,
                    "seller":convList![index].seller,
                    "Listingtitle":convList![index].Listingtitle

                  });
                }));
              },
              title:Text(convList![index].Listingtitle,
              maxLines:2,
              style:const TextStyle(color:Colors.lightBlue),)
            )),
          );

        },))):
        const Center(
          child: Text(
            "Sorry, win an auction to chat with the consignor",
            style: TextStyle(color:Colors.grey),
            
          ),
        )
      ],)
      

    );
  }
}