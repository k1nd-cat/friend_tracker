import 'package:flutter/material.dart';
import 'package:geotracker/http/invite_accept.dart';

import '../http/friends_from_db.dart';
import '../utils/my_info.dart';
import '../utils/styles.dart';

class FriendFromServer {
  late String name;
  late String login;

  FriendFromServer(this.name, this.login);
  FriendFromServer.params({name, login, coordinates});
}

class FriendsCollection {
  Future<FriendsResponse> getFriends(bool accepted) {
    return accepted ? getAcceptedFriends() : getWaitingFriends();
  }

  Widget friend2Widget(State parent, Friend friend, bool accepted) {
    return accepted ? acceptedFriend2Widget(parent, friend) : waitingFriend2Widget(parent, friend);
  }

  Future<FriendsResponse> getAcceptedFriends() async {
    var friends = await FriendsRestApi().accepted(MyInfo.token);
    return friends;
  }

  Future<FriendsResponse> getWaitingFriends() async {
    var friends = await FriendsRestApi().waiting(MyInfo.token);
    return friends;
  }

  void acceptFriend(State parent, Friend friend) async {
    var accept = await InviteAcceptRestApi().accept(MyInfo.token, friend.login);
    if (accept.error == null) {
      parent.setState(() {
        redraw: true;
      });
    }
  }

  Widget acceptedFriend2Widget(State parent, Friend friend) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 25, right: 25),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.deepPurple.shade400,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: SizedBox(
          width: 100,
          height: 68,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 1),
                child: Text(friend.name,
                  style: Style().textFormFieldTextStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22, top: 1, bottom: 3),
                child: Text(friend.login,
                  style: TextStyle(fontSize: 15, color: Colors.deepPurple.shade400),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget waitingFriend2Widget(State parent, Friend friend) {
    return Padding (
      padding: const EdgeInsets.only(top: 8.0, left: 25, right: 25),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.deepPurple.shade400,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: SizedBox(
        width: 100,
        height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SizedBox(
                  width: 271.4,
                  child: Text(friend.name,
                    style: Style().textFormFieldTextStyle(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    // softWrap: false,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: IconButton(
                  onPressed: () => acceptFriend(parent, friend),
                  icon: Icon (
                      Icons.check_circle,
                      color: Colors.deepPurple.shade200,
                      size: 34.0
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loadFriends(State parent, bool accepted) {
    return FutureBuilder(
      future: getFriends(accepted),
      builder: (context, snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          if (snapshot.data!.friends!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.friends?.length,
              itemBuilder: (context, index) {
                Friend friend = snapshot.data!.friends![index];
                return friend2Widget(parent, friend, accepted);
              },
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(left: 25, top: 20, right: 25),
              child: SizedBox(
                width: 400,
                child: Text(
                  "There's no one here yet",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 38,
                    color: Colors.deepPurple.shade400,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          children = Style().loadingPage('Error: ${snapshot.error}');
        }
        else {
          children = Style().errorPage('Awaiting result...');
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }
}