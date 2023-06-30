import 'package:flutter/material.dart';
import 'package:pollution_environment/model/user_response.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  final UserModel? user;

  const Body({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 50),
          ProfilePic(
            user: user,
          ),
          const SizedBox(height: 20),
          Text(
            user?.name ?? "",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          Text(user?.email ?? ""),
          const SizedBox(height: 20),
          const Divider(
            height: 1,
          ),
          ProfileMenu(
            user: user,
          ),
        ],
      ),
    );
  }
}
