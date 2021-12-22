import 'package:flutter/foundation.dart';
import 'package:wiredash/src/common/build_info/build_info.dart';
import 'package:wiredash/src/feedback/wiredash_model.dart';
import 'package:wiredash/wiredash.dart';

/// Use this controller to interact with [Wiredash]
///
/// Start Wiredash:
/// ```dart
/// Wiredash.of(context).show();
/// ```
///
/// Add user information
/// ```dart
/// Wiredash.of(context)
///     .setBuildProperties(buildVersion: "1.4.3", buildNumber: "42");
/// ```
class WiredashController {
  WiredashController(this._model);

  final WiredashModel _model;

  /// Modify the metadata that will be collected with Wiredash
  ///
  /// The metadata include user information (userId and userEmail),
  /// build information (version, buildNumber, commit) and
  /// any custom data (Map<String, Object?>) you want to have attached to
  /// feedback.
  ///
  /// Setting the userEmail prefills the email field.
  ///
  /// The build information is prefilled by [EnvBuildInfo], reading the build
  /// environment variables during compilation.
  ///
  /// Usage:
  ///
  /// ```dart
  /// Wiredash.of(context).modifyMetaData(
  ///   (metaData) => metaData
  ///     ..userEmail = 'dash@wiredash.io'
  ///     ..buildCommit = '43f23dd'
  ///     ..custom['screen'] = 'HomePage'
  ///     ..custom['isPremium'] = false,
  /// );
  /// ```
  void modifyMetaData(
    CustomizableWiredashMetaData Function(CustomizableWiredashMetaData metaData)
        mutation,
  ) {
    _model.metaData = mutation(_model.metaData);
  }

  /// Use this method to provide custom [userId]
  /// to the feedback. The [userEmail] parameter can be used to prefill the
  /// email input field but it's up to the user to decide if he want's to
  /// include his email with the feedback.
  @Deprecated('use mutateMetaData((metaData) => metaData)')
  void setUserProperties({String? userId, String? userEmail}) {
    modifyMetaData(
      (metaData) => metaData
        ..userId = userId ?? metaData.userId
        ..userEmail = userEmail ?? metaData.userEmail,
    );
  }

  /// Use this method to attach custom [buildVersion] and [buildNumber]
  ///
  /// If these values are also provided through dart-define during compile time
  /// then they will be overwritten by this method
  @Deprecated('use mutateMetaData((metaData) => metaData)')
  void setBuildProperties({String? buildVersion, String? buildNumber}) {
    modifyMetaData(
      (metaData) => metaData
        ..buildVersion = buildVersion ?? metaData.buildVersion
        ..buildNumber = buildNumber ?? metaData.buildNumber,
    );
  }

  /// This will open the Wiredash feedback sheet and start the feedback process.
  ///
  /// Currently you can customize the theme and translation by providing your
  /// own [WiredashTheme] and / or [WiredashTranslation] to the [Wiredash]
  /// root widget. In a future release you'll be able to customize the SDK
  /// through the Wiredash admin console as well.
  ///
  /// If a Wiredash feedback flow is already active (=a feedback sheet is open),
  /// does nothing.
  void show() => _model.show();

  /// A [ValueNotifier] representing the current state of the capture UI. Use
  /// this to change your app's configuration when the user is in the process
  /// of taking a screenshot of your app - e.g. hiding sensitive information or
  /// disabling specific widgets.
  ///
  /// The [Confidential] widget can automatically hide sensitive widgets from
  /// being recorded in a feedback screenshot.
  ValueNotifier<bool> get visible {
    return _model.services.backdropController
        .asValueNotifier((c) => c.isAppInteractive);
  }
}
