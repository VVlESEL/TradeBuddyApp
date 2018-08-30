import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:trade_buddy/utils/auth.dart';
import 'package:trade_buddy/utils/image_compressor.dart';
import 'package:trade_buddy/utils/settings_controller.dart';
import 'package:trade_buddy/utils/trade_model.dart';

class Screenshot extends StatefulWidget {
  final Trade trade;

  Screenshot(this.trade);

  @override
  _ScreenshotDialogState createState() => _ScreenshotDialogState();
}

class _ScreenshotDialogState extends State<Screenshot> {
  File _imageFile;
  bool _isLoading = false;

  Future<void> _uploadFile() async {
    final File file = await compressFile(_imageFile, width: 500);
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child("user/${Auth.user.uid}/trades/${SettingsController
        .currentAccount}/${widget.trade.id}");
    final StorageUploadTask task = ref.putFile(file);
    final Uri downloadUrl = (await task.future).downloadUrl;
    print(downloadUrl.toString());
    widget.trade.setScreenshotPath(downloadUrl.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trade #${widget.trade.id}"),
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : (widget.trade.screenshotPath != null
              ? PhotoView(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      imageProvider: NetworkImage(widget.trade.screenshotPath))
              : Container()),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (item) async {
            setState(() => _isLoading = true);
            _imageFile = await ImagePicker.pickImage(
                source: item == 0 ? ImageSource.camera : ImageSource.gallery);
            if (_imageFile != null) await _uploadFile();
            setState(() => _isLoading = false);
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon:
                  Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
              title: Text("Camera"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.image, color: Theme.of(context).primaryColor),
              title: Text("Gallery"),
            )
          ]),
    );
  }
}
