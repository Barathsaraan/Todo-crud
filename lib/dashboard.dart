import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing/addscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _ascendingOrder = true;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
        leading: IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
            setState(() {
              _ascendingOrder = !_ascendingOrder;
            });
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('items')
            .orderBy('name', descending: !_ascendingOrder)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];
                return Card(
                  elevation: 3, // Adjust elevation as needed
                  margin: EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16), // Adjust margin as needed
                  child: ListTile(
                    title: Text(doc['name']),
                    subtitle: Text(doc['address']),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              updateBottomSheet(
                                context,
                                doc['name'],
                                doc.id,
                                doc['sn'],
                                doc['address'],
                              );
                            },
                            leading: const Icon(Icons.edit),
                            title: const Text("Edit"),
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: ListTile(
                            onTap: () async {
                              Navigator.pop(context);
                              await firestore
                                  .collection('items')
                                  .doc(doc.id)
                                  .delete();
                            },
                            leading: const Icon(Icons.delete),
                            title: const Text("Delete"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return Center(
            child: Text('No data available'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createBottomSheet(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void updateItem(String id, String name, String sn, String address) async {
    await firestore.collection('items').doc(id).update({
      'name': name,
      'sn': sn,
      'address': address,
    });
  }

  void updateBottomSheet(
    BuildContext context,
    String name,
    String id,
    String sn,
    String address,
  ) {
    nameController.text = name;
    snController.text = sn;
    addressController.text = address;

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.blue[100],
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            right: 20,
            left: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  "Update item",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "eg.Barath",
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: snController,
                decoration: const InputDecoration(
                  labelText: "Age",
                  hintText: "eg.23",
                ),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: "Address",
                  hintText: "eg.tn",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  updateItem(
                    id,
                    nameController.text.toString(),
                    snController.text.toString(),
                    addressController.text.toString(),
                  );

                  nameController.clear();
                  snController.clear();
                  addressController.clear();

                  Navigator.pop(context);
                },
                child: const Text("Update"),
              )
            ],
          ),
        );
      },
    );
  }
}
