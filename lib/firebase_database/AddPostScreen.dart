import 'package:firebase_concepts/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Addpostscreen extends StatefulWidget {
  const Addpostscreen({super.key});

  @override
  State<Addpostscreen> createState() => _AddpostscreenState();
}

class _AddpostscreenState extends State<Addpostscreen> {
  final databaseRef=  FirebaseDatabase.instance.ref("Post");
  final postController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Add Post"),
      ),
body: Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Column(
    children: [
      SizedBox(
        height: 30,
      ),

      TextFormField(
        maxLines: 4,
        controller: postController,

        decoration: InputDecoration(

          hintText: "Whats in your mind?",
          border: OutlineInputBorder(

          )
        ),
      ),
      SizedBox(
        height: 30,
      ),

      RoundButton(title: "Add", onTap: (){
        String id =DateTime.now().millisecondsSinceEpoch.toString();
        databaseRef.child(id).set({
          "id":id,
          'title':postController.text.toString(),
        }).then((value){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text("Post added",style: TextStyle(fontSize: 18),)));
        });
      })
    ],
  ),
),
    );
  }

}
