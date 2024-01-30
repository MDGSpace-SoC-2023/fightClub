import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import "package:http/http.dart" as http;
import "package:philanthrobid/homeScreen.dart";
import "package:google_fonts/google_fonts.dart";

class biddingPage extends StatefulWidget {
  Map<String,Object?> sendingData={};
  biddingPage({super.key, required this.sendingData});
  

  @override
  State<biddingPage> createState() => _biddingPage();
}

class _biddingPage extends State<biddingPage>{
  String getListingsURL="http://10.0.2.2:8000/philanthrobid/listings/";
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
          toBeDisplayed="Current Bid: -\u{20B9}${widget.sendingData["selectedBid"]}\nMinimum Increment -\u{20B9}${widget.sendingData["selectedMinInc"]}";
        }
        else{
          toBeDisplayed="Base Price: -\u{20B9}${widget.sendingData["selectedStarterBid"]}";
        }
    return Scaffold(
      appBar: AppBar(
        title:Text("Bidding",
        style: GoogleFonts.ubuntu(textStyle: TextStyle(color:Theme.of(context).colorScheme.outline, fontWeight: FontWeight.w700),)
        ),
        //centerTitle:true,
        backgroundColor:Theme.of(context).colorScheme.primary,
      ),
      body:SingleChildScrollView(
        child: Column(children: [Container(alignment:Alignment.center,
        margin:const EdgeInsets.all(5),
        child: Text(widget.sendingData["selectedTitle"]as String,
        style:GoogleFonts.openSans(textStyle: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),
        )
        )
        ),
        Container(decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.tertiary),
        borderRadius: BorderRadius.circular(10)),
        padding:const EdgeInsets.all(10),
        alignment: AlignmentDirectional.topStart,
        margin:const EdgeInsetsDirectional.only(start:15,end:15,top:10,bottom:10),
        child: Text(widget.sendingData["selectedDescription"]as String,
        style: const TextStyle(fontSize:16,
       // color:Colors.lightBlue
       ),)),
        
        Container(margin:const EdgeInsetsDirectional.only(start:25,end:25,top:10,bottom:10),
        decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.tertiary),
        borderRadius: BorderRadius.circular(10)),
        padding:const EdgeInsets.all(10),
        alignment: Alignment.center,
        child:Text(toBeDisplayed,
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize:20,
          ),)
          ),Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  children:[
                    Container(
                      alignment:Alignment.center,
                      margin: const EdgeInsetsDirectional.only(bottom: 5),
                      padding:const EdgeInsets.all(10),
                      width:100,
                      decoration:BoxDecoration(
 
                      borderRadius: BorderRadius.circular(20),
                      color:(widget.sendingData["E-Sports"]==1)? Colors.lightGreenAccent:Colors.transparent),child:const Text("E-Sports",style: TextStyle(fontSize: 16),),),
                      Container(
                      alignment:Alignment.center,
                      margin: const EdgeInsetsDirectional.only(bottom: 5),
                      padding:const EdgeInsets.all(10),
                      width:100,
                      decoration:BoxDecoration(

                      borderRadius: BorderRadius.circular(20),
                      color:(widget.sendingData["Sports"]==1)? Colors.yellow:Colors.transparent),child:const Text("Sports",style: TextStyle(fontSize: 16)),),
                      Container(
                      alignment:Alignment.center,
                      width:100,
                      margin: const EdgeInsetsDirectional.only(bottom: 5),
                      padding:const EdgeInsets.all(10),
                      decoration:BoxDecoration(

                      borderRadius: BorderRadius.circular(20),
                      color:(widget.sendingData["Music"]==1)? Colors.yellow:Colors.transparent),child:const Text("Music",style: TextStyle(fontSize: 16)),)
                  ]),
                  Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  children:[
                    Container(
                      alignment:Alignment.center,
                      margin: const EdgeInsetsDirectional.only(bottom: 5),
                      padding:const EdgeInsets.all(10),
                      width:100,
                      decoration:BoxDecoration(
 
                      borderRadius: BorderRadius.circular(20),
                      color:(widget.sendingData["Dance"]==1)? Colors.lightBlue:Colors.transparent),child:const Text("Dance",style: TextStyle(fontSize: 16)),
                      ),
                      Container(
                      alignment:Alignment.center,
                      margin: const EdgeInsetsDirectional.only(bottom: 5),
                      padding:const EdgeInsets.all(10),
                      width:100,
                      decoration:BoxDecoration(

                      borderRadius: BorderRadius.circular(20),
                      color:(widget.sendingData["Education"]==1)? Colors.red:Colors.transparent),child:const Text("Education",style: TextStyle(fontSize: 16)),),
                      Container(
                      alignment:Alignment.center,
                      width:100,
                      margin: const EdgeInsetsDirectional.only(bottom: 5),
                      padding:const EdgeInsets.all(10),
                      decoration:BoxDecoration(

                      borderRadius: BorderRadius.circular(20),
                      color:(widget.sendingData["Spiritual"]==1)? Colors.orange:Colors.transparent),child:const Text("Spiritual",style: TextStyle(fontSize: 16)),)
                  ]),
        AnimatedSwitcher(
          duration:const Duration(milliseconds:300),
          child:TextFieldShown?Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration:BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.tertiary),
                borderRadius: BorderRadius.circular(10)),
                margin:const EdgeInsetsDirectional.only(start:80,end:80,bottom:10),
                padding:const EdgeInsets.all(10),
                    child: TextField(
                    controller:bidField,
                    keyboardType:TextInputType.number,
                    inputFormatters:<TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    decoration:const InputDecoration(hintText:"Enter Bid"),
                    ),
                  ),
                  
                  TextButton(
            style:ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.tertiary)),
          onPressed:()async{
            DocumentSnapshot named =await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).get();
            String name=named["Username"];
            int amntBid=0;
            if (bidField.text.isNotEmpty&&name!=widget.sendingData["ListingMaker"]){
            amntBid=int.parse(bidField.text);}
            else if (name==widget.sendingData["ListingMaker"]){
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
                                    Text("You can't bid on your own listing"),
                                  ],
                                )),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,//removes border thingy due to snackbars edges cuz content
                              elevation:0,//removes weird shadow
                              duration:const Duration(seconds:3),
                              ),
                              
        
                            );
                            
        
            }
            
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
                    Navigator.pushNamedAndRemoveUntil(context,
                    "/homePage",
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
            else if(bid!=0 &&(amntBid<bid+minInc)&&name!=widget.sendingData["ListingMaker"]){
              FocusScope.of(context).unfocus();
              ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content:Container(
                                padding: const EdgeInsets.all(16),
                                height:100,
                                decoration: BoxDecoration(color:Theme.of(context).colorScheme.error,
                                borderRadius: BorderRadius.circular(20)),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [Text('Sorry!',style: TextStyle(fontSize:18),),
                                    Text("The Bid must be greater than the Current Bid by atleast the Minimum Increment Value"),
                                  ],
                                )),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,//removes border thingy due to snackbars edges cuz content
                              elevation:0,//removes weird shadow
                              duration:const Duration(seconds:3),
                              ),
                              
        
                            );
        
        
            }
            else if(bid==0&&(amntBid>=strtbid)&&name!=widget.sendingData["ListingMaker"]){
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
                    Navigator.pushNamedAndRemoveUntil(context,
                    "/homePage",
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
            else if (name!=widget.sendingData["ListingMaker"]){
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
          child:Text("Place Bid",
          style:TextStyle(
            color:Theme.of(context).colorScheme.outline,
            fontSize: 20,
          )
          )
          ),
          const SizedBox(height:70,)
        
            ],
          ):TextButton(
                style:ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.tertiary)),
              onPressed:(){
                setState(() {
                  TextFieldShown=true;
                });
              },
              child:Text("Bid",
              style:TextStyle(
                color:Theme.of(context).colorScheme.outline,
                fontSize: 20,
              )
              )
              ),
            
          
        ),
        
          
        ],),
      )
    );

  }
}