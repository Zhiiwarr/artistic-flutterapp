import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestListPage extends StatelessWidget {
  const RequestListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: currentUser == null
          ? Center(
              child: Text('Please log in to view requests'),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('requests')
                  .where('userId', isEqualTo: currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No requests found'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var request = snapshot.data!.docs[index];
                    String itemId = request['itemId'];
                    String status = request['status'];
                    String requestId = request.id; // Document ID of the request

                    // Fetch item details from 'items' collection based on itemId
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('items')
                          .doc(itemId)
                          .get(),
                      builder: (context, itemSnapshot) {
                        if (itemSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                            title: Text('Loading...'),
                          );
                        }

                        if (!itemSnapshot.hasData) {
                          return ListTile(
                            title: Text('Item not found'),
                          );
                        }

                        var itemData = itemSnapshot.data!;
                        String itemName = itemData['name'];
                        String itemDescription = itemData['description'];
                        String itemPrice = itemData['price'];

                        return ListTile(
                          title: Text(itemName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Description: $itemDescription'),
                              Text('Price: $itemPrice'),
                              Text('Status: $status'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              // Implement delete action
                              await FirebaseFirestore.instance
                                  .collection('requests')
                                  .doc(requestId)
                                  .delete();
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
