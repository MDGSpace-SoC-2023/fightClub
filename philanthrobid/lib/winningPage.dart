import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import 'package:flutter_stripe/flutter_stripe.dart';
import "dart:convert";
import "package:http/http.dart"as http;
import 'package:google_fonts/google_fonts.dart';
class winningPage extends StatefulWidget{
  Map<String,Object?> sendingData={};
  winningPage({super.key, required this.sendingData});
  @override
  State<winningPage> createState()=> _winningPage();

}
class _winningPage extends State<winningPage>{
  String makePaymentIntentURL="http://10.0.2.2:8000/philanthrobid/paymentIntent";
  String chosenCharity="";
  int chosenAccnt=0;
  bool chckBool=true;
  List<String> listOfCharity=["SampleChar1","SampleChar2"];//,"SampleChar3","SampleChar4","SampleChar5","SampleChar6","SampleChar7","SampleChar8","SampleChar9","SampleChar10"];
  Map<String,int> MapOfAccnt={"SampleChar1":1,"SampleChar2":2};//,"SampleChar3":"253456789","SampleChar4":"216556789","SampleChar5":"213499789","SampleChar6":"29876456789","SampleChar7":"21387646789","SampleChar8":"212354589","SampleChar9":"298456789","SampleChar10":"2133545789"};
  Map<String,Object?> someMap={};

  Future<void> checkListing()async{
    String id=widget.sendingData["wonId"].toString();
    var response=await http.get(Uri.parse("http://10.0.2.2:8000/philanthrobid/selectiveListing/$id"));
    if (response.statusCode==200){
      final jsonObject=json.decode(response.body);
      setState(() {
        chckBool=jsonObject["is_active"];
      });
      
    }

  }
  Future<void> initPaymentSheet()async{
    try{
      Future<Map<String,Object?>> makePaymentIntent()async{
        print(widget.sendingData["wonId"]);
        var sendingData={
          "list_id":widget.sendingData["wonId"],
          "email":FirebaseAuth.instance.currentUser!.email,
          "chosenAccnt":chosenAccnt
        };
        var response=await http.post(Uri.parse(makePaymentIntentURL),
      headers:{
        "Content-Type":"application/json"
      },
      body:jsonEncode(sendingData));
      if(response.statusCode==201){
        print("made payment intent succesfully");
        json.encode(response.body);
        return(json.decode(response.body));
      }
      else{print("Couldnt make payment intent");
      print(response.body);
      print(response.request);}
      return(someMap);
      }
      final data=await makePaymentIntent();
      await Stripe.instance.initPaymentSheet(paymentSheetParameters:SetupPaymentSheetParameters(
        customFlow:false,
        merchantDisplayName:chosenCharity,
        paymentIntentClientSecret: data["client_secret"] as String?,
        googlePay: const PaymentSheetGooglePay(merchantCountryCode: "IN",
        testEnv: true,),
        style:ThemeMode.light
      ),
       );

        
      
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("Sorry an Error occoured")));
      rethrow;
    }
  }

  @override
  
  Widget build (BuildContext context){
  return Scaffold(
    appBar:AppBar(
      toolbarHeight: 170,
      automaticallyImplyLeading: false,
      title: Text("CONGRATULATIONS!",
      style: GoogleFonts.ubuntu(textStyle: TextStyle(color: Theme.of(context).colorScheme.outline, fontWeight: FontWeight.bold, fontSize: 30),)),
      centerTitle:true,
      backgroundColor:Theme.of(context).colorScheme.primary,

    ),
    body:Column(
      crossAxisAlignment:CrossAxisAlignment.center,
      //mainAxisAlignment: MainAxisAlignment.center,
      
      children:[
      SizedBox(height: 45,),
      const Center(child: Text("YOU HAVE WON!!",
      textAlign:TextAlign.center,
      style:TextStyle(fontSize: 35,
      fontWeight:FontWeight.bold,
      color:Colors.lightGreen))),

      SizedBox(height: 30),
      Container(margin:const EdgeInsetsDirectional.only(start:10,end:10),
        child: Center(child:Text(widget.sendingData["wonTitle"] as String,
        style: const TextStyle(
          fontSize:35,
          fontWeight:FontWeight.w500,
          color: Colors.cyan
        
        ),
        ),
        ),
      ),
      SizedBox(height: 10),
      const Center(child: Text("At Just",
      textAlign:TextAlign.center,
      style:TextStyle(fontSize: 28,
      fontWeight:FontWeight.w500,
      color:Colors.green
      ))),

      Container(margin:const EdgeInsetsDirectional.only(start:10,end:10,bottom: 10),
        child: Center(child:Text("\u{20B9}${widget.sendingData["wonBid"].toString()}",
        style: const TextStyle(
          fontSize:35,
          fontWeight:FontWeight.w500,
          color: Colors.cyan
        ),
        ),
        ),
      ),

      /*TextButton(
      style:ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(255, 246, 179, 202),)),
      onPressed: (){

      },
      child:const  Text("CHOOSE A CHARITY",
      style: TextStyle(
        color:Colors.white,
        fontSize: 25

      ),)),*/
      const SizedBox(height: 20),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.tertiary), 
          borderRadius:const BorderRadius.all(Radius.circular(10)),
          ),
        child: DropdownMenu<String>(menuHeight:200,
        width:250,
        dropdownMenuEntries:listOfCharity.map<DropdownMenuEntry<String>>((String value){
          return DropdownMenuEntry<String>(value: value, label: value);
        }).toList(),
        hintText:"Choose a Charity",
        onSelected: (value)async {
          //int AccNo=int.parse(MapOfAccnt[value]??"0");
          setState(() {
            chosenCharity=value??"";
            chosenAccnt=MapOfAccnt[value]??0;
          });
          await initPaymentSheet();
          
          
          await Stripe.instance.presentPaymentSheet();
          await checkListing();
          if (chckBool==false){
            Navigator.pushNamedAndRemoveUntil(context, "/homePage", (route) => false);
          }
          
          
        },),
      )

      ]
  )
  );}
}