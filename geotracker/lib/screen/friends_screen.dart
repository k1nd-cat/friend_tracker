import 'package:flutter/material.dart';
import 'package:geotracker/logic/invite_friend_logic.dart';
import 'package:geotracker/logic/friends_mapping_logic.dart';

import '../utils/styles.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _FriendScreenState();
}

class _FriendScreenState extends State with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends", style: Style().titleTextStyle()),
        bottom: TabBar(
          tabs: const [
            Tab(
              text: "waiting",
            ),
            Tab(
              text: "friends",
            ),
            Tab(
              text: "invite",
            ),
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView (
        controller: _tabController,
        children: [
          FriendsCollection().loadFriends(this, false),
          FriendsCollection().loadFriends(this, true),
          InviteFriend().inviteFriendView(context),
        ],
      ),
    );
  }
}