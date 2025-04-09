import 'package:permission_handler/permission_handler.dart';

abstract class PermissionsUtil {
  static Future<void> runtimePermissionWorkflow({
    required Permission permission,
    required Future<void> Function() onDenied,
    required Future<bool> Function() showRationale,
    required Future<void> Function() onGranted,
  }) async {
    var status = await permission.status;

    if (status != PermissionStatus.granted) {
      if (status == PermissionStatus.permanentlyDenied) {
        await onDenied();
        return;
      }

      if (await permission.shouldShowRequestRationale) {
        var shouldContinueAfterRationale = await showRationale();

        if (!shouldContinueAfterRationale) return;
      }

      var permissionRequesResult = await permission.request();

      if ([
        PermissionStatus.granted,
        PermissionStatus.limited,
        PermissionStatus.provisional,
      ].contains(permissionRequesResult)) {
        await onGranted();
      } else {
        await onDenied();
      }
    } else {
      await onGranted();
    }
  }
}
