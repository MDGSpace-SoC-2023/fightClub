import 'package:flutter/material.dart';
import "package:philanthrobid/addAListing.dart";
import "package:philanthrobid/biddingPage.dart";
import "package:philanthrobid/chatPage.dart";
import "package:philanthrobid/settings.dart";
import "package:philanthrobid/leaderboard.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import 'package:philanthrobid/listings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:philanthrobid/winningPage.dart";
import "package:google_fonts/google_fonts.dart";
class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreen();
}
class _homeScreen extends State<homeScreen>{
  int _currentIndex=0;
  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);

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
        page = chatPage();
        text = "Chat";
        break;
      case 3:
       page=settings();
       text="Settings";


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
              icon: Icon(Icons.home,color:Colors.grey,),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard,color:Colors.grey),
              label: "Leaderboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message,color:Colors.grey),
              label: "Chat",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.settings,color:Colors.grey),
            label:"Settings")
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
class homePage extends StatefulWidget{
  const homePage({super.key});
  @override
  State<homePage> createState()=> _homePage();
}


class _homePage extends State<homePage> {
  int currentPage=1;
  int currentSearchedPage=1;
  //String getListingsURL="http://10.0.2.2:8000/philanthrobid/listings/?page=$currentPage";
  final TextEditingController _searchController=TextEditingController();
  //int _currentIndex=0;
  int no_of_listing=0;
  late List<Listing>? listingList=[];
  List<Listing> searchedListing=[];
  List<Listing>? unpaidListingList=[];
 int? selectedListing;
 String searched="";
 String name="";
 String userURL="http://10.0.2.2:8000/philanthrobid/users";
 String sendUnPaidApiURL = "http://10.0.2.2:8000/philanthrobid/UnpaidUsers";
 String unPaidListingsURL="http://10.0.2.2:8000/philanthrobid/UnpaidUserListBackend";
 final homeScrollController=ScrollController();
 bool showProgressIndicator=false;
 bool searching=false;
 String searchstring="";
 int no_of_searches=0;
 int searchListLength=0;
 

  @override
  void initState(){
    super.initState();
    getHomeScreen();
    homeScrollController.addListener(listingLoader);
    //getHomeScreen();
   // getListingList(); maybe uncomment
    //getUnPaidList();
   // searchUnpaidList(); maybe uncomment
    
    
  }
  @override
  void dispose(){
    super.dispose();
    homeScrollController.dispose();
  }
  void listingLoader()async{
    bool needToReload=listingList!.length<no_of_listing;  //basically ensures that if all objects in database have already been shown then it doesnt try to get next page nor it reloads
    bool needToSearch=(listingList!.length<no_of_searches&&_searchController.text!="");
    if (homeScrollController.position.pixels==homeScrollController.position.maxScrollExtent&& showProgressIndicator==false){
      print(needToSearch);
      print(listingList!.length);
      print (no_of_searches);
      //second condition to ensure that doesnt try to increase currentPage while a pge is being loaded
      setState(() {
        currentPage=currentPage + ((needToReload&&_searchController.text=="")?1:0);
        currentSearchedPage=currentSearchedPage+((needToSearch)?1:0);
        
        print(currentSearchedPage);
        

      });

      if (needToReload&&_searchController.text==""){//basically to prevent listing reload if searching something
      print(_searchController.text);
      print("ONLY LOADING LISTING");
        setState(() {
          showProgressIndicator=true;
       });
       //if (searching==false){
      await getListingList();
      //}
      
      setState(() {
        showProgressIndicator=false;
      });
      
      }
      else if(_searchController.text!=""&&needToSearch){
        setState(() {
          showProgressIndicator=true;
       });
       //if (searching==false){
      await getsearchListing();
      //}
      
      setState(() {
        showProgressIndicator=false;
      });


      }
      
      /*if (needToSearch){
        setState(() {
          showProgressIndicator=true;
       });
       if (searching==true){
      await getsearchListing();}
      
      setState(() {
        showProgressIndicator=false;
      });
      
      }*/
      
      
      
    }
  }
  void getHomeScreen()async{
    //await getsearchListing();//just to get count
    await getListingList();
    searchUnpaidList();
  }

  
   
