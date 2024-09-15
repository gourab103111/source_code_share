import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(alignment: AlignmentDirectional.center, children: [
        // const Image(
        //   image: AssetImage('assets/images/welcome.jpg'),
        //   fit: BoxFit.cover,
        //   height: double.infinity,
        //   width: double.infinity,
        //   alignment: Alignment.center,
        // ),
        Positioned(
          bottom: 20,
          child: Column(
            children: [
              Image(
                image: AssetImage('assets/images/logo_white.png'),
                fit: BoxFit.cover,
                height: 50,
                width: 50,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
