import 'package:hive/hive.dart';
import 'package:hive_database/notes/notes_model.dart';

class Boxes{
  static Box<NotesModel> getData() => Hive.box<NotesModel>('notes');
}