class Language {
  final int id;
  final String flag;
  final String name;
  final String languageCode;

  Language(this.id, this.flag, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, "🇫🇷", "Français", "fr"),
      Language(2, "🇬🇧", "English", "en"),
      Language(3, "🇩🇪", "Deutsch", "de"),
      Language(4, "🇳🇱", "Dutch", "nl")
    ];
  }
}
