//import 'dart:js';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:famnet/first_screen.dart';
import 'add_group.dart';
import 'dart:async';
import 'dart:core';
import 'package:famnet/sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
var r;

final dbRef = FirebaseDatabase.instance.reference().child("groups");
class Groups extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    r = MediaQuery.of(context).size;
    return MaterialApp(
      title: 'Search Groups',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      home: Home(),
    );
  }
}

class Post {
  final String title;
  final String body;
  final String gid;

  Post(this.title, this.body,this.gid);
}

Post gPost;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SearchBarController<Post> _searchBarController = SearchBarController();

  //Calls get groups and then populates the search bar with all values retrieved from DB query
  Future<List<Post>> _getALlPosts(String text) async {
    var glist = await FirebaseGroups.getGroups("$text");
    List<Post> posts = [];
    if(glist.hasData==1) {
      var Valist = glist.matchGroups;
      var Klist=glist.keyMap;
      for (var i = 0; i < Valist.length; i++) {
        var tgroup = Valist[i];
        posts.add(Post(tgroup["Gname"], tgroup["Description"],Klist[i]));
      }
    }
    return posts;
  }
  Future navigateToAddGroups(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddGroups()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Groups"
        ),
        automaticallyImplyLeading: true,
        leading: IconButton(icon:Icon(Icons.arrow_back),
          onPressed: () { Navigator.of(context).push(MaterialPageRoute(builder: (context) => FirstScreen())); },
        ),
      ),
      body: SafeArea(
        key: new Key("safearea"),
        child: SearchBar<Post>(
          key: new Key("searchbar"),
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          onSearch: _getALlPosts,
          searchBarController: _searchBarController,
          cancellationWidget: Text("Cancel"),
          emptyWidget: Text("empty"),
          header: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(
                key: new Key("adab"),
                child: Text("Create group"),
                onPressed: () {
                  navigateToAddGroups(context);
                },
              ),
            ],
          ),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 2,
          onItemFound: (Post post, int index) {
            return Container(
              color: Colors.lightBlue,
              child: ListTile(
                title: Text(
                  post.title,
                  ),
                isThreeLine: true,
                subtitle: Text(post.body),
                onTap: () {
                  gPost = post;
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Detail()));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
//This class can be edited to better display contents when clicked
class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black12,
        ),
        title: Text(
          gPost.title,
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
        top: true,
        left: true,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 5,
              color: Colors.blueGrey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:8.0, horizontal: 50),
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.group),
                        Text("Group Description : ", style: TextStyle(fontSize: 24,color: Colors.white70, fontWeight: FontWeight.bold)),
                        SizedBox(height:40),
                        Text(gPost.body, style: TextStyle(fontSize: 24,color: Colors.white70)),
                      ]
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        //                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Detail()));
        onPressed: () {
          /*  TODO :  This needs to go to add so that we can send the information to the database
          *   TODO :  and I'm not sure how we're going to do that.
          */
          _saveData(gPost);
//          Navigator.of(context).push(MaterialPageRoute(builder: (context) => add()));
          },
        elevation: 10.0,
        backgroundColor: Colors.blueGrey,
        icon: Icon(
          Icons.add
        ),
        label: Text("Add Group"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
//A class that holds a list of maps of the retrieved json values. Not really sure what to do with the key
//but it may be important later?
class Gcreation {
  final String key;
  var hasData=1;
  List<Map> matchGroups= List<Map>();
  List<String> keyMap = List<String>();

//Takes the values from the datasnapshot and places them in the list
  Gcreation.fromJson(this.key, Map data) {
    if(data!=null) {
      data.entries.forEach((e) {
        if(e!=null) {
          var vmap = Map.from(e.value);
          var kmap = e.key;
          matchGroups.add(Map.from(vmap));
          keyMap.add(kmap);
        }
      });
    }
    else{
      hasData=0;
    }
  }
}
class Users {
  final String key;
  var hasData=1;
  List<String> myUsers= List<String>();

//Takes the values from the datasnapshot and places them in the list
  Users.fromJson(this.key, Map data) {
    if(data!=null) {
      for(var value  in data.values) {
        myUsers.add(value["uid"]);
      }
        }
    else{
      hasData=0;
    }
  }
}
GoogleSignInAccount currentUser = googleSignIn.currentUser;
final FirebaseAuth _auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();
String TUID = currentUser.id;

void _saveData(Post post) async {
  final uid = TUID;
  final groupName=gPost.gid;
  var glist = await FirebaseGroups.getGroupMembers("$groupName");
  var duplicate=0;
  if(glist.hasData==1)
  {
    var ulist=glist.myUsers;
    for(var i=0;i<ulist.length;i++)
      {
        if(ulist[i]==uid)
          {
            duplicate=1;
          }

      }
  }
  if(duplicate==0) {
    databaseReference.child("groupData").child(gPost.gid).child("UIDS")
        .push()
        .set({
      "uid": uid
    }); //allows the same person to belong to the group multiple times
  }
}
class FirebaseGroups {

  /// FirebaseTodos.getTodo("-KriJ8Sg4lWIoNswKWc4").then(_updateTodo);
  /// This function queries the db once to retrieve group info
  static Future<Gcreation> getGroups(String todoKey) async {
    Completer<Gcreation> completer = new Completer<Gcreation>();

    ////String accountKey = await Preferences.getAccountKey();
    /*Important!!! The following lines are a single query and can be placed on one line */

    FirebaseDatabase.instance
        .reference()
        .child("groups")
        .orderByChild("Gname")
        .startAt(todoKey)
        .endAt(todoKey+"~")
        //.equalTo(todoKey)
        .once()
        .then((DataSnapshot snapshot) {
      var groups = new Gcreation.fromJson(snapshot.key, snapshot.value);
      completer.complete(groups);
    });

    return completer.future;
  }
  static Future<Users> getGroupMembers(String group) async {
    Completer<Users> completer = new Completer<Users>();

    ////String accountKey = await Preferences.getAccountKey();
    /*Important!!! The following lines are a single query and can be placed on one line */
    FirebaseDatabase.instance
        .reference()
        .child("groupData")
        .child(group)
        .child("UIDS")
        .once()
        .then((DataSnapshot snapshot) {
      var groups = new Users.fromJson(snapshot.key, snapshot.value);
      completer.complete(groups);
    });

    return completer.future;
  }
}

