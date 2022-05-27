//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <connectivity_plus_windows/connectivity_plus_windows_plugin.h>
#include <flutter_app_icon_badge/flutter_app_icon_badge_plugin.h>
#include <objectbox_flutter_libs/objectbox_flutter_libs_plugin.h>
#include <pdfx/pdfx_plugin.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  ConnectivityPlusWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ConnectivityPlusWindowsPlugin"));
  FlutterAppIconBadgePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterAppIconBadgePlugin"));
  ObjectboxFlutterLibsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ObjectboxFlutterLibsPlugin"));
  PdfxPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PdfxPlugin"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
