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
  bool is_active;
  int E_Sports;
  int Dance;
  int Sports;
  int Spiritual;
  int Music;
  int Education;
  String endDate;

  Listing({
  required this.list_id,
  required this.user,
  required this.title,
  required this.description,     //THE CURLY BRACKETS MAKE THIS A NAMED CONSTRUCTOR so when initialise it youneed to initialise name by name nstead of remembering order. it enhances readability
  required this.bid,
  required this.strtbid,
  required this.mininc,
  required this.created_at,
  this.bidding_user,
  required this.is_active,
  required this.E_Sports,
  required this.Dance,
  required this.Sports,
  required this.Spiritual,
  required this.Music,
  required this.Education,
  required this.endDate
  });
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
      is_active:json["is_active"],
      E_Sports:json["E_Sports"],
      Dance:json["Dance"],
      Sports:json["Sports"],
      Spiritual:json["Spiritual"],
      Music:json["Music"],
      Education:json["Education"],
      endDate: json["endDate"]

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

class Conversation{
    int group_id;
    String winner;
    String seller;
    String created_at;
    String Listingtitle;
    Conversation({
      required this.created_at,
      required this.group_id,
      required this.seller,
      required this.winner,
      required this.Listingtitle
    });
  factory Conversation.fromJson(Map<String,dynamic> json){
    return Conversation(
     group_id: json["group_id"],
     created_at: json["created_at"],
     winner: json["winner"],
     seller:json["seller"],
     Listingtitle:json["Listingtitle"]
     );
  }
}

class message{
  int? message_id;
  int? group;
  String sender;
  String? sent_at;
  String message_data;
  message({
    this.message_id,
    this.group,
    required this.sender,
    this.sent_at,
    required this.message_data
  });
  factory message.fromJson(Map<String,dynamic>json){
    return message(//message_id: json["message_id"],
     //group: json["group"],
     sender: json["sender"],
     //sent_at:json["sent_at"],
     message_data:json["message_data"]
     );

  }

}
class Bidder{
  int user;
  int money_spent;
  String name;

  Bidder({
    required this.user,
    required this.money_spent,
    required this.name
  });
  factory Bidder.fromJson(Map<String,dynamic> json){
    return Bidder(
      user: json["user"],
      money_spent: json["money_spent"],   //.fromJson is part of name and a convention takes a json Map and return a normal Listing json[] basically means accesing the elment having that key of a jsonMap
      name: json["username"],
      

    );
  }
  
}