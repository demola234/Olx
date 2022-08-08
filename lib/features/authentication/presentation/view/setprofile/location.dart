import 'package:ecommerce/core/constants/colors.dart';
import 'package:ecommerce/core/utils/custom_buttons.dart';
import 'package:ecommerce/core/utils/custom_toasts.dart';
import 'package:ecommerce/core/utils/navigator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import '../../../../../core/constants/image_assets.dart';
import '../../../../../core/utils/config.dart';
import '../../provider/google_provider.dart';
import 'set_location.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({Key? key}) : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final location = loc.Location();
  String addressName = "";
  late bool _serviceEnabled;
  late loc.PermissionStatus _permissionGranted;
  loc.LocationData? _locationData;

  getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return null;
      }
    }
    _locationData = await location.getLocation();

    return _locationData;
  }

  getAddress(double? latitude, double? longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude!, longitude!);

    String address =
        "${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].country}";
    setState(() {
      addressName = address;
      if (kDebugMode) {
        print(addressName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    saveAddress(BuildContext context, String address, double latitude,
        double longitude) {
      Provider.of<GoogleAuthProviders>(context, listen: false)
          .saveAddress(address, latitude, longitude);
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const YMargin(100),
          Container(
            alignment: Alignment.center,
            width: 200,
            height: 66,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(ImagesAsset.olxLogo),
              ),
            ),
          ),
          const YMargin(10),
          Container(
            alignment: Alignment.center,
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(ImagesAsset.location),
              ),
            ),
          ),
          Text(
            "Let’s meet you",
            style: Config.h3(context).copyWith(),
            textAlign: TextAlign.center,
          ),
          const YMargin(10),
          Text(
            "Please enter your correct names for identification",
            style: Config.b3(context).copyWith(),
            textAlign: TextAlign.center,
          ),
          const YMargin(40),
          Center(
            child: OlxButton(
              color: OlxColor.olxPrimary,
              onTap: () async {
                getLocation().then((v) {
                  if (_locationData != null) {
                    getAddress(
                        _locationData!.latitude, _locationData!.longitude);
                    if (addressName.isNotEmpty &&
                        _locationData!.latitude != null &&
                        _locationData!.latitude != null) {
                      saveAddress(context, addressName,
                          _locationData!.latitude!, _locationData!.longitude!);
                    } else {
                      Toasts.showErrorToast("Unable to find location");
                    }
                  } else {
                    Toasts.showErrorToast("Unable to find location");
                  }
                });
              },
              text: "Current Locations",
            ),
          ),
          const YMargin(20),
          Center(
            child: OlxButton(
              color: Colors.white,
              isBorder: true,
              textColor: OlxColor.olxPrimary,
              onTap: () {
                getLocation().then((v) {
                  if (_locationData != null) {
                    NavigationService().navigateToScreen(SetLocation(
                      latitude: _locationData!.latitude!,
                      longitude: _locationData!.longitude!,
                    ));
                  }
                });
              },
              text: "Set your location manually",
            ),
          ),
        ],
      ),
    );
  }
}
