class Translate {
  const Translate({
    this.phrase,
    this.languageIso3From,
    this.languagesIso3To,
  });

  factory Translate.fromJson(Map<String, dynamic> json) => Translate(
        phrase: json['Phrase'] as String?,
        languageIso3From: json['LanguageISO3From'] as String?,
        languagesIso3To: json['LanguagesISO3To'] as dynamic,
      );
  final String? phrase;
  final String? languageIso3From;
  final dynamic languagesIso3To;

  Map<String, dynamic> toJson() => {
        'Phrase': phrase,
        'LanguageISO3From': languageIso3From,
        'LanguagesISO3To': languagesIso3To,
      };
}
