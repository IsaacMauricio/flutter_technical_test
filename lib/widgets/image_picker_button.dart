import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helpers/permissions_util.dart';
import '../screens/image_viewer_screen.dart';

class ImagePickerButton extends StatefulWidget {
  const ImagePickerButton.fab({super.key}) : fab = true;
  const ImagePickerButton.text({super.key}) : fab = false;

  final bool fab;

  @override
  State<ImagePickerButton> createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.fab) {
      return FloatingActionButton(
        onPressed: _pickImage,
        child: Icon(Icons.camera_alt_outlined),
      );
    } else {
      return TextButton.icon(
        onPressed: _pickImage,
        icon: Icon(Icons.camera_alt_outlined),
        label: Text('Tomar imagen'),
      );
    }
  }

  Future<void> _pickImage() async {
    PermissionsUtil.runtimePermissionWorkflow(
      permission: Permission.camera,
      onDenied: () async {},
      showRationale: () async {
        return false;
      },
      onGranted: () async {
        XFile? file = await ImagePicker().pickImage(source: ImageSource.camera);
        if (file == null) return;

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ImageViewerScreen(file)),
        );
      },
    );
  }
}
