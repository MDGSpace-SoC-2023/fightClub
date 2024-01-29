import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

Future<String> getName()async{
 final FirebaseFirestore firestore = FirebaseFirestore.instance; 
 String? userId = FirebaseAuth.instance.currentUser?.uid;

  
 DocumentSnapshot named=await firestore.collection("users").doc(userId).get();

  String nameOfTheUser = named["Username"];
  return nameOfTheUser;

}
 


