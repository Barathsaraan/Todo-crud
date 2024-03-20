import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart'; 

final FirebaseFirestore firestore = FirebaseFirestore.instance;

final TextEditingController nameController = TextEditingController();
final TextEditingController snController = TextEditingController();
final TextEditingController addressController = TextEditingController();

void createBottomSheet(BuildContext context) {
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
                "Create your items",
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
                final id = DateTime.now().microsecondsSinceEpoch.toString();
                await firestore.collection('items').doc(id).set({
                  'name': nameController.text.toString(),
                  'sn': snController.text.toString(),
                  'address': addressController.text.toString(),
                  'id': id,
                });
               
                nameController.clear();
                snController.clear();
                addressController.clear();

                Navigator.pop(context);
              },
              child: const Text("Add"),
            )
          ],
        ),
      );
    },
  );
}
