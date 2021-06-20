import 'package:flutter/material.dart';
import 'package:shop/config/color_config.dart';
import 'package:shop/config/size_config.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/about_screen';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(title: Text("About Developer")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: double.infinity,
                height: getProportionateScreenHeight(300),
                child: InteractiveViewer(
                  child: Image.asset('assets/images/developer.JPG',fit:BoxFit.fitWidth),
                ),
              ),
            ),
            buildContainer("Name", "Moatamed Wageh Nashat"),
            buildContainer("Contact via Email", "metmedelbana@gmail.com"),
            buildContainer("Contact via WhatsApp or Phone", "+201288584664"),
            buildContainer("Github", "moatamed8"),
            buildContainer("Experience",
                "1 year Flutter Developer \n 3 years Android Native"),
            buildContainer("About Application technology",
                "State Management using Provider \n Flutter For Design \n Dart for operation \n Responsive for all screens \n Firebase RestApis for backend"),
          ],
        ),
      ),
    );
  }
}

Widget buildContainer(String title, String cont) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            fontWeight: FontWeight.w600,
            color: kPrimaryColor,
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(5),
        ),
        Text(
          cont,
          textAlign: TextAlign.left,
        ),
      ],
    ),
  );
}
