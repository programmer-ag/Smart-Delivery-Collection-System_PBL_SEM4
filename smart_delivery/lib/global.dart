class UserData {
  static final UserData _instance = UserData._internal();

  factory UserData() {
    return _instance;
  }

  UserData._internal();

  String boxId = "";
  String personName = "";
  String mobileNumber = "";
}
