import 'package:supabase/supabase.dart';
import "package:supabase_flutter_todo/constants.dart";

class SBHelper {
  static final SupabaseClient supabase = SupabaseClient(
    Constants.supabaseUrl,
    Constants.supabaseAnnonKey
  );

  static SupabaseClient getClient() {
    return supabase;
  }

  static Future<List<dynamic>> getAllTodo() async {
    final response = await supabase.from('todo').select();
    return response;
  }
  // add todo
  static Future<Map<String, dynamic>> addTodo(
      String title, String description) async {
    final response = await supabase.from('todo').insert([
      {
        'title': title,
        'description': description,
        'isDone': false,
      }
    ]);
    return response;
  }
  // set isDone flag to true
  static Future<void> setDone(int id, bool isDone) async {
    await supabase.from('todo').update({'isDone': isDone}).eq('id', id);
  }
}