import 'package:flutter/material.dart';
import "package:philanthrobid/addAListing.dart";
import "package:philanthrobid/settings.dart";
import "package:philanthrobid/leaderboard.dart";



class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreen();
}

class _homeScreen extends State<homeScreen> {
  final TextEditingController _searchController=TextEditingController();
  int _currentIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //removes default backbutton since the homepage is not home according to flutter
        title: const Text("Home",style:TextStyle(color:Colors.white),),
        centerTitle: true,
        backgroundColor:const Color.fromARGB(255, 246, 179, 202),
      ),
      body:Stack(children:[CustomScrollView(slivers: [SliverAppBar(expandedHeight: 40, floating:true,
      automaticallyImplyLeading:false,
      title:TextField(controller:_searchController,
      decoration:InputDecoration(hintText:"Search",
      suffixIcon:IconButton(icon:const Icon(Icons.clear,color:Colors.black),onPressed:(){
        _searchController.clear();
      })),
      ),),
      
      ],
      //Rest of the body below this 


      ),
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
      )
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
            case 0:{
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