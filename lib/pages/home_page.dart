import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<void> saveData() async {
    final String data = inputController.text.trim();
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    if (data.isNotEmpty) {
      await FirebaseFirestore.instance.collection("Users").add({
        "data": data,
        "userId": userId,
        "timestamp": FieldValue.serverTimestamp(),
      });
      inputController.clear();
      // Scroll to the bottom after adding new data
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> deleteMessage(String docId) async {
    await FirebaseFirestore.instance.collection("Users").doc(docId).delete();
  }

  Future<void> pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );
    if (result != null && result.files.isNotEmpty) {
      final String? filePath = result.files.first.path;
      if (filePath != null) {
        final String fileContent = await File(filePath).readAsString();
        // Handle the file content as needed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: const Text(
          "Chat Interface",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(
                    child: Text("Error fetching data", style: TextStyle(color: Colors.white)),
                  );
                }
                final List<QueryDocumentSnapshot> documents = snapshot.data!.docs.reversed.toList();
                return ListView.builder(
                  controller: _scrollController, // Use the scroll controller here
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> userData = documents[index].data() as Map<String, dynamic>;
                    final String docId = documents[index].id; // Get the document ID
                    return Card(
                      color: Colors.blueGrey[800],
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                userData["data"] ?? "",
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Show a confirmation dialog before deleting
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Delete Message"),
                                      content: const Text("Are you sure you want to delete this message?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            deleteMessage(docId); // Delete the message
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                          child: const Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildInputSection(),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[700],
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: inputController,
                decoration: const InputDecoration(
                  hintText: 'Enter CypherText',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: saveData,
            color: const Color(0xFF10A37F),
          ),
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: pickFile,
            color: const Color(0xFF10A37F),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueGrey[800],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey[900],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'CryptoCrew',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Your personalized chat experience.',
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.home,
            title: 'Home',
            onTap: () => Navigator.pop(context),
          ),

          _buildDrawerItem(
            context,
            icon: Icons.logout,
            title: 'Logout',
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}
