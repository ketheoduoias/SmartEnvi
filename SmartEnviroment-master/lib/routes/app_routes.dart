// ignore_for_file: constant_identifier_names

part of './app_pages.dart';

abstract class Routes {
  static const INITIAL = '/';

  static const LOGIN_SCREEN = '/login';
  static const SIGNUP_SCREEN = '/signup';
  static const FORGOT_PASSWORD_SCREEN = '/forgot_password';

  static const HOME_SCREEN = '/home';
  static const MAP_SCREEN = '/map';
  static const MAP_FILTER_SCREEN = '/map_filter_screen';

  static const CREATE_REPORT_SCREEN = '/create_report_screen';

  static const EDIT_PROFILE_SCREEN = '/edit_profile_screen';
  static const PROFILE_SCREEN = '/profile_screen';
  static const OTHER_PROFILE_SCREEN = '/other_profile_screen';

  static const DETAIL_POLLUTION_SCREEN = '/detail_pollution_screen';

  static const NOTIFICATION_SCREEN = '/notification_screen';

  static const MANAGE_SCREEN = '/manage_screen';

  static const FAVORITE_SCREEN = '/favorite_screen';
}
