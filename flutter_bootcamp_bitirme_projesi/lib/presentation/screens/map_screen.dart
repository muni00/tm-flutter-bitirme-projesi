import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/color/color_constant.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/screens/anasayfa_drawer_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

var colorConstant = ColorConstants.instance;

class _MapScreenState extends State<MapScreen> {
  double enlem = 0.0;
  double boylam = 0.0;

  Future<CameraPosition> konumBilgisiAl() async {
    var konum = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      enlem = konum.latitude;
      boylam = konum.longitude;
    });
    return CameraPosition(target: LatLng(enlem, boylam), zoom: 8);
  } // anlık konum alıyorum

  Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(40.01499522757156, 32.89164114745199),
    zoom: 5,
  ); //başlangıç zoom konumu , ilerleyen zamanda kullanici konumuna zoomlayacak

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  List<LatLng> latLen = [
    LatLng(40.91766975514268, 38.37588117588548), // Giresun
    LatLng(41.13726294208067, 29.132405627057704), // İstanbul
    LatLng(40.01499522757156, 32.89164114745199), // Ankara
    LatLng(41.28135319823345, 36.34908246430332), // Samsun
    LatLng(40.89345548709529, 38.80822591947664), // Güce
    LatLng(37.96573925817101, 32.59049846484667), // Konya
  ]; // Şube konum listesi

  @override
  void initState() {
    super.initState();
    konumBilgisiAl();
    for (int i = 0; i < latLen.length; i++) {
      _markers.add(Marker(
        markerId: MarkerId(i.toString()),
        position: latLen[i],
        infoWindow: const InfoWindow(
          title: 'Yemek Sipariş Noktası',
          snippet: 'Şubemizdir',
        ),
        icon: BitmapDescriptor.defaultMarker,
      )); //marker ekleme
      setState(() {});
      _polyline.add(Polyline(
        polylineId: PolylineId('1'),
        points: latLen,
        color: colorConstant.ortaAcikTuruncu,
        width: 5,
      ));
    }
  } //poly line olarak konumları oluşturuyoruz

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(colorConstant),
      body: Container(
        child: SafeArea(
          child: GoogleMap(
            initialCameraPosition: _kGoogle, //başlangıç konumu veriyoruz
            mapType: MapType.normal,
            markers: _markers, // markerlar veriliyor
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: true,
            polylines: _polyline, // poly line listesi veriliyor
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            }, // displayed google map
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(ColorConstants colorConstant) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: Text(
        "Şubelerimiz",
        style: TextStyle(color: colorConstant.koyuTuruncu),
      ),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AnasayfaDrawerScreen())); //ZoomDrawer.of(context)!.toggle();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: colorConstant.koyuTuruncu,
              size: 30,
            )),
      ),
    );
  }
}
