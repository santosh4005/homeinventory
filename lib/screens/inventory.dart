import 'package:flutter/material.dart';
import 'package:home_inventory/models/inventoryitem.dart';
import 'package:home_inventory/providers/inventoryprovider.dart';
import 'package:home_inventory/screens/addinventory.dart';
import 'package:home_inventory/screens/inventoryitem.dart';
import 'package:provider/provider.dart';

class ScreenInventory extends StatefulWidget {
  // static const String name = "/inventory";

  final String tag;
  ScreenInventory(this.tag);

  @override
  _ScreenInventoryState createState() => _ScreenInventoryState();
}

class _ScreenInventoryState extends State<ScreenInventory> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ProviderInventory>(context, listen: false)
          .fetchAndSetInventory();
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderInventory>(context);

    List<ModelInventoryItem> itemsList = [];
    if (widget.tag == "") {
      itemsList = provider.items;
    } else {
      itemsList =
          provider.items.where((element) => element.tag == widget.tag).toList();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return ScreenAddInventory(
                tagValue: widget.tag,
                editItem: null,
                isEditMode: false,
              );
            },
          ))
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Theme.of(context).primaryColor,
          Colors.white,
        ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
        child: SafeArea(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                  onRefresh: () =>
                      provider.fetchAndSetInventory(hardrefresh: true),
                  child: ListView.separated(
                      itemBuilder: (ctx, index) {
                        return Dismissible(
                          confirmDismiss: (direction) => showDialog(
                              context: ctx,
                              child: AlertDialog(
                                actions: <Widget>[
                                  RaisedButton(
                                    child: Text("Cancel"),
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                  ),
                                  RaisedButton(
                                    child: Text("OK"),
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
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
                              content: Text(
                                  "Deleted ${itemsList[index].title} from the list"),
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
                            leading: itemsList[index].imageUrl == null
                                ? CircleAvatar(
                                    child: Icon(Icons.ac_unit),
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(itemsList[index].imageUrl),
                                  ),
                            title: Text(itemsList[index].title),
                            subtitle: Text(itemsList[index].tag +
                                ": " +
                                itemsList[index].shelfName),
                            trailing:
                                Text(itemsList[index].quantity.toString()),
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (ctx) {
                                return ScreenAddInventory(
                                  tagValue: itemsList[index].tag,
                                  editItem: itemsList[index],
                                  isEditMode: true,
                                );

                                // return ScreenInventoryItem(
                                //   modelInventoryItem: itemsList[index],
                                // );
                              }));
                            },
                          ),
                        );
                      },
                      itemCount: itemsList.length,
                      separatorBuilder: (ctx, i) {
                        return Divider();
                      }),
                ),
        ),
      ),
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
                element.title.toLowerCase().contains(query.toLowerCase()))
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
