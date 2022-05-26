import 'package:database_demo/database/database_manager.dart';
import 'package:database_demo/database/entity/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<User> users = [];

  final _userIdCtr = TextEditingController();
  final _userNameCtr = TextEditingController();

  // 当前选择
  User? currentUser;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Database Demo"),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                  child: _operationButton("添加", Colors.green, onTap: _insert)),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                  child: _operationButton("修改", Colors.green, onTap: _update))
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                  child: _operationButton("查询所有", Colors.green,
                      onTap: _selectAll)),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                  child: _operationButton("删除", Colors.red, onTap: _delete))
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                  child: _operationButton("按Id查询", Colors.green,
                      onTap: _selectById)),
            ],
          ),
          Row(
            children: [
              const Text(
                "userId",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: _userIdCtr,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              const Text(
                "userName",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: _userNameCtr,
                ),
              )
            ],
          ),
          const SizedBox(height: 15,),
          const Text(
            "数据",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10,),
          Expanded(
              child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              final user = users[index];
              return GestureDetector(
                onTap: () {
                  currentUser = user;
                  _userIdCtr.text = currentUser!.userId;
                  _userNameCtr.text = currentUser!.name;
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  color: Colors.blue,
                  child: Text(
                      "id:${user.id}     userId:${user.userId}    name:${user.name}"),
                ),
              );
            },
            itemCount: users.length,
          ))
        ],
      ),
    );
  }

  _operationButton(String txt, Color color, {GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(4), color: color),
        child: Text(
          txt,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }

  void _insert() async {
    if (_userIdCtr.text.isEmpty || _userNameCtr.text.isEmpty) {
      Fluttertoast.showToast(msg: "数据不能为空");
      return;
    }
    await DataBaseManager.insertUser(
        User(null, _userIdCtr.text, _userNameCtr.text));
    Fluttertoast.showToast(msg: "插入成功");
    _selectAll();
    clean();
  }

  void _update() async {
    if (currentUser == null) {
      Fluttertoast.showToast(msg: "当前未选中任何用户");
      return;
    }
    if (_userIdCtr.text.isEmpty || _userNameCtr.text.isEmpty) {
      Fluttertoast.showToast(msg: "数据不能为空");
      return;
    }
    currentUser!.userId = _userIdCtr.text;
    currentUser!.name = _userNameCtr.text;
    await DataBaseManager.updateUser(currentUser!);
    Fluttertoast.showToast(msg: "更新成功");
    _selectAll();
  }

  void _selectAll() async {
    users = await DataBaseManager.queryAllUser();
    Fluttertoast.showToast(msg: "查询成功");
    setState(() {});
  }

  void _delete() async {
    if (currentUser == null) {
      Fluttertoast.showToast(msg: "当前未选中任何用户");
      return;
    }
    await DataBaseManager.deleteUser(currentUser!);
    Fluttertoast.showToast(msg: "删除成功");
    _selectAll();
    clean();
  }

  Future<void> _selectById() async {
    if (_userIdCtr.text.isEmpty) {
      Fluttertoast.showToast(msg: "id不能为空");
      return;
    }
    users = await DataBaseManager.queryUserById(_userIdCtr.text);
    Fluttertoast.showToast(msg: "查询成功");
    setState(() {});
  }
  clean(){
    _userIdCtr.clear();
    _userNameCtr.clear();
  }
}
