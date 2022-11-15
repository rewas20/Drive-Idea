class UserAccount {
  final String userId;
  final String userName;
  final String phoneNumber;
  final String email;
  final String password;

  UserAccount({
    required this.userId,
    required this.userName,
    required this.phoneNumber,
    required this.email,
    required this.password
  });

Map<String,dynamic> getMap(){
  return {
    "UserID" : userId,
    "userName" : userName,
    "phoneNumber" : phoneNumber,
    "email" : email,
    "password" : password,
  };
}
}
