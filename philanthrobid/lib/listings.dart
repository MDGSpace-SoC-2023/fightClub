class Listing{
  int list_id;
  String user;
  String title;
  String description;
  int bid;
  int strtbid;
  int mininc;
  String created_at;
  String? bidding_user;

  Listing({
  required this.list_id,
  required this.user,
  required this.title,
  required this.description,     //THE CURLY BRACKETS MAKE THIS A NAMED CONSTRUCTOR so when initialise it youneed to initialise name by name nstead of remembering order. it enhances readability
  required this.bid,
  required this.strtbid,
  required this.mininc,
  required this.created_at,
  this.bidding_user});
  factory Listing.fromJson(Map<String,dynamic> json){
    return Listing(
      list_id: json["list_id"],
      user: json["user"],   //.fromJson is part of name and a convention takes a json Map and return a normal Listing json[] basically means accesing the elment having that key of a jsonMap
      title: json["title"],
      description: json["description"],
      bid: json["bid"],
      strtbid:json["strtbid"] ,
      mininc: json["mininc"],
      created_at:json["created_at"] ,
      bidding_user: json["bidding_user"],

    );
  }
  Map<String,dynamic>toJson()=>{
    "list_id":list_id,  // a function to convert to json just in case
    "user":user,
    "title":title,
    "description":description,
    "bid":bid,
    "strtbid":strtbid,
    "mininc":mininc,
    "created_at":created_at,
    "bidding_user":bidding_user,

  };
}

class unpaidListing{
  String unpaidName;
  String title;
  int amount;
  int id_of_listing;
  unpaidListing({
    required this.unpaidName,
    required this.title,
    required this.amount,
    required this.id_of_listing,

  });
  factory unpaidListing.fromJson(Map<String,dynamic> json){
    return unpaidListing(unpaidName: json["unpaidName"],
     title: json["title"],
     amount: json["amount"],
     id_of_listing:json["id_of_listing"]);
  }

}