import 'dart:convert';

import 'package:flutter/material.dart';

import '../helpers/api_caller.dart';
import '../helpers/dialog_utils.dart';
import '../models/webItems.dart';
import '../helpers/my_text_field.dart';
import '../helpers/my_list_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<webItem> _webItems = [];
  final TextEditingController _URL = TextEditingController();
  final TextEditingController _Details = TextEditingController();
  int _selectedIndex = -1;

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
                  return MyListTile(
                    title: item.title,
                    subtitle: item.subtitle,
                    imageUrl: ApiCaller.host+item.imageURL,
                    selected: _selectedIndex == index,
                    onTap: () => _selectedItems(index, item.webID),
                  );
                },
              ),
            ),
            const SizedBox(height: 24.0),

            // ปุ่มทดสอบ POST API
            ElevatedButton(
              onPressed: _handleApiPost,
              child: const Text('Sent Information'),
            ),

            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Future<void> _handleApiPost() async {
    try {
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

  void _selectedItems(int index,String ID) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
