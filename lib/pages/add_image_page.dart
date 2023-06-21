import 'dart:io';

import 'package:binomage/enumerations/collections.enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class AddImagePage extends StatefulWidget {
  const AddImagePage({super.key});

  @override
  _AddImagePageSate createState() => _AddImagePageSate();
}

class _AddImagePageSate extends State<AddImagePage> {
  bool uploading = false;
  double val = 0;
  late CollectionReference imgRef;
  late firebase_storage.Reference ref;


  List<File> _image = [];
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ajouter Photos'),
          actions: [TextButton(
              onPressed: () {
                setState(() {
                  uploading = true;
                });
                uploadFile().whenComplete(() => Navigator.of(context).pop());
              },
              child: const Text("upload", style: TextStyle(color: Colors.white),))],
        ),
        body: Stack(children: [
          GridView.builder(
            itemCount: _image.length+1,

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3), itemBuilder: (BuildContext context, int index) {
            return index == 0
                ? Center(
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => !uploading ? chooseImage() : null,
              ),
            )
                : Container(
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        image: DecorationImage(image: FileImage(_image[index-1]),
                            fit: BoxFit.cover)
              ),
            );
          }),
          uploading
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                      'uploading...',
                      style: TextStyle(fontSize: 20),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                  ]))
              : Container()
        ],)

    );
  }

  chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image.add(File(pickedFile!.path));
    });
    if (pickedFile?.path == null) {
        retrieveLostData();
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file!.path));
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile() async{
    int i = 1;
    for (var img in _image) {
      setState(() {
        val = i /_image.length;
      });
      ref = firebase_storage.FirebaseStorage
          .instance.ref()
          .child('images/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imgRef.add({'url': value});
          i++;
        });
      } );
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imgRef = FirebaseFirestore.instance.collection(Collections.parrainImageURls.name);
  }
}