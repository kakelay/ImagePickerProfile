import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asset Picker Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AssetEntity> _selectedAssets = [];

  void _onSelectAssets(List<AssetEntity> assets) {
    setState(() {
      _selectedAssets = List<AssetEntity>.from(assets);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asset Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                AssetPicker.pickAssets(context,
                    pickerConfig: AssetPickerConfig(
                      specialItemPosition: SpecialItemPosition.prepend,
                      specialItemBuilder: (context, path, length) {
                        return GestureDetector(
                          onTap: () async {
                            final img = await ImagePicker.platform
                                .pickImage(source: ImageSource.camera);

                            if (img != null) {
                              Navigator.pop(context);
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  showDragHandle: true,
                                  builder: (context) {
                                    return Image.file(File(img.path));
                                  });
                            }
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            color: Colors.red,
                          ),
                        );
                      },
                    ));
              },
              child: Text('Pick Images and Videos'),
            ),
            SizedBox(height: 20),
            if (_selectedAssets.isNotEmpty)
              Column(
                children: [
                  Text('Selected Images and Videos:'),
                  SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                    ),
                    itemCount: _selectedAssets.length,
                    itemBuilder: (context, index) {
                      return Image(
                        image: AssetEntityImageProvider(_selectedAssets[index],
                            isOriginal: false),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
