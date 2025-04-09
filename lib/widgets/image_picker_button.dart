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
      onDenied: () async {
        bool openSettings =
            await showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text('Permiso negado'),
                    content: Text(
                      'No se concedió el permiso para usar la cámara. Puede abrir los ajustes para conceder este permiso.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Abrir ajustes'),
                      ),
                    ],
                  ),
            ) ??
            false;

        if (openSettings) openAppSettings();
      },
      showRationale: () async {
        bool requestAgain =
            await showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text('Permiso de usar cámara'),
                    content: Text(
                      'Por favor conceda el permiso para utilizar la camara',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Permitir'),
                      ),
                    ],
                  ),
            ) ??
            false;

        return requestAgain;
      },

      onGranted: () async {
        XFile? file = await ImagePicker().pickImage(source: ImageSource.camera);
        if (file == null) return;

        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ImageViewerScreen(file)),
          );
        }
      },
    );
  }
}
