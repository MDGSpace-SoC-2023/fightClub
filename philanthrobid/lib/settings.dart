import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:philanthrobid/MyLoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import "dart:io";
import "dart:convert";
import "package:http/http.dart" as http;
import 'package:google_fonts/google_fonts.dart';

class settings extends StatefulWidget {
  const settings({super.key});

  @override
  settingsState createState() {
    return settingsState();
  }
}

class settingsState extends State<settings> {
  XFile? profileFile;
  final ImagePicker _picker = ImagePicker();
  String? userNameSettings;
  final TextEditingController newUserName = TextEditingController();
  final FirebaseStorage storage = FirebaseStorage.instance;
  String? profileURL;
  String editTheUserName = "http://10.0.2.2:8000/philanthrobid/users";

  String? setProfileURL;
  Future<String> downloadThePic() async {
    try {
      Reference ref = storage.ref().child(
          "userProfilePictures/${FirebaseAuth.instance.currentUser?.uid}/profilePicture.jpg");
      String mayBeFinalURL = await ref.getDownloadURL();
      setState() {
        setProfileURL = mayBeFinalURL;
      }

      return mayBeFinalURL;
    } catch (e) {
      return "https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg?w=740&t=st=1703611707~exp=1703612307~hmac=d5c08a37edb8913608611752171bd6796bcdf0e1ff8ea65fb13a5e0475c36135";
    }
  }

  Future<void> getTheProfile(ImageSource myImgSource) async {
    try {
      //source tells whether from gallery or camera
      final pickedFile = await _picker.pickImage(
        source: myImgSource,
      );
      if (pickedFile != null) {
        print("picked file is not null");
        profileURL = await uploadProfilePic(
            FirebaseAuth.instance.currentUser!, pickedFile);
        setState(() {
          profileFile = pickedFile;
          setProfileURL = profileURL;
        });
      }
    } catch (e) {
      print("Error picking and/or Uploading image: $e ");
    }
  }

