import 'package:flutter/material.dart';

import '../home/home_screen.dart';

class CreateProfileScreen extends StatelessWidget {
  const CreateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Profile Screen"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 20),
        child: Column(
          children: [
            TextFormField(),
            SizedBox(height: 20,),
            TextFormField(),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false,);
            }, child: Text("Create Profile"))
          ],
        ),
      ),
    );
  }
}
