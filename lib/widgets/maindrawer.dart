import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_inventory/providers/inventoryprovider.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(    
        child: Column(          
          children: <Widget>[
            AppBar(
              
              title: Text("Menu"),
              automaticallyImplyLeading: false,
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.supervised_user_circle),
              ),
              title: Text("Logout"),
              onTap: () {
                Provider.of<ProviderInventory>(context, listen: false).clearInventory();
                Navigator.of(context).pop();
                FirebaseAuth.instance.signOut();
              },
            )
          ],
        ),
      );
  }
}