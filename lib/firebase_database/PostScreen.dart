


import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_concepts/firebase_database/AddPostScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
final auth =FirebaseAuth.instance;
final ref =FirebaseDatabase.instance.ref("Post");
final serarchfilter =TextEditingController();
final editcontroller =TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(" Post",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 29),),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Addpostscreen()));

        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [SizedBox(
          height: 10,
        ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(

              controller: serarchfilter,
              decoration: InputDecoration(
                
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
              onChanged: (String value){
                setState(() {

                });
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                defaultChild: Text('Loading'),
                itemBuilder: (context, snapshot, animation, index){
                  final title =snapshot.child('title').value.toString();
                  if(serarchfilter.text.isEmpty){
                    return   ListTile(
                      title: Text(snapshot.child('title').value.toString(),style: TextStyle(fontWeight: FontWeight.bold),),

                      trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context)=>[
                       PopupMenuItem(child: ListTile(
                         onTap:(){
                           Navigator.pop(context);
                           showMyDialog(title,snapshot.child('id').value.toString());

                         },
                         leading: Icon(Icons.edit),
                         title: Text("Edit"),
                       )),
                          PopupMenuItem(child: ListTile(

                            onTap:(){
                              Navigator.pop(context);
                              ref.child(snapshot.child('id').value.toString()).remove();
                              ScaffoldMessenger.of(context).showSnackBar((

                                  SnackBar(
                                      backgroundColor: Colors.redAccent,
                                      content:Text("Deleted",style: TextStyle(fontSize: 20),
                                      ) )));
                            },
                            leading: Icon(Icons.delete),
                            title: Text("Delete")
                          ))
                        ],
                      )

                    );
                  }else if(title.toLowerCase().contains(serarchfilter.text.toLowerCase())){
                 return   ListTile(
                      title: Text(snapshot.child('title').value.toString(),style: TextStyle(fontWeight: FontWeight.bold),),

                    );
                  }else{
                    return Container();
                  }
                }
            ),
          ),
          // Expanded(child: StreamBuilder(
          //   stream: ref.onValue,
          //   builder: (context,AsyncSnapshot<DatabaseEvent>snapshot){
          //
          //     if(!snapshot.hasData){
          //       return CircularProgressIndicator();
          //     }else{
          //       Map<dynamic,dynamic> map =snapshot.data!.snapshot.value as dynamic;
          //       List<dynamic> list =[];
          //       list.clear();
          //       list=map.values.toList();
          //       return ListView.builder(
          //           itemCount: snapshot.data!.snapshot.children.length,
          //           itemBuilder: (context,index){
          //
          //             return  ListTile(
          //               title: Text(list[index]['title']),
          //
          //             );
          //           });
          //     }
          //   },
          // )),


        ],
      ),
    );
  }
Future<void> showMyDialog(String title,String id){
    editcontroller.text =title;
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Text(
          'Update'
      ),
      content: Container(
        child: TextField(
          controller: editcontroller,
          decoration: InputDecoration(
            hintText: "Edit"
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Cancel")),
        TextButton(onPressed: (){
          setState(() {

          });
          Navigator.pop(context);
          ref.child(id).update({
            'title':editcontroller.text

          });
        }, child: Text("Update"))
      ],
    );
  });
}

}
