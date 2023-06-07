import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_task/constants.dart';
import 'package:map_task/core/provider/auth_provider.dart';
import 'package:map_task/widgets/customScaffold.dart';

import '../core/networkStatus/network_status.dart';
import '../core/router/router.dart';
import 'login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late GoogleMapController _googleMapController;
  final key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    AuthProvider.listenFalse(context).getMarkers();
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.get(context);
    return CustomScaffold(
      home: true,
      backgroundColor: kWhiteColor,
      body: StreamBuilder(
          stream: auth.firebaseFirestore.collection('Locations').snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            auth.drawMarkers(snapshot);
            return (auth.locationStatus == NetworkStatus.loading ||
                    snapshot.connectionState == ConnectionState.none)
                ? const Center(
                    child: SpinKitDoubleBounce(
                    color: kPrimaryColor,
                  ))
                : GoogleMap(
                    zoomControlsEnabled: false,
                    mapType: MapType.normal,
                    mapToolbarEnabled: false,
                    polylines: auth.locationPolylines,
                    compassEnabled: false,
                    buildingsEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: false,
                    markers: auth.markers,
                    initialCameraPosition: auth.cameraPosition!,
                    onMapCreated: (GoogleMapController controller) async {
                      _googleMapController = controller;
                    },
                  );
          }),
    );
  }
}