  /*Future<void> getUnPaidList()async{
    var response=await http.get(Uri.parse(unPaidListingsURL));
    if (response.statusCode==200){
    final List<dynamic> jsonList = json.decode(response.body);
    
    setState(() {kkkkkkkkkk
      unpaidListingList=jsonList.map((item)=>  //.map is used to transorm each element of a collection to a new value base on a specific funcn
      Listing.fromJson(item)).toList();
    });

      
       
      }
      else{
        throw Exception("failed to load unpaidlisting");
      }
        
  }*/
  Future<void> searchUnpaidList()async{
    //await getUnPaidList();
    await getName();
    
    
    print("called");
   // print(unpaidListingList!.length);
    print (name);
    var response= await http.get(Uri.parse("http://10.0.2.2:8000/philanthrobid/SpecificUnpaidUser/?username=$name"));
    if (response.statusCode==200){
      final jsonObject=json.decode(response.body);
      Navigator.pushAndRemoveUntil(context ,MaterialPageRoute(builder:(BuildContext context){
                  return winningPage(sendingData:{
                  "wonTitle":jsonObject["title"],
                  
                  "wonBid":jsonObject["bid"],
                  "wonId":jsonObject["list_id"]
          
                  });
            
                }), (route) => false);
    }
    
               
  }
  Future<void> getName()async{
    DocumentSnapshot named =await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).get();

