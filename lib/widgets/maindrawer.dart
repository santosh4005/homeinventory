import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_inventory/models/user.dart';
import 'package:home_inventory/providers/inventoryprovider.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderInventory>(context, listen: false);

    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: Drawer(
        child: sideNav(provider, context),
      ),
    );
  }

  Drawer sideNav(ProviderInventory provider, BuildContext context) {
    return Drawer(
        child: Stack(children: <Widget>[
      //first child be the blur background
      Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).accentColor
          ]))),
      ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(
            child: FutureBuilder<UserData>(
          future: provider.fetchUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircleAvatar(
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              );
            } // 'https://via.placeholder.com/150',
            if (snapshot.hasData) {              
             return CircleAvatar(
                child: Icon(
                  Icons.person,
                  size: 90,
                ),
              );
              //  return Container(
              //     width: 10.0,
              //     height: 15.0,
              //     decoration: BoxDecoration(
              //       image: DecorationImage(
              //           fit: BoxFit.cover,
              //           image: NetworkImage(snapshot.data.imageurl)),
              //       borderRadius: BorderRadius.all(Radius.circular(8.0)),
              //       color: Colors.redAccent,
              //     ));
            } else {
              return CircleAvatar(
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              );
            }
          },
        )),
        Divider(thickness: 0.5),
        ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.supervised_user_circle),
          ),
          title: Text("Logout"),
          onTap: () async {
            provider.clearInventory();
            Navigator.of(context).pop();
            await FirebaseAuth.instance.signOut();
          },
        ),
      ])
    ]));
  }
}
