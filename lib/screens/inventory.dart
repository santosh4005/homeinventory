import 'package:flutter/material.dart';
import 'package:home_inventory/models/inventoryitem.dart';
import 'package:home_inventory/providers/inventoryprovider.dart';
import 'package:home_inventory/screens/inventoryitem.dart';
import 'package:provider/provider.dart';

class ScreenInventory extends StatelessWidget {
  static const String name = "/inventory";

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderInventory>(context);
    var itemsList = provider.items;

    return Scaffold(
      appBar: AppBar(
        title: Text("My Inventory (${itemsList.length})"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: DataSerach(itemsList));
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: ListView.separated(
          itemBuilder: (ctx, index) {
            return Dismissible(
              confirmDismiss: (direction) => showDialog(
                  context: ctx,
                  child: AlertDialog(
                    actions: <Widget>[
                      RaisedButton(
                        child: Text("Cancel"),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      RaisedButton(
                        child: Text("OK"),
                        onPressed: () => Navigator.of(context).pop(true),
                      )
                    ],
                    title: Text("Hmmm...."),
                  )),
              direction: DismissDirection.endToStart,
              key: ValueKey(itemsList[index].id),
              onDismissed: (direction) {
                provider.removeItemFromInventory(index);
                Scaffold.of(ctx).hideCurrentSnackBar();
                Scaffold.of(ctx).showSnackBar(SnackBar(
                  content:
                      Text("Deleted ${itemsList[index].title} from the list"),
                ));
              },
              background: Container(
                alignment: Alignment.centerRight,
                color: Colors.red,
                child: Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                  size: 36.0,
                ),
              ),
              child: ListTile(
                title: Text(itemsList[index].title),
                subtitle: Text(itemsList[index].shelfName),
                trailing: Text(itemsList[index].quantity.toString()),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return ScreenInventoryItem(
                      modelInventoryItem: itemsList[index],
                    );
                  }));
                },
              ),
            );
          },
          itemCount: itemsList.length,
          separatorBuilder: (ctx, i) {
            return Divider();
          }),
    );
  }
}

class DataSerach extends SearchDelegate<ModelInventoryItem> {
  List<ModelInventoryItem> searchItems;
  DataSerach(this.searchItems);

  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for app bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading icon on the left of the app bar (back arrow)
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //show search results based on the selection
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //show when someone searches for something
    final suggestionList = query.isEmpty
        ? searchItems.take(1).toList()
        : searchItems
            .where((element) =>
                element.title.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            leading: Icon(Icons.check_box),
            title: RichText(
              text: TextSpan(
                  text: suggestionList[index].title.substring(0, query.length),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                        text:
                            suggestionList[index].title.substring(query.length),
                        style: TextStyle(
                          color: Colors.grey,
                        ))
                  ]),
            ),
            subtitle: Text(suggestionList[index].shelfName),
            trailing: Text(
              suggestionList[index].quantity.toString(),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return ScreenInventoryItem(
                  modelInventoryItem: suggestionList[index],
                );
              }));
            },
          );
        });
  }
}
