import "package:flutter/material.dart";
import "package:flutter/services.dart";
class addAListing extends StatefulWidget{
  const addAListing({super.key});
  @override
  State<addAListing> createState()=> _addAListing();
}
class _addAListing extends State<addAListing>{
  final TextEditingController _titleOfListing=TextEditingController();
  final TextEditingController _descriptionOfListing=TextEditingController();
  final TextEditingController _startingBidOfListing=TextEditingController();
  final TextEditingController _minmIncrementOfListing=TextEditingController();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(backgroundColor: const Color.fromARGB(255, 246, 179, 202),
      title:const Text("Add your Listing",style:TextStyle(color:Colors.white),),
      centerTitle:true,
      ),
      body:SingleChildScrollView(child: Column(children:[Container(margin:const EdgeInsets.all(10),
      child:TextField(decoration:InputDecoration(hintText:"Title of the Listing",
      enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(20),),),
      controller:_titleOfListing,
      )
      ),//title Text Field
      Container(margin:EdgeInsetsDirectional.only(start:10,end:10),//margin
      child:TextField(controller:_descriptionOfListing,
      maxLines:10,decoration:InputDecoration(hintText:"Description of the Listing(max char:1024)",
      enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(20)))
      )
      ),
      Container(margin:EdgeInsetsDirectional.only(top:10,start:90,end:90),
      child:TextField(keyboardType:TextInputType.number,
      inputFormatters:<TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
      controller:_startingBidOfListing,
      decoration:InputDecoration(prefixIcon:Icon(Icons.currency_rupee),hintText:"Starting Bid",
      enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(20))),)
      ),
      Container(margin:EdgeInsetsDirectional.only(top:10,start:90,end:110,bottom:25),
      child:TextField(keyboardType:TextInputType.number,
      inputFormatters:<TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
      controller:_minmIncrementOfListing,
      decoration:InputDecoration(prefixIcon:Icon(Icons.currency_rupee),hintText:"Min. Increment",
      enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(20))),)
      ),
      TextButton(style:ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(255, 246, 179, 202),)),child:Text("Add Listing",style:TextStyle(fontSize:20,color:Colors.white),),onPressed:(){},)
      ]//think of the children
      )
      )
      
    
    );
  }
}