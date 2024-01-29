import 'package:flutter/material.dart';
import "package:philanthrobid/bidders.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import 'package:google_fonts/google_fonts.dart';


class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  String biddersURL = "http://10.0.2.2:8000/philanthrobid/bidders";
  List<Bidder>? BiddersList = [];
  String name = "";
  @override
  void initState(){
    super.initState();
    
    getBidders();
    
    
    
  }


  Future<void> getBidders()async{
    var response = await http.get(Uri.parse(biddersURL));
    if(response.statusCode==200){
      final List<dynamic> jsonList = json.decode(response.body);
      print(jsonList);

      setState(() {
        BiddersList = jsonList.map((item) => Bidder.fromJson(item)).toList();
        print(BiddersList);
      });
    }else{
        throw Exception("failed to load Bidderslisting");
      }
        
  }
  
    @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      body:
        //decoration: BoxDecoration(
        //  color: Theme.of(context).colorScheme.background,
        //),
 Column(
          children: [
             
            Expanded(
              
              child: BiddersList != null?ListView.builder(itemCount:(BiddersList?.length)??0, 
              itemBuilder:(context,index){          
                String toBeDisplayed="${(index+1).toString()}. ${BiddersList![index].name}";
                print(toBeDisplayed);
                Color color = Theme.of(context).colorScheme.surface;
                if(index==0){
                  color = Color.fromARGB(255, 255, 230, 1);
                }else if(index==1){
                  color = Color.fromARGB(255, 161, 159, 159);
                }else if(index==2){
                  color = Color.fromARGB(255, 201, 92, 9);
                }
                
                return Card(
                  color: color,
                  child:ListTile(title:
                    Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      
                      children: [
                        Container(
                          
                          child: Text(toBeDisplayed,
                          
                          //textAlign:TextAlign.center,
                          style:GoogleFonts.openSans(textStyle: TextStyle(fontSize:20,color: Theme.of(context).colorScheme.onPrimary, fontWeight:FontWeight.bold,)),
                          //decoration: TextDecoration.underline
                          ),
                        ),
                        
                      ],
        
                    ),
                    
                    
                    
                 
                subtitle:
                  Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    
                    children: [
                       Text(BiddersList![index].money_spent.toString(),
                      textAlign:TextAlign.center,
                       maxLines:2,
                       style:TextStyle(color: Theme.of(context).colorScheme.onPrimary,),),
                      
                    ],
                  ),
                ),
                
                
                );
                
        
              }
              ,):const Center(child:CircularProgressIndicator()),
            ),
          ],
        ),
      
      
    );
  }
}
