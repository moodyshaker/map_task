import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:map_task/core/model/markers.dart';
import 'package:map_task/core/model/user.dart';
import 'package:map_task/widgets/action_dialog.dart';
import 'package:permission_handler/permission_handler.dart' as p;
import 'package:provider/provider.dart';
import '../../feature/home.dart';
import '../../feature/login.dart';
import '../../widgets/loading_dialog.dart';
import '../appStorage/shared_preference.dart';
import '../httpHelper/http_helper.dart';
import '../networkStatus/network_status.dart';
import '../router/router.dart';

class AuthProvider extends ChangeNotifier {
  static AuthProvider get(context) => Provider.of<AuthProvider>(context);

  static AuthProvider listenFalse(context) =>
      Provider.of<AuthProvider>(context, listen: false);

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  Preferences _preferences = Preferences.instance;
  Location? _location;
  PermissionStatus? _permissionGranted;
  bool? _serviceEnabled;
  LocationData? _locationData;
  NetworkStatus? _locationStatus;
  Set<Polyline> locationPolylines = {};
  CameraPosition? cameraPosition;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Timer? _t;

  Future<void> login() async {
    showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (ctx) => LoadingDialog());
    var request = MultipartRequest(
      'POST',
      Uri.parse('$base_url/LoginUser.php'),
    );
    Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      'Accept-Language': 'ar',
      'Accept': 'application/json',
    };
    request.fields['UserPhone'] = '+2${loginEmailController.text}';
    request.fields['Password'] = loginPasswordController.text;
    request.fields['UserFirebaseToken'] = _preferences.getFcmToken;
    request.headers.addAll(headers);
    var res = await request.send();
    Response r = await Response.fromStream(res);
    log('login statusCode -> ${r.statusCode}');
    log('login response -> ${r.body}');
    log('login response -> ${r.request!.url}');
    if (json.decode(r.body)['status_code'] >= 200 &&
        json.decode(r.body)['status_code'] <= 300) {
      UserModel user = UserModel.fromJson(json.decode(r.body));

      MagicRouter.pop();
      Future.wait([
        _preferences.setUserId(user.data!.usersID.toString()),
        _preferences.setUserToken(user.data!.userToken.toString()),
        _preferences.setUserName(user.data!.userName.toString()),
        _preferences.setUserPhone(user.data!.userPhone.toString())
      ]);
      MagicRouter.navigateTo(Home());
    } else {
      MagicRouter.pop();
      showDialog(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (ctx) =>
              ActionDialog(
                content: json.decode(r.body)['message'],
                approveAction: 'Okay',
                onApproveClick: MagicRouter.pop,
              ));
    }
  }

  Future<bool> locationServiceEnabled() async {
    _serviceEnabled = await _location!.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await _location!.requestService();
      if (!_serviceEnabled!) {
        return false;
      }
    }
    return true;
  }

  Set<Marker> markers = {};

  Future<bool> locationPermissionGranted(
      {required BuildContext context}) async {
    _permissionGranted = await _location!.hasPermission();
    if (_permissionGranted == PermissionStatus.deniedForever) {
      await p.openAppSettings();
    } else if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location?.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<void> getMarkers() async {
    markers.clear();
    locationPolylines.clear();
    try {
      _locationStatus = NetworkStatus.loading;
      final r = await HttpHelper.instance.httpGet('/getMarkers.php', true);
      log('body -> ${json.decode(r.body)}');
      log('statusCode -> ${r.statusCode}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        await getUserLocation();
        MarkersModel m = MarkersModel.fromJson(json.decode(r.body));
        m.data!.forEach((e) =>
            markers.add(Marker(
                markerId: MarkerId(e.taskID!),
                position: LatLng(
                    num.parse(e.lat!).toDouble(),
                    num.parse(e.longt!).toDouble()),
                infoWindow: InfoWindow(title: e.name),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueCyan))));
        locationPolylines.add(Polyline(
            polylineId: PolylineId('polyline overview'),
            color: Colors.redAccent,
            width: 6,
            jointType: JointType.round,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            geodesic: true,
            points: m.data!
                .map((e) =>
                LatLng(num.parse(e.lat!).toDouble(),
                    num.parse(e.longt!).toDouble()))
                .map((e) => LatLng(e.latitude, e.longitude))
                .toList()));
        cameraPosition = CameraPosition(
            target: LatLng(num.parse(m.data![0].lat!).toDouble(),
                num.parse(m.data![0].longt!).toDouble()),
            zoom: 10.0);
        _t = Timer.periodic(const Duration(seconds: 2), (Timer t) {
          getUserLocation();
        });
        _locationStatus = NetworkStatus.success;
      } else {
        _locationStatus = NetworkStatus.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  void drawMarkers(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    snapshot.data!.docs.forEach((e) {
      if (e.data()['online'] == '1') {
        markers.add(
          Marker(
            markerId: MarkerId(e.data()['userPhone']),
            position:
            LatLng(
              e.data()['lat'],
              e.data()['lang'],
            ),
            infoWindow: InfoWindow(title: e.data()['userName']),
          ),
        );
      }
      log('${markers.length}');
    });
  }

  FirebaseFirestore get firebaseFirestore => _firebaseFirestore;

  Future<void> logout() async {
    if (_t!.isActive) {
      _t!.cancel();
    }
    markers.removeWhere((e) => e.markerId.value == _preferences.getUserPhone);
    await _firebaseFirestore
        .collection('Locations')
        .doc('${_preferences.getUserToken}')
        .update({
      'userName': _preferences.getUserName,
      'userId': _preferences.getUserId,
      'userPhone': _preferences.getUserPhone,
      'userToken': _preferences.getUserToken,
      'online': '0',
      'lat': _locationData?.latitude,
      'lang': _locationData?.longitude,
    });
    await Preferences.instance.logout();
    MagicRouter.navigateAndPopAll(Login());
  }

  Future<void> getUserLocation() async {
    _location = Location();
    if (await locationServiceEnabled() &&
        await locationPermissionGranted(
            context: navigatorKey.currentContext!)) {
      _location?.changeSettings(
          accuracy: LocationAccuracy.navigation, interval: 3000);
      _locationData = await _location?.getLocation();
      log('${_locationData?.longitude}');
      log('${_locationData?.latitude}');
      if (_locationData != null) {
        _firebaseFirestore
            .collection('Locations')
            .doc('${_preferences.getUserToken}')
            .update({
          'userName': _preferences.getUserName,
          'userId': _preferences.getUserId,
          'userPhone': _preferences.getUserPhone,
          'userToken': _preferences.getUserToken,
          'online': _preferences.getUserToken.isEmpty ? '0' : '1',
          'lat': _locationData?.latitude,
          'lang': _locationData?.longitude,
        });
        // markers
        //     .removeWhere((e) => e.markerId.value == _preferences.getUserPhone);

        notifyListeners();
      }
    }
  }

  NetworkStatus? get locationStatus => _locationStatus;

  LocationData? get locationData => _locationData;
}
