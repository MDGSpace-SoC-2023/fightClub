import 'package:flutter/material.dart';
import "package:philanthrobid/addAListing.dart";
import "package:philanthrobid/biddingPage.dart";
import "package:philanthrobid/settings.dart";
import "package:philanthrobid/leaderboard.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import 'package:philanthrobid/listings.dart';


class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreen();
}

class _homeScreen extends State<homeScreen> {
  String getListingsURL="http://10.0.2.2:8000/philanthrobid/listings";
  final TextEditingController _searchController=TextEditingController();
  int _currentIndex=0;
  late List<Listing>? listingList=[];
 int? selectedListing;
 String searched="";
 

  @override
  void initState(){
    super.initState();
    getListingList();
  }
  Future<void> getListingList()async{
    var response = await http.get(Uri.parse(getListingsURL));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode==200){
      final List<dynamic> jsonList = json.decode(response.body);
       setState(() {
         listingList= jsonList.map((item)=>
         Listing.fromJson(item)).toList();
       });

    }else{
      throw Exception("Failed to load");
    }
    //final listingElements = json.decode(response.body).cast<Map<String,dynamic>>();
    //List<Listing> listingList = listingElements.map<Listing>((json){
    //  return Listing.fromJson(json);
    //}).toList();
   // return listingList;
  }


  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //removes default backbutton since the homepage is not home according to flutter
        title: const Text("Home",style:TextStyle(color:Colors.white),),
        centerTitle: true,
        backgroundColor:const Color.fromARGB(255, 246, 179, 202),
      ),
      body:Stack(children:[
      /*CustomScrollView(slivers: [SliverAppBar(expandedHeight: 40, floating:true,
      automaticallyImplyLeading:false,
      title:TextField(controller:_searchController,
      decoration:InputDecoration(hintText:"Search",
      suffixIcon:IconButton(icon:const Icon(Icons.clear,color:Colors.black),onPressed:(){
        _searchController.clear();
      })),
      ),),
      
      ],
      //Rest of the body below this 
      
      
      



      ),*/
      
      Column(
        children: [
          Container(

        child:TextField(onChanged: (value) {
          
        },
        decoration:const InputDecoration(
          hintText:"Search",
          border:OutlineInputBorder( 
          ),
          prefixIcon: const Icon(Icons.search)
        ),)
      ),
          Expanded(
            child: listingList != null?ListView.builder(itemCount: listingList?.length,
            itemBuilder:(context,index){
              String toBeDisplayed;
              if(listingList![index].bid!=0){
                toBeDisplayed="Current Bid -\u{20B9}${listingList![index].bid}";
              }
              else{
                toBeDisplayed="Starting Bid -\u{20B9}${listingList![index].strtbid}";
              }
              return Card(child:ListTile(title:
                  Text(listingList![index].title,
                  //textAlign:TextAlign.center,
                  style:const TextStyle(fontSize:25,color:Color.fromARGB(186, 0, 0, 0),
                  fontWeight:FontWeight.w400,
                  //decoration: TextDecoration.underline
                  ),
                  
                  ),
                  
                  
               
              subtitle:
                Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  
                  children: [
                    Text(listingList![index].description,
                    //textAlign:TextAlign.center,
                    maxLines:2,
                    style:const TextStyle(color: Color.fromARGB(167, 3, 168, 244)),),
                    Container(
                      //padding: const EdgeInsets.all(5),
                      //decoration:BoxDecoration(
                       // border: Border.all(),
                       // borderRadius:BorderRadius.circular(10),
                      //),
                      child: Text (toBeDisplayed,
                      //textAlign: TextAlign.left,
                      style:const  TextStyle(color:Colors.lightGreen,fontSize:18),),
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
            },):const Center(child:CircularProgressIndicator()),
          ),
        ],
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

      Positioned(top:580,left:328,child:CircleAvatar(radius:28,backgroundColor:Color.fromARGB(255, 246, 179, 202), child:Center(child:IconButton(iconSize:40,
      icon:const Icon(Icons.add,color:Colors.white,),
      onPressed:(){
        Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context){
          return addAListing();
        }
        )
        );

      },//onPressed
      )
      )
      )
      ),
      
      
      ]
      )
      ,
      bottomNavigationBar:BottomNavigationBar(
        currentIndex: _currentIndex,
        fixedColor:const Color.fromARGB(255, 246, 179, 202),
        items:const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label:"Home",),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard),label:"Leaderboard",),
          BottomNavigationBarItem(icon: Icon(Icons.settings),label:"Settings",),
        ],
        onTap: (int index){
          setState(() {
            _currentIndex=index;
          });
          switch(index){
            case 0:{Navigator.push(context,MaterialPageRoute(builder:(BuildContext context){
                return const homeScreen();})
            );
              break;
            }
            case 1:{Navigator.push(context,MaterialPageRoute(builder:(BuildContext context){
                return  Leaderboard();})
            );
              break;
            }
            case 2:{
              
              Navigator.push(context,MaterialPageRoute(builder:(BuildContext context){
                return const settings();
                

              })


              );
              break;
            }
            
          }
        }
      ),
      
    );
    
  }
  
}