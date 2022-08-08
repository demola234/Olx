import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/utils/config.dart';
import '../../../../core/utils/custom_buttons.dart';
import '../../../../core/utils/custom_toasts.dart';
import '../../../authentication/presentation/view/setprofile/set_location.dart';
import '../provider/categories_provider.dart';
import '../provider/product_state.dart';
import 'add_product.dart';

class ReviewDetails extends StatefulWidget {
  const ReviewDetails({Key? key}) : super(key: key);

  @override
  State<ReviewDetails> createState() => _ReviewDetailsState();
}

class _ReviewDetailsState extends State<ReviewDetails> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CategoriesProvider>(context);
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: CustomAppBar(
          title: "Review Details",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>?>(
              stream: FirebaseFirestore.instance
                  .collection("user")
                  .where("uid",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  fullNameController.text =
                      snapshot.data!.docs[0]["fullName"] ?? "";
                  phoneController.text = snapshot.data!.docs[0]["phone"] ?? "";
                  emailController.text =
                      snapshot.data!.docs[0]["emailAddress"] ?? "";
                  addressController.text =
                      snapshot.data!.docs[0]["address"] ?? "";
                }
                return Column(
                  children: [
                    const YMargin(20),
                    Row(
                      children: [
                        Text(
                          "Contact Details",
                          style: Config.b1(context).copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                    const YMargin(10),
                    OlxDescTextField(
                      hintText: "Your Full Name",
                      productName: "Enter your Full Name",
                      controller: fullNameController,
                    ),
                    const YMargin(10),
                    OlxDescTextField(
                      hintText: "Your Mobile Number",
                      productName: "Enter Mobile Number",
                      controller: phoneController,
                    ),
                    const YMargin(10),
                    OlxDescTextField(
                      hintText: "Your Email",
                      productName: "Enter Email Address",
                      controller: emailController,
                    ),
                    const YMargin(10),
                    OlxDescTextField(
                      hintText: "Your Address",
                      productName: "Enter Your Address",
                      controller: addressController,
                    ),
                  ],
                );
              }),
        ),
      ),
      bottomNavigationBar: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(bottom: 40),
          child: OlxButton(
            color: OlxColor.olxPrimary,
            onTap: () => acceptedInputs(),
            text: state.productState != ProductState.loading
                ? "Review Details" : "Loading...",
          )),
    );
  }

  reviewedDetails(BuildContext context) {
    Provider.of<CategoriesProvider>(context, listen: false).updateDetails(
        fullNameController.text,
        phoneController.text,
        emailController.text,
        addressController.text);
  }

  acceptedInputs() async {
    try {
      var fullName = fullNameController.text;
      var phone = phoneController.text;
      var email = emailController.text;
      var address = addressController.text;

      if (fullName.trim().isEmpty) {
        Toasts.showErrorToast("Please Type in Full Name");
        return;
      } else if (phone.trim().isEmpty) {
        Toasts.showErrorToast("Please Type in Mobile");
        return;
      } else if (email.trim().isEmpty) {
        Toasts.showErrorToast("Please Type in your Email");
        return;
      } else if (address.trim().isEmpty) {
        Toasts.showErrorToast("Please Type in your Address");
        return;
      }
      reviewedDetails(context);
    } catch (e) {
      Toasts.showErrorToast("An Error Occurred Unable to Upload data");
    } finally {}
  }
}
