import 'package:flutter/material.dart';
import 'package:home_inventory/models/usermodel.dart';
import 'package:home_inventory/screens/loginpage.dart';
import 'package:home_inventory/screens/myhomepage.dart';
import 'package:home_inventory/services.dart/auth.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   final auth = Provider.of<AuthService>(context); 
    return !auth.isLoggedIn? LoginPage(): MyHomePage();
  }
}