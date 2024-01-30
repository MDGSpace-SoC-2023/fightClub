import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:google_fonts/google_fonts.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:philanthrobid/homeScreen.dart';

class addAListing extends StatefulWidget {
  const addAListing({super.key});
  @override
  State<addAListing> createState() => _addAListing();
}

class _addAListing extends State<addAListing> {
  final TextEditingController _titleOfListing = TextEditingController();
  final TextEditingController _descriptionOfListing = TextEditingController();
  final TextEditingController _startingBidOfListing = TextEditingController();
  final TextEditingController _minmIncrementOfListing = TextEditingController();
  String listingToBackUrl = "http://10.0.2.2:8000/philanthrobid/listings/";
  bool Tag1=false;bool Tag2=false;bool Tag3=false;bool Tag4=false;bool Tag5=false;bool Tag6=false;
  List<int> tags=[0,0,0,0,0,0];
  int no_of_days=5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Add Listing",
            style:GoogleFonts.ubuntu(textStyle:TextStyle(color:Theme.of(context).colorScheme.outline,fontWeight:FontWeight.w700),
          ),
          
        ),),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              margin: const EdgeInsets.all(10),
              padding:const EdgeInsets.all(10),
              decoration: BoxDecoration(border:Border.all(color: Theme.of(context).colorScheme.tertiary,),
                borderRadius:BorderRadius.circular(20)),
              child: TextField(
                
                decoration:const InputDecoration(
                  hintText: "Title",
                  /*enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),*/
                ),
                controller: _titleOfListing,

              ),), //title Text Field
          Container(
              margin:
                  const EdgeInsetsDirectional.only(start: 10, end: 10),
                          padding:const EdgeInsets.all(10),
                          decoration: BoxDecoration(border:Border.all(color: Theme.of(context).colorScheme.tertiary,),
                          borderRadius:BorderRadius.circular(20)), //margin
              child: TextField(
                  controller: _descriptionOfListing,
                  maxLines: 10,
                  decoration:const InputDecoration(
                      hintText: "Description (max char:1024)",
                      //enabledBorder: OutlineInputBorder(
                          //borderRadius: BorderRadius.circular(20))
                          ))),
          Container(
              margin:
                  const EdgeInsetsDirectional.only(top: 10, start: 90, end: 90),
              padding:const EdgeInsets.all(10),
              decoration: BoxDecoration(border:Border.all(color: Theme.of(context).colorScheme.tertiary,),
                borderRadius:BorderRadius.circular(20)),
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                controller: _startingBidOfListing,
                decoration:const InputDecoration(
                    prefixIcon:Icon(Icons.currency_rupee),
                    hintText: "Base Price",
                    //enabledBorder: OutlineInputBorder(
                        //borderRadius: BorderRadius.circular(20)
                        //)
                        ),
              )),
          Container(
              margin: const EdgeInsetsDirectional.only(
                  top: 10, start: 90, end: 90, bottom: 25),
              padding:const EdgeInsets.all(10),
              decoration: BoxDecoration(border:Border.all(color: Theme.of(context).colorScheme.tertiary,),
                borderRadius:BorderRadius.circular(20)),
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                controller: _minmIncrementOfListing,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.currency_rupee),
                    hintText: "Min. Increment",
                    //enabledBorder: OutlineInputBorder(
                      //  borderRadius: BorderRadius.circular(20))
                      ),
              )),
              Row(
              children: [
              Container(
                margin:const EdgeInsets.all(10),
                child: Text("Auction Duration",
                style:TextStyle(fontSize:15)),
              ),
              FloatingActionButton(
                heroTag:"addBttn",
                mini: true,
                shape:CircleBorder(),
                onPressed: (){
                  setState(() {
                    no_of_days++;
                  });
                },
              child:Icon(Icons.add)),
              Text("$no_of_days Days",style:TextStyle(fontSize:20),),
              FloatingActionButton(
                heroTag: "minusBttn",
                mini: true,
                onPressed: (){
                  if (no_of_days>1){
                    setState(() {
                      no_of_days--;
                    });
                  }
                },
              shape:CircleBorder(),
              child:Icon(Icons.remove))
              
              
              ]
              ,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            //1st Button
            ElevatedButton.icon(
                icon:(Tag1)? const Icon(Icons.check,color: Colors.white,):const Icon(Icons.add,color:Colors.white),
                onPressed: () {
                  setState(() {
                    Tag1=(!Tag1);
                  });
                  (Tag1)?tags[0]=1:tags[0]=0;
                },
                label: const Text("E-Sports",style: TextStyle(color:Colors.white),),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>((!Tag1)?
                  Color.fromARGB(255, 241, 49, 19):Color.fromARGB(161, 103, 91, 91),
                ))),
                //2nd Button
            ElevatedButton.icon(
                icon:(Tag2)? const Icon(Icons.check,color: Colors.white,):const Icon(Icons.add,color:Colors.white),
                onPressed: () {
                  setState(() {
                    Tag2=(!Tag2);
                  });
                  (Tag2)?tags[1]=1:tags[1]=0;
                },
                label: const Text("Dance",style: TextStyle(color:Colors.white),),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>((!Tag2)?
                  Color.fromARGB(255, 78, 241, 19):Color.fromARGB(161, 103, 91, 91),
                ))),
                //3rd button
                ElevatedButton.icon(
                icon:(Tag3)? const Icon(Icons.check,color: Colors.white,):const Icon(Icons.add,color:Colors.white),
                onPressed: () {
                  setState(() {
                    Tag3=(!Tag3);

                  });
                  (Tag3)?tags[2]=1:tags[2]=0;
                },
                label: const Text("Sports",style: TextStyle(color:Colors.white),),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>((!Tag3)?
                  Color.fromARGB(255, 19, 174, 241):Color.fromARGB(161, 103, 91, 91),
                )))

          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [ElevatedButton.icon(
                icon:(Tag4)? const Icon(Icons.check,color: Colors.white,):const Icon(Icons.add,color:Colors.white),
                onPressed: () {
                  setState(() {
                    Tag4=(!Tag4);
                  });
                  (Tag4)?tags[3]=1:tags[3]=0;
                },
                label: const Text("Spiritual",style: TextStyle(color:Colors.white),),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>((!Tag4)?
                  Color.fromARGB(255, 28, 217, 201):Color.fromARGB(161, 103, 91, 91),
                ))),
                ElevatedButton.icon(
                icon:(Tag5)? const Icon(Icons.check,color: Colors.white,):const Icon(Icons.add,color:Colors.white),
                onPressed: () {
                  setState(() {
                    Tag5=(!Tag5);
                  });
                  (Tag5)?tags[4]=1:tags[4]=0;
                },
                label: const Text("Music",style: TextStyle(color:Colors.white),),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>((!Tag5)?
                  Color.fromARGB(255, 231, 80, 228):Color.fromARGB(161, 103, 91, 91),
                ))),
                ElevatedButton.icon(
                icon:(Tag6)? const Icon(Icons.check,color: Colors.white,):const Icon(Icons.add,color:Colors.white),
                onPressed: () {
                  setState(() {
                    Tag6=(!Tag6);
                  });
                  (Tag6)?tags[5]=1:tags[5]=0;
                },
                label: const Text("Education",style: TextStyle(color:Colors.white),),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>((!Tag6)?
                  Color.fromARGB(255, 201, 217, 28):Color.fromARGB(161, 103, 91, 91),
                ))),
                
                ],),

          TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.tertiary,
            )),
            child: Text(
              "Add Listing",
              style: TextStyle(fontSize: 20, color:Theme.of(context).colorScheme.outline),
            ),
            onPressed: () async {
              if (_titleOfListing.text.isNotEmpty &&
                  _descriptionOfListing.text.isNotEmpty &&
                  _startingBidOfListing.text.isNotEmpty &&
                  _minmIncrementOfListing.text.isNotEmpty) {
                    DateTime time_end=DateTime.now().add(Duration(days: no_of_days));
                String title = _titleOfListing.text.trim();
                String descrip = _descriptionOfListing.text.trim();
                int startingBid = int.parse(_startingBidOfListing.text);
                int minIncrement = int.parse(_minmIncrementOfListing.text);
                final FirebaseFirestore _firestore = FirebaseFirestore.instance;
                String? userId = FirebaseAuth.instance.currentUser?.uid;
                DocumentSnapshot named =
                    await _firestore.collection("users").doc(userId).get();
                String nameOfTheUser = named["Username"];
                print(time_end.toIso8601String());

                void sendListingtoBack() async {
                  var sendingData = {
                    "title": title,
                    "description": descrip,
                    "mininc": minIncrement,
                    "user": nameOfTheUser,
                    "strtbid": startingBid,
                    "tags":tags,
                    "days_to_end":no_of_days,
                    "endDate":time_end.toIso8601String()
                  };
                  try {
                    var response = await http.post(Uri.parse(listingToBackUrl),
                        headers: {"Content-type": "application/json"},
                        body: jsonEncode(sendingData));
                    if (response.statusCode == 201) {
                      print("Listing sent to Backend");
                    } else {
                      print("An error happened ${response.statusCode}");
                      print("Response body ${response.body}");
                    }
                  } catch (e) {
                    print("Error happened $e");
                  }
                }

                sendListingtoBack();
                //Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                    //pop not used so that homescreen gets update and listing added can be observed
                    context,
                    "/homePage",
                    (route) => false);
              }
            },
          ),
        ] //think of the children
                )
                ));
  }
}
