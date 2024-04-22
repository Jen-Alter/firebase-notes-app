import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  // Get the collection of notes that already exist
  final CollectionReference notes =
    FirebaseFirestore.instance.collection('notes');

  // CREATE: Add a new note
  Future<void> addNote(String note){
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now()
    });
  }

  // READ: Read information from database
  Stream<QuerySnapshot> getNotesStream(){
    final notesStream = notes.orderBy('timestamp', descending: true).snapshots();

    return notesStream;
  }

  // UPDATE: Update notes using a specified document ID
  Future<void> updateNote(String docID, String newNote){
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  // DELETE: Delete notes using a specified document ID
  Future<void> deleteNote(String docID){
    return notes.doc(docID).delete();
  }
}