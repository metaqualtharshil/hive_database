import 'package:flutter/material.dart';
import 'package:hive_database/boxes/boxes.dart';
import 'package:hive_database/notes/notes_model.dart';
import 'package:hive_flutter/adapters.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {

  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hive Database",),
        backgroundColor: Colors.purple,
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
          valueListenable: Boxes.getData().listenable(),
          builder: (context, box, child) {
            var data = box.values.toList()..cast<NotesModel>();
            return ListView.builder(
              itemCount: box.length,
                reverse: true, // list reverse
                shrinkWrap: true,// list reverse
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(data[index].title.toLowerCase()),
                            Spacer(),
                            IconButton(onPressed: (){
                              delete(data[index]);
                            },icon: Icon(Icons.delete),),
                            IconButton(onPressed: (){
                              showDiaologeEdit(context,data[index],data[index].title,data[index].description);
                            },icon: Icon(Icons.edit),),
                          ],
                        ),
                            Text(data[index].description.toLowerCase()),
                      ],
                    ),
                  );
                },
            );
          },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          // var box = await Hive.openBox('harshil');
          // var box1 = await Hive.openBox('ribadiya');
          //
          // box.put("name", "harshil r");
          // box.put("youtube","brand");
          // box.put("details", {
          //   'name':"harshil",
          //   'age':20
          // });

          // box.delete('name');

          // print(box.get('name'));
          // print(box.get('details')['name']);
          showDiaologeCustom(context);
        },
      ),
    );
  }

  void showDiaologeCustom(BuildContext context){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add Items"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "add title",
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: descController,
                    decoration: InputDecoration(
                      hintText: "add desc",
                      border: OutlineInputBorder()
                    ),
                  ),
                ],
              ),
            ),

            actions: [
              ElevatedButton(
                  onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel")
              ),
              ElevatedButton(
                  onPressed: (){
                    final data = NotesModel(
                        title: titleController.text,
                        description: descController.text);
                    final box = Boxes.getData();
                    box.add(data);
                    // data.save();
                    descController.clear();
                    titleController.clear();
                    Navigator.pop(context);

                  }, child: Text("Add")
              ),

            ],
          );
        },
    );
  }

  void showDiaologeEdit(BuildContext context,NotesModel notesModel,String title,String desc){
    titleController.text = title;
    descController.text = desc;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit Items"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "add title",
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: descController,
                    decoration: InputDecoration(
                      hintText: "add desc",
                      border: OutlineInputBorder()
                    ),
                  ),
                ],
              ),
            ),

            actions: [
              ElevatedButton(
                  onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel")
              ),
              ElevatedButton(
                  onPressed: (){
                    notesModel.title = titleController.text;
                    notesModel.description = descController.text;

                    notesModel.save();
                    titleController.clear();
                    descController.clear();
                    Navigator.pop(context);

                  }, child: Text("edit")
              ),

            ],
          );
        },
    );
  }

  void delete(NotesModel notesModel) async{
    await notesModel.delete();
  }

}
