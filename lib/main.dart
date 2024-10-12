import 'package:flutter/material.dart';
import 'package:flutter_sqlite_demo/model/model.dart';
import 'package:flutter_sqlite_demo/services/db_handler.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite CRUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UserScreen(),
    );
  }
}

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<User> userList = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  User? selectedUser;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // Load users from database
  void _loadUsers() async {
    final users = await dbHelper.getUsers();
    setState(() {
      userList = users;
    });
  }

  // Add or update user
  void _saveUser() {
    String name = nameController.text;
    int age = int.parse(ageController.text);

    if (selectedUser == null) {
      dbHelper.insertUser(User(name: name, age: age));
    } else {
      dbHelper.updateUser(User(id: selectedUser!.id, name: name, age: age));
      selectedUser = null;
    }
    nameController.clear();
    ageController.clear();
    _loadUsers();
  }

  // Select user for editing
  void _selectUser(User user) {
    setState(() {
      selectedUser = user;
      nameController.text = user.name;
      ageController.text = user.age.toString();
    });
  }

  // Delete user
  void _deleteUser(int id) {
    dbHelper.deleteUser(id);
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
            onTap: () async {
              String path = join(await getDatabasesPath(), 'user_database.db');
              print('Database path: $path');
              DatabaseHelper().printUsers();
            },
            child: Text('SQLite CRUD Example')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUser,
              child: Text(selectedUser == null ? 'Add User' : 'Update User'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  final user = userList[index];
                  return ListTile(
                    title: Text('${user.name}, Age: ${user.age}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _selectUser(user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteUser(user.id!),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
