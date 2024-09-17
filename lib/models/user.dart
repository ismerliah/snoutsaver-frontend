class Users {
  String username;
  String email;
  String password;
  String confirm_password;

  Users(this.username, this.email, this.password, this.confirm_password);

  factory Users.fromJSON(dynamic data){
    return Users(data['username'], data['email'], data['password'], data['confirm_password']);
  }

}