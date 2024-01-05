import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import "package:http/http.dart" as http;
import "package:philanthrobid/homeScreen.dart";

class biddingPage extends StatefulWidget {
  Map<String,Object?> sendingData={};
  biddingPage({super.key, required this.sendingData});
  

  @override
  State<biddingPage> createState() => _biddingPage();
}

class _biddingPage extends State<biddingPage>{
  String getListingsURL="http://10.0.2.2:8000/philanthrobid/listings";
  bool TextFieldShown=false;
  final TextEditingController bidField = TextEditingController();
  @override
  



  Widget build(BuildContext context){
    String toBeDisplayed;
    int bid= widget.sendingData["selectedBid"] as int;
    int minInc = widget.sendingData["selectedMinInc"] as int;
    int strtbid =widget.sendingData["selectedStarterBid"] as int;
    int listingId=widget.sendingData["selectedID"]as int;
    
    
        if(widget.sendingData["selectedBid"]!=0){
          toBeDisplayed="Current Bid -\u{20B9}${widget.sendingData["selectedBid"]}\nMinimum Increment -\u{20B9}${widget.sendingData["selectedMinInc"]}";
        }
        else{
          toBeDisplayed="Starting Bid -\u{20B9}${widget.sendingData["selectedStarterBid"]}";
        }
    return Scaffold(
      appBar: AppBar(
        title:const Text("LET THE BIDDING BEGIN!",
        style: TextStyle(color:Colors.white),),
        centerTitle:true,
        backgroundColor:const Color.fromARGB(255, 246, 179, 202),
      ),
      body:Column(children: [Container(alignment:Alignment.center,
      margin:const EdgeInsets.all(5),
      child: Text(widget.sendingData["selectedTitle"]as String,
      style:const TextStyle(fontSize: 32,
      decoration:TextDecoration.underline ),
      )),
      Container(decoration: BoxDecoration(border: Border.all(),
      borderRadius: BorderRadius.circular(10)),
      padding:const EdgeInsets.all(10),
      alignment: AlignmentDirectional.topStart,
      margin:const EdgeInsetsDirectional.only(start:15,end:15,top:10,bottom:10),
      child: Text(widget.sendingData["selectedDescription"]as String,
      style: const TextStyle(fontSize:16,
      color:Colors.lightBlue),)),
      
      Container(margin:const EdgeInsetsDirectional.only(start:25,end:25,top:10,bottom:10),
      decoration: BoxDecoration(border: Border.all(),
      borderRadius: BorderRadius.circular(10)),
      padding:const EdgeInsets.all(10),
      alignment: Alignment.center,
      child:Text(toBeDisplayed,
      style: const TextStyle(
          color: Colors.lightGreen,
          fontSize:20,
        ),)
        ),
      AnimatedSwitcher(
        duration:const Duration(milliseconds:300),
        child:TextFieldShown?Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration:BoxDecoration(border: Border.all(),
              borderRadius: BorderRadius.circular(10)),
              margin:const EdgeInsetsDirectional.only(start:80,end:80,bottom:10),
              padding:const EdgeInsets.all(10),
                  child: TextField(
                  controller:bidField,
                  keyboardType:TextInputType.number,
                  inputFormatters:<TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  decoration:const InputDecoration(hintText:"ENTER BID"),
                  ),
                ),
                TextButton(
          style:ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(255, 139, 195, 74))),
        onPressed:()async{
          DocumentSnapshot named =await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).get();
          String name=named["Username"];
          int amntBid=int.parse(bidField.text);
          print (amntBid);
          if(bid!=0&&(amntBid>=bid+minInc)){
            void makingBid()async{
              
              print (listingId);
              
              
              
              var sendingData={
                
                "list_id":listingId,
                "bid":amntBid,
                "username":name
              };
              try{
                var response = await http.patch(Uri.parse(getListingsURL),
                headers:{
                  "Content-type":"application/json"
                },
                body:jsonEncode(sendingData));
                if(response.statusCode==200){
                  print("Patched Succesfully");
                  Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (BuildContext context){
                  return const homeScreen();
                  },),
                  (route)=>false);
                  
                }
                else{
                  print(response.statusCode);
                  print(response.body);
                }
              
            }catch(e){
              print (e);
            }}
            makingBid();
            


          }
          else if(bid!=0 &&(amntBid<bid+minInc)){
            FocusScope.of(context).unfocus();
            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content:Container(
                              padding: const EdgeInsets.all(16),
                              height:100,
                              decoration: BoxDecoration(color: Colors.red,
                              borderRadius: BorderRadius.circular(20)),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text('Sorry!',style: TextStyle(fontSize:18),),
                                  Text("The Bid must be greater than the Current Bid by atleast the Minimum Increment Value"),
                                ],
                              )),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,//removes border thingy due to snackbars edges
                            elevation:0,//removes weird shadow
                            duration:const Duration(seconds:3),
                            ),
                            

                          );


          }
          else if(bid==0&&(amntBid>=strtbid)){
            void makingBid()async{
              
              print (listingId);
              
              
              
              var sendingData={
                
                "list_id":listingId,
                "bid":amntBid,
                "username":name
              };
              try{
                var response = await http.patch(Uri.parse(getListingsURL),
                headers:{
                  "Content-type":"application/json"
                },
                body:jsonEncode(sendingData));
                if(response.statusCode==200){
                  print("Patched Succesfully");
                }
                else{
                  print(response.statusCode);
                  print(response.body);
                }
              
            }catch(e){
              print (e);
            }}
            makingBid();
            Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (BuildContext context){
              return const homeScreen();
            },),
            (route)=>false);

          }
          else{
            FocusScope.of(context).unfocus();
            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content:Container(
                              padding: const EdgeInsets.all(16),
                              height:90,
                              decoration: BoxDecoration(color: Colors.red,
                              borderRadius: BorderRadius.circular(20)),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text('Sorry!',style: TextStyle(fontSize:18),),
                                  Text("The Bid must be greater than the Starting Bid"),
                                ],
                              )),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,//removes border thingy due to snackbars edges
                            elevation:0,//removes weird shadow
                            duration:const Duration(seconds:3),
                            ),
                            

                          );

          }

         
        },
        child:const Text("PLACE BID",
        style:TextStyle(
          color:Colors.white,
          fontSize: 20,
        )
        )
        )

          ],
        ) 
        :TextButton(
          style:ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(255, 139, 195, 74))),
        onPressed:(){
          setState(() {
            TextFieldShown=true;
          });
        },
        child:const Text("BID",
        style:TextStyle(
          color:Colors.white,
          fontSize: 20,
        )
        )
        )
      ),
      
        
      ],)
    );

  }
}