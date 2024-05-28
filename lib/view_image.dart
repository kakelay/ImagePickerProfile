import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class DisplaySelectedAssetsPage extends StatelessWidget {
  final List<AssetEntity>? selectedAssets;
  final String? cameraImagePath;

  DisplaySelectedAssetsPage({
    this.selectedAssets,
    this.cameraImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$cameraImagePath ----- $selectedAssets')),
      body: Center(
        child: cameraImagePath != null
            ? Image.file(File(cameraImagePath!))
            : selectedAssets != null
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // Show one image per row
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: selectedAssets!.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<File?>(
                        future: selectedAssets![index].file,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return Image.file(snapshot.data!,
                                fit: BoxFit.cover);
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      );
                    },
                  )
                : Text('No image selected'),
      ),
    );
  }
}
