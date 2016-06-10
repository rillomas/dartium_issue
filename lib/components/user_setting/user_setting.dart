@HtmlImport('user_setting.html')
library user_setting;

import 'dart:html';
import 'dart:async';
import 'dart:convert' show JSON;
import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:web_components/web_components.dart' show HtmlImport;
import 'package:dartium_issue/models/models.dart';

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
      Logger.root.info("updating search setting");
      await updateSearchSetting(search, "");
      Logger.root.info("updated search setting");
    } catch (e) {
      Logger.root.warning("Failed to update search setting: ${e}");
    };
  }

  void ready() {
    var location = window.location;
    _domain = "${location.protocol}//${location.host}/";
  }

  Future<bool> updateSearchSetting(SearchSetting setting, String mutationToken) {
    var url = "${_domain}${USER_API_PATH}/${SEARCH_SETTING_PATH}";
    var task = new AsyncHttpRequest<bool>();
    var hdr = {USER_MUTATION_TOKEN_HEADER_NAME: mutationToken};
    var data = JSON.encode(setting);
    var f = task.request(url, (res) {
      return true;
    }, method: "POST", sendData: data, headers: hdr);
    return f;
  }
  static const String USER_API_PATH = "api/1/user";
  static const String SEARCH_SETTING_PATH = "searchSetting";
  static const String USER_MUTATION_TOKEN_HEADER_NAME = "User-Mutation-Token";
  // AppEngineServerChannel _channel;
  String _domain;
}

/// A class to run async http requests
class AsyncHttpRequest<Output> {
  Future<Output> request(String url, Output process(String response), {String method: "GET", sendData , Map<String,String> headers: const{}}) async {
    HttpRequest r;
    try {
      r = await HttpRequest.request(url, method:method, sendData:sendData, requestHeaders:headers);
    } catch (error) {
      throw error.target;
    }
    if (r.readyState == HttpRequest.DONE && r.status == 200) {
      // completed normally
      return process(r.responseText);
    }
    // some kind of error occured
    throw r;
  }
}
