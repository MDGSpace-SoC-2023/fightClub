import 'package:flutter/material.dart';
import "package:philanthrobid/addAListing.dart";
import "package:philanthrobid/biddingPage.dart";
import "package:philanthrobid/settings.dart";
import "package:philanthrobid/leaderboard.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import 'package:philanthrobid/listings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:philanthrobid/winningPage.dart";
import 'package:google_fonts/google_fonts.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreen();
}
class _homeScreen extends State<homeScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget page;
    String text;

    switch (_currentIndex) {
      case 0:
        page = homePage();
        text = "Philanthrobid";
        break;

      case 1:
        page = Leaderboard();
        text = "Leaderboard";
        break;

      case 2:
        page = settings();
        text = "Settings";
        break;

      default:
        throw UnimplementedError("No widget for selected Index");
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //removes default backbutton since the homepage is not home according to flutter
        title: Text(text,style:GoogleFonts.ubuntu(textStyle: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 25, fontWeight: FontWeight.bold)),),
        backgroundColor:Theme.of(context).colorScheme.primary,
        elevation: 10,),
      body: Column(children: [
        Expanded(
            child: Container(
          color: Theme.of(context).colorScheme.background,
          child: page,
        )),
      ]),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          fixedColor: Theme.of(context).colorScheme.primary,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: "Leaderboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          }),
          floatingActionButton: (_currentIndex==0)?
          SizedBox(
            height: 70,
            width: 70,
            child: FittedBox(
              child: FloatingActionButton(
                shape: new CircleBorder(),
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                child: Icon(Icons.add,color:Colors.white,),
                onPressed: (){Navigator.pushNamed(context,"/addListingPage");
                 }),
            ),
          )
             :null,
    );
  }
}

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePage();
}

class _homePage extends State<homePage> {
  String getListingsURL="http://10.0.2.2:8000/philanthrobid/listings";
  final TextEditingController _searchController=TextEditingController();
  int _currentIndex=0;
  late List<Listing>? listingList=[];
  List<Listing>? unpaidListingList=[];
 int? selectedListing;
 String searched="";
 String name="";
 String sendUnPaidApiURL = "http://10.0.2.2:8000/philanthrobid/UnpaidUsers";
 String unPaidListingsURL="http://10.0.2.2:8000/philanthrobid/UnpaidUserListBackend";
 

  @override
  void initState(){
    super.initState();
    
    getListingList();
    //getUnPaidList();
    //searchUnpaidList(); UNCOMMENT THIS LINE
    
    
  }


   
  Future<void> getUnPaidList()async{
    var response=await http.get(Uri.parse(unPaidListingsURL));
    if (response.statusCode==200){
    final List<dynamic> jsonList = json.decode(response.body);
    
    setState(() {
      unpaidListingList=jsonList.map((item)=>  //.map is used to transorm each element of a collection to a new value base on a specific funcn
      Listing.fromJson(item)).toList();
    });

      
       
      }
      else{
        throw Exception("failed to load unpaidlisting");
      }
        
  }
  Future<void> searchUnpaidList()async{
    await getUnPaidList();
    await getName();
    
    
    print("called");
    print(unpaidListingList!.length);
    print (name);
    for(int i=0;i<unpaidListingList!.length;i++){
      if(unpaidListingList![i].bidding_user==name){
        print("yoooooo");
        String titleSent =unpaidListingList![i].title;
        print (titleSent);
        
        Navigator.pushAndRemoveUntil(context ,MaterialPageRoute(builder:(BuildContext context){
                  return winningPage(sendingData:{
                  "wonTitle":titleSent,
                  
                  "wonBid":unpaidListingList![i].bid,
                  "wonId":unpaidListingList![i].list_id
                  
                  
                  });
            
                }), (route) => false);
                break;
      }
    }
  }
  Future<void> getName()async{
    DocumentSnapshot named =await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).get();

