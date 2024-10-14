class Pocket {
  final int id;
  final String? name;
  final double balance;

  const Pocket({
    required this.id,
    required this.name,
    required this.balance,
  });

  factory Pocket.fromJson(Map<String, dynamic> json) {
    return Pocket(
      id: json['id'] as int,
      name: json['name'] as String,
      balance: json['balance'] as double,
    );
  }
}


// class Character {
//   int id;
//   String name;
//   Double balance;

//   Character.fromJson(Map json)
//       : id = json['id'],
//         name = json['name'],
//         img = json['img'],
//         nickname = json['nickname'];

//   Map toJson() {
//     return {'id': id, 'name': name, 'img': img, 'nickname': nickname};
//   }
// }
