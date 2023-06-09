import 'package:flutter/material.dart';
import 'package:sqflite_example/database/database_helper.dart';

import 'package:sqflite_example/database/user_dao.dart';
import 'package:sqflite_example/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.init();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final controller = TextEditingController();
  List<UserModel> users = [];
  final dao = UserDao();
  @override
  void initState() {

    super.initState();
    dao.readAll().then((value){
      setState(() {
        users = value;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: SafeArea(
                child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                controller: controller,
              )),
              ElevatedButton(
                  onPressed: () async {
                    final name = controller.text;
                    UserModel user = UserModel(name: name);
                    final id = await dao.insert(user);
                    user = user.copyWith(id: id);
                    controller.clear();
                    setState(() {
                      users.add(user);
                    });
                  }, child: const Text('Create user'))
            ],
          ),
        ),
        ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (ctx, index) {
              final user = users[index];
              return ListTile(
                leading: Text('${user.id}'),
                title: Text(user.name),
                trailing: IconButton(
                    onPressed: () async {
                      await dao.delete(user);
                      setState(() {
                        users.removeWhere((element) => element.id == user.id);
                      });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              );
            })
      ],
    ))));
  }
}
