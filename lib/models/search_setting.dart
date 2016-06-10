part of models;

/// Current setting of a default search query
class SearchSetting {
  SearchSetting(this.defaultLanguage);
  SearchSetting.fromJson(Map map) {
    defaultLanguage = map[DEFAULT_LANGUAGE_TAG];
  }

  /// default language for room queries
  String defaultLanguage;

  dynamic toJson() => {
    DEFAULT_LANGUAGE_TAG: defaultLanguage,
  };

  String toString() => "defaultLanguage: $defaultLanguage";

  static const String DEFAULT_LANGUAGE_TAG = "DefaultLanguage";
}
