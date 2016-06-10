part of services;

/// Server channel for app engine
class AppEngineServerChannel {

  AppEngineServerChannel(this._domain);

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

  /// Generate the root domain from location information
  static String generateRootDomain(Location location) {
    return "${location.protocol}//${location.host}/";
  }
  static const String USER_API_PATH = "api/1/user";
  static const String SEARCH_SETTING_PATH = "searchSetting";
  static const String USER_MUTATION_TOKEN_HEADER_NAME = "User-Mutation-Token";
  /// Domain of the server
  String _domain;
}