  Future<String> uploadProfilePic(User user, XFile profilePicture) async {
    UploadTask uploadingThePfp = storage
        .ref()
        .child("userProfilePictures/${user.uid}/profilePicture.jpg")
        .putFile(File(profilePicture.path));

    TaskSnapshot taskSnapshot = await uploadingThePfp;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      "ProfilePicture": downloadURL,
    });
    return downloadURL;
  }

  @override
  void initState() {
    super.initState();
    downloadThePic();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            String nameOfTheUser = snapshot.data!["Username"] ?? "defaultName";
            String profileOfThePicNew = snapshot.data!["ProfilePicture"] ??
                "https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg?w=740&t=st=1703611707~exp=1703612307~hmac=d5c08a37edb8913608611752171bd6796bcdf0e1ff8ea65fb13a5e0475c36135";
            return Scaffold(
                body: Container(decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,),
            
            child: Column(children:[SizedBox(height: 20),
            Stack(clipBehavior:Clip.none,children:<Widget>[CircleAvatar(radius:60,backgroundColor:Colors.tealAccent,
            child:CircleAvatar(radius:55,backgroundImage:NetworkImage (profileOfThePicNew),),
            
            ),
            Positioned(top:80,left:80,
            child:CircleAvatar(backgroundColor:Colors.grey,
            child:IconButton(icon:const Icon(Icons.add_a_photo,color:Colors.white,),
            onPressed:(){
              showModalBottomSheet(context: context,
              
              builder:(builder){
                return galleryOrCamera();
              } );
            },
            splashColor:Colors.white,),),)
            ],
            ),
            Container(
              margin:const EdgeInsetsDirectional.only(top:10),
              child: Row(
                //mainAxisAlignment:MainAxisAlignment.center,
              
              children:[
                const Padding(padding: EdgeInsets.all(10),),
                const Text("Username:",style:TextStyle(fontSize:18),),
              Expanded(
                child: Container(margin:const EdgeInsets.all(10),
                padding:const EdgeInsets.all(10),
                decoration: BoxDecoration(border:Border.all(color: Theme.of(context).colorScheme.tertiary,),
                borderRadius:BorderRadius.circular(10)
                ),
                  child: Text(nameOfTheUser,style:const TextStyle(fontSize:18))),
              ),
              IconButton(
               onPressed:(){
                
                showDialog(context: context, builder: (BuildContext context){
                return AlertDialog(title:const Text("Change Username",),
                content:SizedBox(height:100,
                  child: Column(children: [
                  TextField(controller:newUserName,
                  decoration:const InputDecoration(hintText:"Enter New Username")),
                  TextButton(onPressed:()async{
                    String NewUserName=newUserName.text.trim();
                    if (NewUserName != ""){
                    //await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).update({
                      //"Username":NewUserName,
                     // });
                      //Update for drf below
                      void updatingNameinBackend()async{
                      var sendingData={
                        "new_username":NewUserName,
                        "old_username":nameOfTheUser
                      };
                      try{
                        var response= await http.patch(Uri.parse(editTheUserName),  
                        headers:{
                          "Content-type":"application/json"
                        },
                        body:jsonEncode(sendingData));
                        if (response.statusCode==200){
                          print("Patched Successfully");
                          //setState((){
                          //newNameOk=true;});
                          await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).update({
                          "Username":NewUserName,
                         });
                         Navigator.pop(context);
            
                        }
                        else{
                          print("An error happened in response for changing the name ${response.statusCode}");
                          print ("Response body ${response.body}");
                          if (response.statusCode==500){
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
                                    Text("That name is already taken."),
                                  ],
                                )),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.white,//removes border thingy due to snackbars edges
                              elevation:0,//removes weird shadow
                              duration:const Duration(seconds:3),
                              ),
                              
            
                            );
                            //setState(() {
                            //  errorStatement="Sorry that username is taken";
            
                            //});
                          }
                          
                        }
                        
            
                      }catch(e){
                        print ("Error in changing username $e");
            
                      }}
                      updatingNameinBackend();
                      //if(newNameOk){
                      //await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).update({
                      //"Username":NewUserName,
                      //});
                      //Navigator.pop(context);}
            
                      }
                      //I am not sure since want working before but put nothig in field error here
                      
              
                  }, child:const Text("SAVE")),
                  
                  ]
                  ),
                 
                )
                );
               },);
              
               },
               icon:const Icon(Icons.edit,
               size:15,
               )
               )
               ]
               ),
            ),
            Row(
            
              children: [
                const Padding(padding: EdgeInsets.all(10)),
                const Text("Email Id:",style:TextStyle(fontSize: 18),),
              Expanded(
                child: Container(margin:const EdgeInsetsDirectional.all(10),
                padding:const EdgeInsets.all(10),
                decoration:BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.tertiary,),
                  borderRadius:BorderRadius.circular(10)
                ),
                child:
                 Text(FirebaseAuth.instance.currentUser!.email!,
                 style:const TextStyle(fontSize: 18),
                 ), 
                ),
              ),
            ]
            ),//EMAIL
            const SizedBox(height: 20),
            
            Center(child:TextButton(onPressed:()async{
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
              context,
              "/loginPage",
              (route)=>false
              
            );
            },
            style:ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.tertiary,),
            foregroundColor:MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.outline,),),
            child:const Text("Logout",style:TextStyle(fontSize:20,),)
            
            ), 
            ),
            ]
                    ),
          )
        );}
        else {
          
          return const SizedBox(height:10,width:10,child: Center(child: CircularProgressIndicator(value:null)));
          
        }
        
      }

      
      
    );

  }
Widget galleryOrCamera(){
  return Container(height:150,
  margin:const EdgeInsets.all(20),
  child: Column(children:[
     const Text("Choose Profile Picture",
    textAlign:TextAlign.center,
    style:TextStyle(fontSize:25,
    fontWeight:FontWeight.bold),
    ),
    const SizedBox(height:40),//cheap and ez padding 
    Row(mainAxisAlignment:MainAxisAlignment.center,
    children:<Widget> [TextButton.icon(onPressed: (){
      getTheProfile(ImageSource.camera);
      
    },//CAMERA
     icon: const Icon(Icons.camera),
     label:const Text("CAMERA")),
     const SizedBox(width:40),
    TextButton.icon(onPressed: (){
      getTheProfile(ImageSource.gallery);
    },//GALLERY
     icon: const Icon(Icons.image_outlined),
     label:const Text("GALLERY"))],
    )
  ])

  );
}

}

