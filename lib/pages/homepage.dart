import '../services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreServices = FirestoreService();
  final TextEditingController note = TextEditingController();

  // Open a dialog box to add a new note
  void openNoteBox({String? docID}){
    showDialog(context: context,
    builder: (context) => AlertDialog(
      content: TextField(
        controller: note
      ),
      actions: [
        ElevatedButton(
          onPressed: (){
            if (docID == null){
              firestoreServices.addNote(note.text);
              note.clear();
              Navigator.pop(context);
            }else{
              firestoreServices.updateNote(docID, note.text);
              note.clear();
              Navigator.pop(context);
            }
          },
          child: const Text("Add")
        )
      ],
    )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes")
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add)
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreServices.getNotesStream(),
        builder: ((context, snapshot) {
          if (snapshot.hasData){
            List notesList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: ((context, index) {
                // GET: each individual document from firebase
                DocumentSnapshot document = notesList[index];
                final String docID = document.id;

                // GET: each individual note from each document
                Map<String, dynamic> note = document.data() as Map<String, dynamic>;
                final String theNote = note['note'];

                // DISPLAY: each note as a list tile
                return ListTile(
                  title: Text(theNote),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => openNoteBox(docID: docID),
                        icon: const Icon(Icons.settings)),
                      IconButton(
                        onPressed: () => firestoreServices.deleteNote(docID),
                        icon: const Icon(Icons.delete)),
                    ],
                  )
                );
              })
            );
          }else{
            return const Center(child: Text("No data to be shown"));
          }
        }
      )
    )
  );
}
}