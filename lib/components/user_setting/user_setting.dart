@HtmlImport('user_setting.html')
library user_setting;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:web_components/web_components.dart' show HtmlImport;
import 'package:dartium_issue/models/models.dart';
import 'package:dartium_issue/services/services.dart';

@PolymerRegister("user-setting")
class UserSetting extends PolymerElement {
  UserSetting.created(): super.created();

  SearchSetting search = new SearchSetting("ja");

  @Property(observer: "defaultLanguageChanged")
  String defaultLanguage;

  @reflectable
  defaultLanguageChanged(String newValue, String oldValue) async {
    var oldLang = search.defaultLanguage;
    if (oldLang == defaultLanguage) {
      // language hasn't changed
      return;
    }
    search.defaultLanguage = defaultLanguage;
    try {
      await _channel.updateSearchSetting(search, "");
      Logger.root.info("updated search setting");
    } catch (e) {
      Logger.root.warning("Failed to update search setting: ${e}");
    };
  }

  void ready() {
    var domain = AppEngineServerChannel.generateRootDomain(window.location);
    _channel = new AppEngineServerChannel(domain);
  }

  AppEngineServerChannel _channel;
}
