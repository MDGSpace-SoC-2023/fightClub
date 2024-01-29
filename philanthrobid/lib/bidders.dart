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