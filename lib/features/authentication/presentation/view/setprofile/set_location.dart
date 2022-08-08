import 'package:csc_picker/csc_picker.dart';
import 'package:ecommerce/core/constants/colors.dart';
import 'package:ecommerce/core/utils/config.dart';
import 'package:ecommerce/core/utils/custom_toasts.dart';
import 'package:ecommerce/core/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/image_assets.dart';
import '../../../../../core/utils/custom_buttons.dart';
import '../../provider/google_provider.dart';

class SetLocation extends StatefulWidget {
  final double latitude;
  final double longitude;
   const SetLocation({
    required this.latitude,
    required this.longitude,
    Key? key}) : super(key: key);

  @override
  State<SetLocation> createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {
  /// Variables to store country state city data in onChanged method.
  String countryValue = "";
  String? stateValue = "";
  String? localValue = "";
  String address = "";

  @override
  Widget build(BuildContext context) {
    saveAddress(BuildContext context) {
      Provider.of<GoogleAuthProviders>(context, listen: false).saveAddress(
        address, widget.latitude, widget.longitude
      );
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: CustomAppBar(
          title: "Set Location",
        ),
      ),
      body: Column(
        children: [
          const YMargin(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: CSCPicker(
              showStates: true,
              showCities: true,
              flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
              defaultCountry: DefaultCountry.Nigeria,
              layout: Layout.vertical,
              dropdownDecoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1)),
              disabledDropdownDecoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey.shade300,
                  border: Border.all(color: Colors.grey.shade300, width: 1)),
              countrySearchPlaceholder: "Country",
              stateSearchPlaceholder: "State",
              citySearchPlaceholder: "Local Government",
              countryDropdownLabel: "*Country",
              stateDropdownLabel: "*State",
              cityDropdownLabel: "*Local Government",
              selectedItemStyle: const TextStyle(
                color: Colors.black,
                height: 2,
                fontSize: 14,
              ),
              dropdownHeadingStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
              dropdownItemStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              dropdownDialogRadius: 10.0,
              searchBarRadius: 10.0,
              onCountryChanged: (value) {
                setState(() {
                  countryValue = value;
                });
              },
              onStateChanged: (value) {
                setState(() {
                  stateValue = value;
                });
              },
              onCityChanged: (value) {
                setState(() {
                  localValue = value;
                  address = "$localValue, $stateValue, ${countryValue.trim()}";
                  // print(address);
                });
              },
            ),
          ),
          const YMargin(40),
          OlxButton(
            color: OlxColor.olxPrimary,
            onTap: () {
              if (localValue != null) {
                saveAddress(context);
              } else {
                Toasts.showErrorToast("Make sure all fields are filled");
              }
            },
            text: "Continue",
          )
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool? back;
  const CustomAppBar({
    required this.title,
    this.back = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: back!
          ? IconButton(
              onPressed: () {
                NavigationService().goBack();
              },
              icon: SvgPicture.asset(ImagesAsset.back),
            )
          : null,
      title: Text(title,
          style: Config.b1(context).copyWith(color: const Color(0XFF5C5C5C))),
      elevation: 0,
      backgroundColor: const Color(0xFFF4F4F4),
    );
  }
}
