import 'dart:io';
import 'dart:typed_data';
import 'package:ecommerce/core/constants/colors.dart';
import 'package:ecommerce/core/utils/config.dart';
import 'package:ecommerce/core/utils/custom_toasts.dart';
import 'package:ecommerce/core/utils/pick_image.dart';
import 'package:ecommerce/data/remote/storage_method/storage_methods.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/image_assets.dart';
import '../../../../../core/utils/custom_buttons.dart';
import '../../../../../core/utils/custom_textfield.dart';
import '../../../../../core/utils/navigator.dart';
import 'location.dart';
import '../../provider/auth_provider.dart';
import '../../provider/google_provider.dart';

class SetProfile extends StatefulWidget {
  final bool isPhone;
  const SetProfile({required this.isPhone, Key? key}) : super(key: key);

  @override
  State<SetProfile> createState() => _SetProfileState();
}

class _SetProfileState extends State<SetProfile> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  StorageMethods storageMethods = StorageMethods();
  List<File> image = [];
  void selectImage() async {
    List<Media>? res = await ImagesPicker.pick(
      cropOpt: CropOption(
        aspectRatio: CropAspectRatio.custom,
        cropType: CropType.rect,

      ),
      count: 1,
      
      pickType: PickType.image,
    );

    if (res != null) {
      setState(() {
        image.addAll(res.map((e) => File(e.path)));
        print(image.first.path);
      });
    } else if (res == null) {
      Toasts.showErrorToast("No Image Selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    saveDetailsfromGoogle(BuildContext context) {
      Provider.of<GoogleAuthProviders>(context, listen: false).saveDetails(
          fullNameController.text, image.first, phoneController.text);
    }

    saveDetailsfromPhone(BuildContext context) {
      Provider.of<AuthProvider>(context, listen: false).saveDetails(
          fullNameController.text, emailController.text, image.first);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Set Profile",
            style: Config.b1(context).copyWith(color: const Color(0XFF5C5C5C))),
        elevation: 0,
        backgroundColor: const Color(0xFFF4F4F4),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const YMargin(50),
              image.isEmpty
                  ? GestureDetector(
                      onTap: selectImage,
                      child: Container(
                        alignment: Alignment.center,
                        width: 118,
                        height: 118,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          // border: Border.all(style: BorderStyle.values),
                        ),
                        child: Image(
                            fit: BoxFit.contain,
                            image: AssetImage(ImagesAsset.defaultImage)),
                      ),
                    )
                  : CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(image[0].path),
                    ),
              const YMargin(20),
              InkWell(
                onTap: selectImage,
                child: Text("Upload Profile Photo",
                    style: Config.b2(context).copyWith(
                      color: OlxColor.olxPrimary,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const YMargin(40),
              Text("Personal Info",
                  style: Config.h2(context).copyWith(
                    color: OlxColor.olxPrimary,
                    fontWeight: FontWeight.bold,
                  )),
              Text("Please fill this field correctly",
                  style: Config.b3(context).copyWith(
                    color: OlxColor.olxSecondary,
                    // fontWeight: FontWeight.bold,
                  )),
              const YMargin(40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    OlxTextFormField(
                      hintText: "Full Name",
                      controller: fullNameController,
                    ),
                    const YMargin(10),
                    widget.isPhone
                        ? OlxTextFormField(
                            hintText: "Email",
                            controller: emailController,
                          )
                        : OlxTextFormField(
                            hintText: "Phone",
                            controller: phoneController,
                          )
                  ],
                ),
              ),
              const YMargin(40),
              Center(
                child: OlxButton(
                  color: OlxColor.olxPrimary,
                  onTap: () {
                    if (!widget.isPhone) {
                      if (image != null &&
                          fullNameController.text.isNotEmpty &&
                          phoneController.text.isNotEmpty) {
                        saveDetailsfromGoogle(context);
                        NavigationService()
                            .replaceScreen(const LocationPicker());
                        Toasts.showSuccessToast("Details Uploaded");
                      } else {
                        Toasts.showErrorToast(
                            "Please Upload a Profile Picture or Enter Full Name");
                      }
                    } else {
                      if (image != null &&
                          fullNameController.text.isNotEmpty &&
                          emailController.text.isNotEmpty) {
                        saveDetailsfromPhone(context);
                        NavigationService()
                            .replaceScreen(const LocationPicker());
                        Toasts.showSuccessToast("Details Uploaded");
                      } else {
                        Toasts.showErrorToast(
                            "Please Upload a Profile Picture or Enter Full Name and Email");
                      }
                    }
                  },
                  text: "Continue",
                ),
              ),
              const YMargin(100),
            ],
          ),
        ),
      ),
    );
  }
}
