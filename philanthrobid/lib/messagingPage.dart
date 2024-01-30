import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:http/http.dart" as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "dart:convert";
import "package:philanthrobid/listings.dart";
import 'package:web_socket_channel/status.dart' as status;
import 'package:google_fonts/google_fonts.dart';


class messagingPage extends StatefulWidget{
  Map<String,Object?> sendingData={};
  messagingPage({super.key,required this.sendingData});
  @override
  State<messagingPage> createState()=> messagingState();
}

class messagingState extends State<messagingPage>{
     late final WebSocketChannel socketConnection;
     TextEditingController messageController=TextEditingController();
     String name="";
     String message_data="";
     List<message> messageList=[];
     final ScrollController autoController= ScrollController();
     
     @override
     void  initState(){
      super.initState();
      String wsurl="ws://10.0.2.2:8000/ws/chat/conv_id=${widget.sendingData["group_id"]}";

      socketConnection=WebSocketChannel.connect(Uri.parse(wsurl));
      getOldMessages();
      setUpStreamListen();
    
      
     }
     
     @override
     void dispose(){
      socketConnection.sink.close();
      super.dispose();

     }
      void getOldMessages()async{
      await getName();
      
      var response=await http.get(Uri.parse("http://10.0.2.2:8000/philanthrobid/messages/?group=${widget.sendingData["group_id"]}"));
      if (response.statusCode==200)
      {
        print(response.body);
        List<dynamic> jsonList=json.decode(response.body);
        setState(() {
          messageList=jsonList.map((item)=>message.fromJson(item)).toList();
          
        });
        
        }
      
     }
     void jumpTobottom(){
      if (autoController.hasClients){
        autoController.jumpTo(autoController.position.maxScrollExtent);
      }
     }
     void setUpStreamListen(){
        socketConnection.stream.listen((event) {
      Future<void> refresh()async{
      var tobeadded=json.decode(event);
      print(tobeadded);
     
      setState(() {
        messageList.add(message(sender:tobeadded["sender"], message_data: tobeadded["message"]));
        
        
      });
     }
        print('boyyyyy');
        print(event);
        
        refresh();
        
       },
       onError:(error){
        print("error");
       });
      

      }
     /*Future<void> refresh()async{
      var tobeadded=json.decode()
      messageList.add();
      setState(() {
        
      });
     }*/
   /*scrollToBottom(){
      autoController.jumpTo(autoController.position.maxScrollExtent,
       );
    }*/
    Future<void> getName()async{
    DocumentSnapshot named =await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).get();

      name=named["Username"];

  }
     Widget build (BuildContext context){
      SchedulerBinding.instance.addPostFrameCallback((_){
        if (autoController.hasClients){
        autoController.animateTo(autoController.position.maxScrollExtent,
         duration:const Duration(milliseconds:250),
        curve: Curves.easeInOut);}
      });
      //WidgetsBinding.instance.addPostFrameCallback(scrollToBottom());
      return Scaffold(
        appBar:AppBar(backgroundColor:Colors.pink,
        //centerTitle:true,
        title: Text(widget.sendingData["Listingtitle"] as String,
        style: GoogleFonts.ubuntu(textStyle:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),)),
        body:Stack(
          children:[Column(
            children:[
            (messageList.isNotEmpty)?Expanded(
          
              child: SizedBox(
                
                child: (ListView.builder(
                  
                  itemCount: messageList.length,
                
                controller:autoController,
                itemBuilder: (context,index){
                  bool is_sender=messageList[index].sender==name;
                  
                  return Row(
                    mainAxisAlignment: (is_sender)?MainAxisAlignment.end:MainAxisAlignment.start,
                    children: [
                      Container(
                        constraints:const BoxConstraints(maxWidth:250),
                        //color:(is_sender)?Colors.green:Colors.grey,
                        decoration: BoxDecoration(color:(is_sender)?Colors.green:Colors.blueGrey,
                        border:Border.all(),borderRadius:BorderRadius.circular(10)),
                      
                        margin:const EdgeInsetsDirectional.only(end:5 ,top:2,bottom:2,start: 5),
                        child:ListTile(
                        
                        title:Text(messageList[index].message_data,textAlign: (is_sender)?TextAlign.right:TextAlign.left,),
                        
                        //tileColor:(is_sender)?Colors.green:Colors.grey,
                        
                      )),
                    ],
                  );
                
                },)),
              ),
            ):Expanded(child:Column(),),//to ensure message stays at bottom
            Align(alignment:Alignment.bottomCenter,
            child:Container(
              color:Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    
                    margin:const EdgeInsetsDirectional.only(start:10,bottom: 5),
                    width:320,
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(enabledBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                        borderRadius:BorderRadius.circular(10)
                      )),
                    ),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: IconButton(onPressed:()async{
                      message_data=messageController.text;
                      messageController.clear();
                      var sendingDataMessage={
                        "message":message_data,
                        "sender":name
                      };
                      
                      socketConnection.sink.add(
                        jsonEncode(sendingDataMessage)
                      
                      );
                      print("hi");
                      
                      
                      
                          
                    }, icon: Icon(Icons.send)),
                  )
                ],
              ),
            ))
          ]),
            /*Align(alignment:Alignment.bottomCenter,
            child:Container(
              color:Colors.white,
              child: Row(
                
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin:const EdgeInsetsDirectional.only(start:10,bottom: 5),
                    width:320,
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(border:OutlineInputBorder(
                        borderRadius:BorderRadius.circular(10)
                      )),
                    ),
                  ),
                  IconButton(onPressed:(){
                    message_data=messageController.text;
                    messageController.clear();
                    var sendingDataMessage={
                      "message":message_data,
                      "sender":name
                    };
                    
                    socketConnection.sink.add(
                      jsonEncode(sendingDataMessage)
                    
                    );
                    print("hi");
                        
                  }, icon: Icon(Icons.send))
                ],
              ),
            ))*/
          ],
        )
      );
     }
}