      name=named["Username"];

  }
  Future<void> getListingList()async{
    print("GETTING MORE LISTING");
    await getName();
    var response = await http.get(Uri.parse("http://10.0.2.2:8000/philanthrobid/customList/?page=${currentPage.toString()}&username=$name"));
    //print(response.statusCode);
    //print(response.body);
    if (response.statusCode==200){
      print(response.body);
      final Map<String,dynamic> jsonList = json.decode(response.body);
      final List<dynamic> jsonList2=jsonList["results"];//takes json list of json objects and decodes to normal list of json object
      
       setState(() {
        //listinfList=
         no_of_listing=jsonList["count"];
         listingList?.addAll( jsonList2.map((item)=>  //.map is used to transorm each element of a collection to a new value base on a specific funcn
         Listing.fromJson(item)).toList());
       });
       //DocumentSnapshot named =await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).get();
       //name=named["Username"];//converts each item of the list from json to a member of the listing class and creates a list of them.  
      
    }else{
      print(response.statusCode);
      print(response.body);
      throw Exception("Failed to load");
    }
    //final listingElements = json.decode(response.body).cast<Map<String,dynamic>>();
    //List<Listing> listingList = listingElements.map<Listing>((json){
    //  return Listing.fromJson(json);
    //}).toList();
   // return listingList;
  }
  Future<void> getsearchListing()async{
    print("Searching more listing");
          var response=await http.get(Uri.parse("http://10.0.2.2:8000/philanthrobid/search/?username=$name&query=$searchstring&page=${currentSearchedPage.toString()}"));
          if (response.statusCode==200){
            print(response.body);
            final Map<String,dynamic> jsonList=json.decode(response.body);
            List<dynamic> jsonList2=jsonList["results"];
            setState((){
              if(currentSearchedPage>1){
                searchedListing.addAll(jsonList2.map((item) => Listing.fromJson(item)).toList());}
                else{
                  searchedListing=jsonList2.map((item) => Listing.fromJson(item)).toList();
                }
                //listingList=searchedListing;
              
              no_of_searches=jsonList["count"];
              listingList=searchedListing;
                //print(listingList![0]);
            }
            );
          }else{setState(() {
            listingList=[];
          }
          );
          }
          }

  @override
  Widget build(BuildContext context) {
    
    
    return Scaffold(
      
      body:Stack(children:[
      
      
      Container(
        decoration: BoxDecoration(
          color:Theme.of(context).colorScheme.background,
        ),
        child: Column(
          children: [
            const SizedBox(height:8,),
            Container(
              height:55,
              decoration:BoxDecoration(
                color:Theme.of(context).colorScheme.onTertiary,
                borderRadius:const BorderRadius.all(Radius.circular(30))
              ),
           
          child:TextField(onChanged: (value)async {
            setState(() {
              searching=true;
              currentSearchedPage=1;//so doesnt show only current page of results as we want to see all results
              searchstring=value;
            });
            
        
           await getsearchListing();
          },
          decoration:const InputDecoration(
            hintText:"Search",
            border:OutlineInputBorder( 
              borderRadius:BorderRadius.all(Radius.circular(30))
            ),
            prefixIcon: Icon(Icons.search)
          ),
          controller:_searchController,)
        ),
            const SizedBox(height: 4,),
                Expanded(
                  child: listingList != null? ListView.builder(itemCount: (listingList?.length), 
                    controller:homeScrollController,
                    itemBuilder:(context,index){
                      
                      String toBeDisplayed;
                      if(listingList![index].bid!=0){
                        toBeDisplayed="Current Bid: \u{20B9}${listingList![index].bid}";
                      }
                      else{
                        toBeDisplayed="Starting Bid: \u{20B9}${listingList![index].strtbid}";
                      }
                      //imp.........................................................................................................................
                      DateTime createDate=DateTime.parse(listingList![index].created_at);
                      DateTime  endTime=createDate.add(const Duration(days:5));//can change to however much time want auction to last MUST CHANGE IN BACKEND SIMULTANEOUSLY
                      
                      Duration timeLeft=DateTime.parse(listingList![index].endDate).difference(DateTime.now());
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
                        elevation: 5,
                        color:Theme.of(context).colorScheme.surface,
                        child:ListTile(title:
                          Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                            
                            children: [
                              Container(
                                width:200,
                                child: Text(listingList![index].title,
                                maxLines:2,
                                //textAlign:TextAlign.center,
                                //style:const TextStyle(fontSize:20,color:Color.fromARGB(186, 0, 0, 0),
                                //fontWeight:FontWeight.w400,
                                //decoration: TextDecoration.underline
                               // ),
                               style:GoogleFonts.openSans
                               (textStyle:TextStyle(fontSize:20,
                               color: Theme.of(context).colorScheme.onPrimary,
                               fontWeight:FontWeight.bold,
                               )
                               ),

                                
                                
                                ),
                              ),
                              Text(actualDisplay,
                              style:TextStyle(fontSize: 12,color:Theme.of(context).colorScheme.tertiary),)
                            ],
                    
                          ),
                          
                          
                          
                       
                      subtitle:
                        Column(
                          crossAxisAlignment:CrossAxisAlignment.start,
                          
                          children: [
                            Text(listingList![index].description,
                            //textAlign:TextAlign.center,
                            maxLines:2,
                            style:TextStyle(color:Theme.of(context).colorScheme.onPrimary,),),
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
                      
                      onTap:()async{
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
                          "ListingMaker":listingList![index].user,
                          "E-Sports":listingList![index].E_Sports,
                          "Education":listingList![index].Education,
                          "Sports":listingList![index].Sports,
                          "Music":listingList![index].Music,
                          "Dance":listingList![index].Dance,
                          "Spiritual":listingList![index].Spiritual,
                          
                          });
                    
                        }));
                        void userInteraction()async{
                          var sendingData={
                            "old_username":name,
                            "interaction":1,
                            "tags":[listingList![index].E_Sports,
                            listingList![index].Dance,
                            listingList![index].Sports,
                            listingList![index].Spiritual,
                            listingList![index].Music,
                            listingList![index].Education]
                          };
                          try{
                            var response= await http.patch(Uri.parse(userURL),
                            headers: {"Content-type":"application/json"},
                            body:jsonEncode(sendingData));
                            if (response.statusCode==200){
                              print("Interaction Succesful");
        
                            }
                            else{
                              print ("Interaction unseccusful");
                            }
        
                          }catch(e){
                            print("Error in interacting by error block \n e");
                          }
                          
                        }
                        userInteraction();
                      },
                     
                    
                      
                      ),
                      
                      
                      );
                      }else{
                        return Container();
                      }
                    
                    }
                    ,)
                  :const Center(child:CircularProgressIndicator()),
                ),
                (showProgressIndicator?Container(height:60,
                padding:const EdgeInsets.only(top:10,bottom: 10)
                ,child:const  Center(child: CircularProgressIndicator()),):Container())
              
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

      /*Positioned(top:580,left:328,child:CircleAvatar(radius:28,backgroundColor:const Color.fromARGB(255, 246, 179, 202), child:Center(child:IconButton(iconSize:40,
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
      /*bottomNavigationBar:BottomNavigationBar(
        type: BottomNavigationBarType.fixed,//if 3 or less then automatically this but 4 becomes shifting if ot specified
        currentIndex: _currentIndex,
        fixedColor:const Color.fromARGB(255, 246, 179, 202),
        items:const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label:"Home",),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard),label:"Leaderboard",),
          BottomNavigationBarItem(icon: Icon(Icons.settings),label:"Settings",),
          BottomNavigationBarItem(icon: Icon(Icons.message),label:"Chat",),
        ],
        onTap: (int index){
          setState(() {
            _currentIndex=index;
          });
          switch(index){
            case 0:{Navigator.pushNamed(context,"/homePage"
            );
              break;
            }
            case 1:{Navigator.pushNamed(context,
            "/leaderboardPage"
            );
              break;
            }
            case 2:{
              Navigator.pushNamed(context,"/settingsPage"
              );
              break;
            }
            case 3:{
              Navigator.pushNamed(context, "/chatPage");
              break;
            }
            
          }
        }
      ),*/
      
    );
    
  }
  
}