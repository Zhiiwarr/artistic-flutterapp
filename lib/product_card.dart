import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_app/auth_service.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String description;
  final String image;
  final String id; // Use id to capture the item's document ID

  const ProductCard({
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.id, // Initialize id
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(image,
                height: 150, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 10),
            Text(name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(description,
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 5),
            Text('\$$price',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (_authService.currentUser == null) {
                  Navigator.pushNamed(context, '/login');
                } else {
                  // Get current user's UID
                  String userId = _authService.currentUser!.uid;

                  // Get artistId from item document in Firestore
                  DocumentSnapshot itemSnapshot = await FirebaseFirestore
                      .instance
                      .collection('items')
                      .doc(id)
                      .get();
                  String artistId = itemSnapshot['artistId'];

                  // Add request to Firestore
                  try {
                    await FirebaseFirestore.instance
                        .collection('requests')
                        .add({
                      'userId': userId,
                      'itemId': id,
                    'status': 'pending'
,                      'artistId': artistId,
                      'timestamp': Timestamp.now(),
                    });
                    // Show success message or navigate to success page
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Success'),
                        content: const Text('Purchase request sent.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error'),
                        content: Text('Failed to send request: $e'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
              child: const Text('Buy Now'),
            ),
          ],
        ),
      ),
    );
  }
}
