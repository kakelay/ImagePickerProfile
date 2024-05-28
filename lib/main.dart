import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'view_image.dart';

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
  void _onSelectAssets(List<AssetEntity> assets) {
    // Navigate to a new page to display the selected images
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplaySelectedAssetsPage(
          selectedAssets: assets,
        ),
      ),
    );
  }

  void _onCameraImagePicked(XFile img) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplaySelectedAssetsPage(
          cameraImagePath: img.path,
        ),
      ),
    );
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
            GestureDetector(
              onTap: () async {
                final List<AssetEntity>? result = await AssetPicker.pickAssets(
                  context,
                  pickerConfig: AssetPickerConfig(
                    maxAssets: 1,
                    specialItemPosition: SpecialItemPosition.prepend,
                    requestType: RequestType.image,
                    specialItemBuilder: (context, path, length) {
                      return GestureDetector(
                        onTap: () async {
                          final img = await ImagePicker()
                              .pickImage(source: ImageSource.camera);

                          if (img != null) {
                            Navigator.pop(context);
                            _onCameraImagePicked(img);
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.red,
                          child: Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      );
                    },
                  ),
                );

                if (result != null && result.isNotEmpty) {
                  _onSelectAssets(result);
                }
              },
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Text(
                  'Pick Image',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
