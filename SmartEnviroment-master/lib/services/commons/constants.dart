const kAnimationDuration = Duration(milliseconds: 200);

final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Vui lòng nhập email";
const String kInvalidEmailError = "Email không đúng định dạng";
const String kPassNullError = "Vui lòng nhập mật khẩu";
const String kShortPassError = "Mật khẩu quá ngắn";
const String kMatchPassError = "Mật khẩu không trùng nhau";
const String kNamelNullError = "Vui lòng nhập tên của bạn";
const String kPhoneNumberNullError = "Vui lòng nhập số điện thoại";

const String kRememberLogin = "kRememberLogin";
const String kEmail = "kEmail";
const String kPassword = "kPassword";
const String kCurrentUser = "kCurrentUser";
const String kThemeMode = "kThemeMode";
const String kFavorite = "kFavorite";

const String kHiveBox = "smartenvironment";

const String kRoleAdmin = "admin";
const String kRoleMod = "mod";
