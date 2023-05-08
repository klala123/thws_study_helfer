
import 'dart:core';



class UserData {
  String? id;
  String? name;



UserData ({ this.id, required this.name });

  Map< String, dynamic > toJson ( ) {
    return {
      'id' : this.id ,
      'name': this.name,

    };
  }


}