import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helpers/permissions_util.dart';

class ImageViewerScreen extends StatefulWidget {
  const ImageViewerScreen(this.image, {super.key});

  final XFile image;

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          FutureBuilder(
            future: widget.image.readAsBytes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return SizedBox.expand(
                  child: Icon(Icons.broken_image_outlined),
                );
              }

              if (snapshot.data == null) {
                return SizedBox.expand(
                  child: Icon(Icons.broken_image_outlined),
                );
              }

              return EasyImageView(imageProvider: MemoryImage(snapshot.data!));
            },
          ),
          Positioned(
            left: 16,
            right: 16,
            top: MediaQuery.paddingOf(context).top + 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: Navigator.of(context).pop,
                    icon: Icon(Icons.arrow_back),
                    color: Colors.black,
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: _saveImage,
                    icon: Icon(Icons.save_alt),
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveImage() async {
    Permission permission;

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        permission = Permission.storage;
      } else {
        permission = Permission.photos;
      }
    } else {
      permission = Permission.photosAddOnly;
    }

    PermissionsUtil.runtimePermissionWorkflow(
      permission: permission,
      onDenied: () async {},
      showRationale: () async {
        return false;
      },
      onGranted: () async {
        try {
          var bytes = await widget.image.readAsBytes();

          await ImageGallerySaverPlus.saveImage(bytes);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text('Se ha guardado la imagen'),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Ocurrió un error guardando esta imagen'),
            ),
          );
        }
      },
    );
  }
}
