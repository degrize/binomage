import 'package:binomage/models/binomage.model.dart';
import 'package:binomage/services/binomage.service.dart';
import 'package:binomage/services/parrain_filleul.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class BinoListPage extends StatefulWidget {
  const BinoListPage({super.key});

  @override
  _BinoListPageState createState() => _BinoListPageState();
}

class _BinoListPageState extends State<BinoListPage> {
  List<Binomage> binomages = [];

  @override
  void initState() {
    super.initState();
    fetchBinomages();
  }

  Future<void> fetchBinomages() async {
    List<Binomage> binomages = await getBinomages();
    setState(() {
      this.binomages = binomages;
    });
  }

  Widget _testFirebaseData() {
    return SafeArea(
        child : Column(
          children: [
                StreamBuilder<List<Binomage>>(
                stream: getAllBinomage(),
                builder: (context, snapshot) {
                  if(snapshot.hasError) {
                    return const Text("Invalid");
                  } else if(snapshot.hasData) {
                    final utilisateurs = snapshot.data;

                    //return Text(utilisateurs![0].nom);

                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: utilisateurs?.length,
                        itemBuilder: (context, index)=> ListTile(
                          title: Text(utilisateurs![index].titre),
                        ));
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
            ),
          ],
        )

    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text(MyApp.title),
  //     ),
  //     body: Container(
  //         height: double.infinity,
  //         width: double.infinity,
  //         padding: const EdgeInsets.all(20),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             _testFirebaseData()
  //           ],
  //         )
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(MyApp.title),
      centerTitle: true,
    ),
    body: ReorderableListView.builder(
      itemCount: binomages.length,
      onReorder: (oldIndex, newIndex) => setState(() {
        final index = newIndex > oldIndex ? newIndex - 1 : newIndex;

        final user = binomages.removeAt(oldIndex);
        binomages.insert(index, user);
      }),
      itemBuilder: (context, index) {
        final user = binomages[index];

        return buildUser(index, user);
      },
    ),
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.shuffle),
      onPressed: shuffleList,
    ),
  );

  Widget buildUser(int index, Binomage binomage) => ListTile(
    key: ValueKey(binomage),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    leading: const CircleAvatar(
      backgroundImage: NetworkImage('https://images.unsplash.com/photo-1554151228-14d9def656e4?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=633&q=80'),
      radius: 30,
    ),
    title: Text(binomage.titre),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.black),
          onPressed: () => edit(index),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.black),
          onPressed: () => remove(index),
        ),
      ],
    ),
  );

  void remove(int index) => setState(() => binomages.removeAt(index));

  void edit(int index) => showDialog(
    context: context,
    builder: (context) {
      final user = binomages[index];

      return AlertDialog(
        content: TextFormField(
          initialValue: "user.name",
          onFieldSubmitted: (_) => Navigator.of(context).pop(),
          onChanged: (name) => setState(() => user.titre = name),
        ),
      );
    },
  );

  void shuffleList() => setState(() => binomages.shuffle());
}