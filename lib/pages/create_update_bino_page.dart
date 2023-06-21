import 'package:binomage/enumerations/collections.enum.dart';
import 'package:binomage/pages/add_image_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CreateUpdateBinoPage extends StatefulWidget {
  const CreateUpdateBinoPage({super.key});

  @override
  _CreateUpdateBinoPageSate createState() => _CreateUpdateBinoPageSate();
}

class _CreateUpdateBinoPageSate extends State<CreateUpdateBinoPage> {

  final TextEditingController _controllerEmail = TextEditingController();

  Widget _entryField(
      String title,
      TextEditingController controller,
      ) {
    return const SizedBox(
      width: 250,
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AJOUTER OU MODIFIER UN BINOMAGE")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AddImagePage()));
        },
        child:  const Icon(Icons.add),

      ),
      body: Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child:
              Column(
                children: <Widget> [
                  _entryField('email', _controllerEmail),
                  Container(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection(Collections.parrainImageURls.name).snapshots(),
                      builder: (context, snapshot) {
                        return !snapshot.hasData
                            ? const Center( child: CircularProgressIndicator())
                            : Container(
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data?.docs.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: const EdgeInsets.all(3),
                                child:  FadeInImage.memoryNetwork(
                                    fit: BoxFit.cover,
                                    placeholder: kTransparentImage,
                                    image: snapshot.data?.docs[index].get("url")
                                ),
                              );
                            },
                          ),
                        );
                      },),
                  )
                ],
              )
    ));
  }
}