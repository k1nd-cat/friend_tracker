import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:geotracker/http/coords.dart';
import 'package:geotracker/screen/profile_screen.dart';
import 'package:geotracker/utils/my_info.dart';
import '../utils/my_location.dart';
import '../utils/point_package.dart';
import '../utils/styles.dart';
import 'friends_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _mapController;
  PointPackage? _myPoint;
  List<PointPackage> _mapPoints = [];

  List<Marker> _getMarkers() {
    return List.generate(_mapPoints.length,
            (index) => mapPoint2Marker(_mapPoints[index], index),
    );
  }

  Marker mapPoint2Marker(PointPackage mapPoint, int index) {
    var color = Colors.purple;
    var name = mapPoint.name;
    if (name == MyInfo.name) {
      color = Colors.indigo;
      name = "My location";
    }
    return Marker(
      height: 90,
      width: 80,
      point: mapPoint.point!,
      builder: (ctx) => Column(
        children: <Widget>[
          Center(
            child: SizedBox(
              width: 80,
              child: Text(name,
                style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),

          ),
          Icon(
            Icons.location_on_rounded,
            color: color,
            size: 50.0,
          ),
        ],
      ),
    );
  }

  void getLocations(int value) async {
    //TODO: logic
    var log = Logger();
    log.d("button: $value");
    _myPoint = PointPackage(await LocationService().determinePosition(), MyInfo.name!);
    await CoordsRestApi().sendCoords(MyInfo.token, _myPoint!.point!);
    FriendsCoordsResponse response = await CoordsRestApi().getCoords(MyInfo.token);
    List<PointPackage> friendCoords;
    if (response.friends == null) {
      friendCoords = [];
    } else {
      friendCoords = response.friends!.map((friend) => PointPackage(LatLng(friend.lat!, friend.lng!), friend.userName!)).toList();
    }
    List<PointPackage> positions = List.empty(growable: true);
    positions.add(_myPoint!);
    positions.addAll(friendCoords);
    _mapController.move(_myPoint!.point!, 14.5);
    setState(() {
      _mapPoints = positions;
    });
  }

  @override
  void initState() {
    _mapController = MapController();
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: const Color(0x00000000),
        elevation: 0,
        title: Text('Geotracker',
          style: Style().titleTextStyle(),
        ),
        toolbarHeight: 80,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
              icon: Icon (
                Icons.person,
                color: Colors.deepPurple.shade600,
                size: 34.0
              ),
            ),
          ),
        ],
      ),
      body:
      FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _myPoint?.point ?? LatLng(59.941, 30.312),
          zoom: 14.5,
          maxZoom: 18,
          minZoom: 1.8,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.flutter_map_example',
          ),
          MarkerLayer(
            markers: _getMarkers(),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(),
        child: SizedBox(
          height: 130,
          child: BottomNavigationBar(
            iconSize: 36,
            selectedFontSize: 12,
            backgroundColor: const Color(0x00000000),
            elevation: 20,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.group,),
                label: 'Friends',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.my_location,),
                label: 'Locations',
              ),
            ],
            currentIndex: 0,
            selectedItemColor: Colors.deepPurple.shade600,
            unselectedItemColor: Colors.deepPurple.shade600,
            onTap: (value) {
              if (value == 0) Navigator.push(context, MaterialPageRoute(builder: (context) => const FriendScreen()));
              if (value == 1) {
                // TODO: find myself on map
                getLocations(2);
              }
            },
          ),
        ),
      ),
    );
  }
}