      name=named["Username"];

  }
  Future<void> getListingList()async{
    await getName();
    var response = await http.get(Uri.parse(getListingsURL));
    //print(response.body);
    //print(response.statusCode);
    if (response.statusCode==200){
      print (response.body);
      final List<dynamic> jsonList = json.decode(response.body);//takes json list of json objects and decodes to normal list of json object
       setState(() {
         listingList= jsonList.map((item)=>  //.map is used to transorm each element of a collection to a new value base on a specific funcn
         Listing.fromJson(item)).toList();
       });
       //DocumentSnapshot named =await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).get();
       //name=named["Username"];//converts each item of the list from json to a member of the listing class and creates a list of them.  
      
    }else{
      throw Exception("Failed to load");
    }
    //final listingElements = json.decode(response.body).cast<Map<String,dynamic>>();
    //List<Listing> listingList = listingElements.map<Listing>((json){
    //  return Listing.fromJson(json);
    //}).toList();
   // return listingList;
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      body:Stack(children:[
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          children: [
             SizedBox(height: 8,),
            Container(
              height: 55,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onTertiary,
              borderRadius: BorderRadius.all(Radius.circular(30))
            ),
          child:TextField(
            onChanged: (value) {},
          decoration:const InputDecoration(
            hintText:"Search",
            border:OutlineInputBorder( 
              borderRadius: BorderRadius.all(Radius.circular(30))
            ),
            prefixIcon: Icon(Icons.search)
          ),)
        ),
        SizedBox(height: 4,),
            Expanded(
              
              child: listingList != null?ListView.builder(itemCount:(listingList?.length)??0-unpaidListingList!.length, 
              itemBuilder:(context,index){
                
                String toBeDisplayed;
                if(listingList![index].bid!=0){
                  toBeDisplayed="Current Bid: \u{20B9}${listingList![index].bid}";
                }
                else{
                  toBeDisplayed="Base Price: \u{20B9}${listingList![index].strtbid}";
                }
                DateTime createDate=DateTime.parse(listingList![index].created_at);
                DateTime  endTime=createDate.add(const Duration(days:5));//can change to however much time want auction to last MUST CHANGE IN BACKEND SIMULTANEOUSLY
                
                Duration timeLeft=endTime.difference(DateTime.now());
                Duration displayedTimeLeft;
                String actualDisplay;
                
                if (timeLeft>Duration.zero){
                  displayedTimeLeft=timeLeft;
                }
                else{
                  displayedTimeLeft=Duration.zero;
                }
                if(displayedTimeLeft.inHours==0){
                  actualDisplay="${displayedTimeLeft.inMinutes.toString()} min(s) ${displayedTimeLeft.inSeconds-displayedTimeLeft.inMinutes*60} sec(s) left";
                }
                else{
                  actualDisplay="${displayedTimeLeft.inDays.toString()} day(s) ${displayedTimeLeft.inHours-displayedTimeLeft.inDays*24} hour(s) left";
                }
                if(displayedTimeLeft!=Duration.zero){
                return Card(
                  color: Theme.of(context).colorScheme.surface,
                  child:ListTile(title:
                    Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      
                      children: [
                        Container(
                          width:200,
                          child: Text(listingList![index].title,
                          maxLines:2,
                          //textAlign:TextAlign.center,
                          style:GoogleFonts.openSans(textStyle: TextStyle(fontSize:20,color: Theme.of(context).colorScheme.onPrimary, fontWeight:FontWeight.bold,)),
                          //decoration: TextDecoration.underline
                          ),
                        ),
                        Text(actualDisplay,
                        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.tertiary),)
                      ],
        
                    ),
                    
                    
                    
                 
                subtitle:
                  Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    
                    children: [
                      Text(listingList![index].description,
                      //textAlign:TextAlign.center,
                      maxLines:2,
                      style:TextStyle(color: Theme.of(context).colorScheme.onPrimary,),),
                      Container(
                        //padding: const EdgeInsets.all(5),
                        //decoration:BoxDecoration(
                         // border: Border.all(),
                         // borderRadius:BorderRadius.circular(10),
                        //),
                        child: Text (toBeDisplayed,
                        //textAlign: TextAlign.left,
                        style:TextStyle(color:Theme.of(context).colorScheme.onSecondary,fontSize:18),),
                      )
                    ],
                  ),
                
                onTap:() {
                  setState(() {
                    selectedListing=listingList![index].list_id;
                  });
                  Navigator.push(context,
                  MaterialPageRoute(builder:(BuildContext context){
                    return biddingPage(sendingData:{"selectedID":selectedListing,
                    "selectedTitle":listingList![index].title,
                    "selectedDescription":listingList![index].description,
                    "selectedBid":listingList![index].bid,
                    "selectedStarterBid":listingList![index].strtbid,
                    "selectedMinInc":listingList![index].mininc,
                    
                    });
              
                  }));
              
                },
               
        
                
                ),
                
                
                );
                }else{
                  return Container();
                }
        
              }
              ,):const Center(child:CircularProgressIndicator()),
            ),
          ],
        ),
      ),
      //Builder<List<Listing>>(
        //future:listingList,
        //builder: (BuildContext context,AsyncSnapshot snapshot) {
          //if (!snapshot.hasData) return CircularProgressIndicator();
          //return ListView.builder(itemCount:snapshot.data.length,
          //itemBuilder:(BuildContext context,int  index){
            //var data =snapshot.data[index];
            //return Card(
              //child:ListTile(
                //title:Text(data.title,
                //)
              //)
            //);
          //} );
          
        //},
      //),

      /*Positioned(top:580,left:328,child:CircleAvatar(radius:28,backgroundColor:Theme.of(context).colorScheme.tertiary,
      child:Center(child:IconButton(iconSize:40,
      icon:const Icon(Icons.add,color:Colors.white,),
      onPressed:(){
        Navigator.pushNamed(context,
        "/addListingPage"
        );

      },//onPressed
      )
      )
      )
      ),*/
      
      
      ]
      )
      ,
    );
    
  }
  
}