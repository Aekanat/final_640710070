import 'dart:convert';

import 'package:flutter/material.dart';

import '../helpers/api_caller.dart';
import '../helpers/dialog_utils.dart';
import '../models/webItems.dart';
import '../helpers/my_text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<webItem> _webItems = [];

  @override
  void initState() {
    super.initState();
    _loadWebItems();
  }

  Future<void> _loadWebItems() async {
    try {
      final data = await ApiCaller().get("web_types");
      // ข้อมูลที่ได้จาก API นี้จะเป็น JSON array ดังนั้นต้องใช้ List รับค่าจาก jsonDecode()
      List list = jsonDecode(data);
      setState(() {
        _webItems = list.map((e) => webItem.fromJson(e)).toList();
      });
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final TextEditingController _URL = TextEditingController();
    final TextEditingController _Details = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Negative Web Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MyTextField(
              controller: _URL,
              hintText: 'Enter web URL here *',
            ),

            MyTextField(
              controller: _Details,
              hintText: 'Details',
            ),

            Text('Nagative Web Type *', style: textTheme.titleMedium),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: _webItems.length,
                itemBuilder: (context, index) {
                  final item = _webItems[index];
                  return Card(
                    child: ListTile(
                      leading: item.imageURL.isEmpty
                          ? null
                          : Image.network(
                              ApiCaller.host + item.imageURL,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.error,
                                  color: Colors.red,
                                );
                              },
                            ),
                      title: Text(item.title),
                      subtitle: Text(item.subtitle),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24.0),

            // ปุ่มทดสอบ POST API
            ElevatedButton(
              onPressed: _handleApiPost,
              child: const Text('Test POST API'),
            ),

            const SizedBox(height: 8.0),

            // ปุ่มทดสอบ OK Dialog
            ElevatedButton(
              onPressed: _handleShowDialog,
              child: const Text('Show OK Dialog'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleApiPost() async {
    try {
      final data = await ApiCaller().post(
        "web_types",
        params: {
          "webgId": "aaa",
          "title": "ทดสอบๆๆๆๆๆๆๆๆๆๆๆๆๆๆ",
          "completed": true,
        },
      );
      // API นี้จะส่งข้อมูลที่เรา post ไป กลับมาเป็น JSON object ดังนั้นต้องใช้ Map รับค่าจาก jsonDecode()
      Map map = jsonDecode(data);
      String text =
          'ส่งข้อมูลสำเร็จ\n\n - id: ${map['id']} \n - userId: ${map['userId']} \n - title: ${map['title']} \n - completed: ${map['completed']}';
      showOkDialog(context: context, title: "Success", message: text);
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  Future<void> _handleShowDialog() async {
    await showOkDialog(
      context: context,
      title: "This is a title",
      message: "This is a message",
    );
  }
}
