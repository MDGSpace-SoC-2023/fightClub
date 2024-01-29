import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:google_fonts/google_fonts.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:philanthrobid/homeScreen.dart';

class addAListing extends StatefulWidget{
  const addAListing({super.key});
  @override
  State<addAListing> createState()=> _addAListing();
}
class _addAListing extends State<addAListing>{
  final TextEditingController _titleOfListing=TextEditingController();
  final TextEditingController _descriptionOfListing=TextEditingController();
  final TextEditingController _startingBidOfListing=TextEditingController();
  final TextEditingController _minmIncrementOfListing=TextEditingController();
  String listingToBackUrl = "http://10.0.2.2:8000/philanthrobid/listings";

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(backgroundColor: Theme.of(context).colorScheme.primary,
      title:Text("Add Listing",style:GoogleFonts.ubuntu(textStyle: TextStyle(color:Theme.of(context).colorScheme.outline, fontWeight: FontWeight.w700)),),
      ),
      body:SingleChildScrollView(child: Column(children:[Container(margin:const EdgeInsets.all(10),
      child:TextField(decoration:InputDecoration(hintText:"Title",),
      controller:_titleOfListing,),
       padding:const EdgeInsets.all(10),
      decoration: BoxDecoration(border:Border.all(color: Theme.of(context).colorScheme.tertiary,),
                borderRadius:BorderRadius.circular(20))
      ),
      Container(margin:const EdgeInsetsDirectional.only(start:10,end:10),//margin
      child:TextField(controller:_descriptionOfListing,
      maxLines:10,decoration:InputDecoration(hintText:"Description (max char:1024)",),),
      padding:const EdgeInsets.all(10),
      decoration: BoxDecoration(border:Border.all(color: Theme.of(context).colorScheme.tertiary,),
                borderRadius:BorderRadius.circular(20))
      
      ),
      Container(margin:const EdgeInsetsDirectional.only(top:10,start:90,end:90),
      child:TextField(keyboardType:TextInputType.number,
      inputFormatters:<TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
      controller:_startingBidOfListing,
      decoration:InputDecoration(prefixIcon:const Icon(Icons.currency_rupee),hintText:"Base Price",)),
      padding:const EdgeInsets.all(10),
      decoration: BoxDecoration(border:Border.all(color: Theme.of(context).colorScheme.tertiary,),
                borderRadius:BorderRadius.circular(20))
      ),
      Container(margin:const EdgeInsetsDirectional.only(top:10,start:90,end:90,bottom:25),
      child:TextField(keyboardType:TextInputType.number,
      inputFormatters:<TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
      controller:_minmIncrementOfListing,
      decoration:InputDecoration(prefixIcon:const Icon(Icons.currency_rupee),hintText:"Min. Increment",)),
      padding:const EdgeInsets.all(10),
      decoration: BoxDecoration(border:Border.all(color: Theme.of(context).colorScheme.tertiary,),
                borderRadius:BorderRadius.circular(20))
      ),
      TextButton(style:ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.tertiary)),
      child:Text("Add",style:TextStyle(fontSize:20,color:Theme.of(context).colorScheme.outline),),
      //onHover: (flag){ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Theme.of(context).primaryColorLight));},
      onPressed:()async{
        String title =_titleOfListing.text.trim();
        String descrip = _descriptionOfListing.text.trim();
        int startingBid = int.parse(_startingBidOfListing.text);
        int minIncrement = int.parse(_minmIncrementOfListing.text);
        final FirebaseFirestore firestore = FirebaseFirestore.instance; 
        String? userId = FirebaseAuth.instance.currentUser?.uid;
        DocumentSnapshot named=await firestore.collection("users").doc(userId).get();
        String nameOfTheUser = named["Username"];

        void sendListingtoBack()async{
          var sendingData={
            "title":title,
            "description":descrip,
            "mininc":minIncrement,
            "user":nameOfTheUser,
            "strtbid":startingBid,

          };
          try{
            var response = await http.post(Uri.parse(listingToBackUrl),
            headers:{
              "Content-type":"application/json"
            },
            body: jsonEncode(sendingData));
            if (response.statusCode==201){
              print("Listing sent to Backend");
            }
            else {
              print("An error happened ${response.statusCode}");
              print("Response body ${response.body}");
            }
          }catch(e){
            print ("Error happened $e");
          }
          
        }
        sendListingtoBack();
        //Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(    //pop not used so that homescreen gets update and listing added can be observed
          context,
            "/homePage",
            (route)=>false
        );
      },),
      
      ]//think of the children
      )
      )
      
    
    );

  }
}