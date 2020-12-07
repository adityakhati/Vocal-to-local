import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttershare/models/post.dart';
import 'package:fluttershare/pages/activity_feed.dart';
import 'package:fluttershare/widgets/post_tile.dart';
import 'package:fluttershare/widgets/post_widget.dart';
import '../models/user.dart';

import '../widgets/progress.dart';
import 'home.dart';

import '../models/post.dart';
import '../widgets/post_tile.dart';
import '../widgets/post_widget.dart';


class Search extends StatefulWidget {
  final String profileId;

  Search({this.profileId});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  @override
  void initState() {
    super.initState();
//    print('Profile ID: ${widget.profileId}');
    getProfilePosts();
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });

    QuerySnapshot querySnapshot = await Firestore.instance.collection("users").getDocuments();
//    var list = querySnapshot.documents;
//    print("list=");
    print(querySnapshot.documents.length);
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];

      if(widget.profileId != a.documentID){
      QuerySnapshot snapshot = await postsRef
          .document(a.documentID)
          .collection('userPosts')
          .orderBy('timestamp', descending: true)
          .getDocuments();

        postCount = postCount + snapshot.documents.length;
        posts.addAll(snapshot.documents.map((doc) => Post.fromDocument(doc)).toList());
}
    }
    print('postcount='+postCount.toString());


//    QuerySnapshot snapshot = await postsRef
//        .document("101804107527351220986")
//        .collection('userPosts')
//        .orderBy('timestamp', descending: true)
//        .getDocuments();
    setState(() {
      isLoading = false;
      postCount = postCount;
      posts = posts;
    });
//    setState(() {
//      isLoading = false;
//      postCount = snapshot.documents.length;
//      posts = snapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
//    });
  }

  final String currentUserId = currentUser?.id;
  bool isLoading = false;
  int postCount = 0;
  List<Post> posts = [];
  String postOrientation = "grid";
  bool isFollowing = false;
  int followerCount = 0;
  int followingCount = 0;


  buildProfilePosts() {
    if (isLoading) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return Container(
        padding: EdgeInsets.only(top: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //SvgPicture.asset('assets/images/no_content.svg', height: 260),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'No Posts yet',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      );
    } else if (postOrientation == 'grid') {
      List<GridTile> gridTiles = [];
      posts.forEach((post) {
        gridTiles.add(GridTile(child: PostTile(post)));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTiles,
      );
    } else if (postOrientation == 'list') {
      List<PostWidget> postsW = [];
      posts.forEach((post) {
        postsW.add(PostWidget(post));
      });

      return Column(children: postsW);
    }
  }

  buildTogglePostOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () => setPostOrientation('grid'),
          icon: Icon(Icons.grid_on),
          color: postOrientation == 'grid'
              ? Colors.black
              : Colors.grey,
        ),
        IconButton(
          onPressed: () => setPostOrientation('list'),
          icon: Icon(Icons.list),
          color: postOrientation == 'list'
              ? Colors.black
              : Colors.grey,
        )
      ],
    );
  }

  setPostOrientation(String postOrientation) {
    setState(() {
      this.postOrientation = postOrientation;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: header(context, titleText: 'Profile'),
      body: ListView(
        children: <Widget>[
//          buildProfileHeader(),
          Divider(),
          buildTogglePostOrientation(),
          Divider(
            height: 0.0,
          ),
          buildProfilePosts(),
        ],
      ),
    );
  }
}






//class _SearchState extends State<Search>
//    with AutomaticKeepAliveClientMixin<Search> {
//  TextEditingController searchController = TextEditingController();
//  Future<QuerySnapshot> searchResultsFuture;
//
//
//
//
//
//  handleSearch(String query) {
//    Future<QuerySnapshot> users = usersRef
//        .where('displayName', isGreaterThanOrEqualTo: query)
//        .getDocuments();
//    setState(() {
//      searchResultsFuture = users;
//    });
//  }
//
//  clearSearch() {
//    searchController.clear();
//  }
//
//  AppBar buildSearchField() {
//    return AppBar(
//      backgroundColor: Colors.white,
//      title: TextFormField(
//        controller: searchController,
//        decoration: InputDecoration(
//          hintText: 'Search for a user...',
//          filled: true,
//          prefixIcon: Icon(Icons.account_box, size: 28.0),
//          suffixIcon: IconButton(
//            icon: Icon(Icons.clear),
//            onPressed: clearSearch,
//          ),
//        ),
//        onFieldSubmitted: handleSearch,
//      ),
//    );
//  }
//
//  Container buildNoContent() {
//    final Orientation orientation = MediaQuery.of(context).orientation;
//    return Container(
//      child: Center(
//        child: ListView(
//          shrinkWrap: true,
//          children: <Widget>[
////            SvgPicture.asset('assets/images/search.svg',
////                height: orientation == Orientation.portrait ? 300.0 : 200.0),
//            Text(
//              'Find Users',
//              textAlign: TextAlign.center,
//              style: TextStyle(
//                  color: Colors.blue,
//                  fontStyle: FontStyle.italic,
//                  fontWeight: FontWeight.w600,
//                  fontSize: 60.0),
//            )
//          ],
//        ),
//      ),
//    );
//  }
//
//  buildSearchResults() {
//    return FutureBuilder(
//        future: searchResultsFuture,
//        builder: (context, snapshot) {
//          if (!snapshot.hasData) {
//            return circularProgress();
//          }
//          List<UserResult> searchResults = [];
//          snapshot.data.documents.forEach((doc) {
//            User user = User.fromDocument(doc);
//            UserResult searchResult = UserResult(user);
//            searchResults.add(searchResult);
//          });
//          return ListView(
//            children: searchResults,
//          );
//        });
//  }
//
//  get wantKeepAlive => true;
//  @override
//  Widget build(BuildContext context) {
//    super.build(context);
//    return Scaffold(
//      backgroundColor: Theme.of(context).primaryColorLight.withOpacity(0),
//      appBar: buildSearchField(),
//      body:
//          searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
//    );
//  }
//}

class UserResult extends StatelessWidget {
  final User user;
  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => showProfile(context, profileId: user.id),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                backgroundColor: Colors.grey,
              ),
              title: Text(
                user.displayName,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.username,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}
