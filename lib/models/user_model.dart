class UserModel{
  final int id;
  final String name;

  UserModel({this.id = -1, required this.name});

  UserModel copyWith({int? id, String? name}){
    return UserModel(name: name ?? this.name, id: id ?? this.id);
  }

  factory UserModel.fromMap(Map<String,dynamic> map){
    return UserModel(name: map['name'], id: map['id']);
  }

  Map<String,dynamic> toMap()=>{
    'id': id,
    'name': name
  };
}