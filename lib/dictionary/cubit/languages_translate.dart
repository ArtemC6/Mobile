import 'package:voccent/generated/l10n.dart';

String? translateLanguage(String locale) {
  return languagesTranslation[locale];
}

final Map<String, String> languagesTranslation = {
  'de-DE': S.current.rawLanguage_de_DE,
  'ar-AR': S.current.rawLanguage_ar_AR,
  'en-US': S.current.rawLanguage_en_US,
  'es-ES': S.current.rawLanguage_es_ES,
  'fa-IR': S.current.rawLanguage_fa_IR,
  'fi-FI': S.current.rawLanguage_fi_FI,
  'fr-FR': S.current.rawLanguage_fr_FR,
  'he-IL': S.current.rawLanguage_he_IL,
  'hi-IN': S.current.rawLanguage_hi_IN,
  'hy-AM': S.current.rawLanguage_hy_AM,
  'id_ID': S.current.rawLanguage_id_ID,
  'it-IT': S.current.rawLanguage_it_IT,
  'ja-JP': S.current.rawLanguage_ja_JP,
  'ka-GE': S.current.rawLanguage_ka_GE,
  'kk-KZ': S.current.rawLanguage_kk_KZ,
  'ko-KR': S.current.rawLanguage_ko_KR,
  'pl-PL': S.current.rawLanguage_pl_PL,
  'pt-BR': S.current.rawLanguage_pt_BR,
  'ru-RU': S.current.rawLanguage_ru_RU,
  'sv-SV': S.current.rawLanguage_sv_SV,
  'th-TH': S.current.rawLanguage_th_TH,
  'tr-TR': S.current.rawLanguage_tr_TR,
  'tt-RU': S.current.rawLanguage_tt_RU,
  'uk-UA': S.current.rawLanguage_uk_UA,
  'zh-CN': S.current.rawLanguage_zh_CN,
  'zh-TW': S.current.rawLanguage_zh_TW,
  'la_LA': S.current.rawLanguage_la_LA,
  'no_NO': S.current.rawLanguage_no_NO,
};

String? translateLanguageById(String id) {
  return languagesTranslationById[id];
}

final Map<String, String> languagesTranslationById = {
  '00000000-0000-0000-0000-000000000001': S.current.rawLanguage_en_US,
  '00000000-0000-0000-0000-000000000007': S.current.rawLanguage_ja_JP,
  '00000000-0000-0000-0000-000000000010': S.current.rawLanguage_de_DE,
  '00000000-0000-0000-0000-000000000004': S.current.rawLanguage_es_ES,
  '00000000-0000-0000-0000-000000000009': S.current.rawLanguage_fr_FR,
  '00000000-0000-0000-0000-000000000018': S.current.rawLanguage_it_IT,
  '00000000-0000-0000-0000-000000000027': S.current.rawLanguage_la_LA,
  '00000000-0000-0000-0000-000000000017': S.current.rawLanguage_pl_PL,
  '00000000-0000-0000-0000-000000000006': S.current.rawLanguage_pt_BR,
  '00000000-0000-0000-0000-000000000011': S.current.rawLanguage_fi_FI,
  '00000000-0000-0000-0000-000000000021': S.current.rawLanguage_tr_TR,
  '00000000-0000-0000-0000-000000000028': S.current.rawLanguage_id_ID,
  '00000000-0000-0000-0000-000000000026': S.current.rawLanguage_no_NO,
  '00000000-0000-0000-0000-000000000025': S.current.rawLanguage_sv_SV,
  '00000000-0000-0000-0000-000000000002': S.current.rawLanguage_ru_RU,
  '00000000-0000-0000-0000-000000000019': S.current.rawLanguage_tt_RU,
  '00000000-0000-0000-0000-000000000020': S.current.rawLanguage_uk_UA,
  '00000000-0000-0000-0000-000000000024': S.current.rawLanguage_kk_KZ,
  '00000000-0000-0000-0000-000000000015': S.current.rawLanguage_hy_AM,
  '00000000-0000-0000-0000-000000000014': S.current.rawLanguage_he_IL,
  '00000000-0000-0000-0000-000000000023': S.current.rawLanguage_ar_AR,
  '00000000-0000-0000-0000-000000000029': S.current.rawLanguage_fa_IR,
  '00000000-0000-0000-0000-000000000005': S.current.rawLanguage_hi_IN,
  '00000000-0000-0000-0000-000000000022': S.current.rawLanguage_th_TH,
  '00000000-0000-0000-0000-000000000016': S.current.rawLanguage_ka_GE,
  '00000000-0000-0000-0000-000000000013': S.current.rawLanguage_zh_CN,
  '00000000-0000-0000-0000-000000000003': S.current.rawLanguage_zh_TW,
  '00000000-0000-0000-0000-000000000008': S.current.rawLanguage_ko_KR,
  '00000000-0000-0000-0000-000000000012': 'Саха',
  '00000000-0000-0000-0000-000000000030': S.current.rawLanguage_mnk_GN,
  '00000000-0000-0000-0000-000000000031': S.current.rawLanguage_swa_SW,
  '00000000-0000-0000-0000-000000000032': S.current.rawLanguage_kik_KI,
  '00000000-0000-0000-0000-000000000033': S.current.rawLanguage_lug_LG,
};
String? convertByIdToLocale(String id) {
  return convertLangToLocale[id];
}

final Map<String, String> convertLangToLocale = {
  '00000000-0000-0000-0000-000000000001': 'EN',
  '00000000-0000-0000-0000-000000000007': 'JA',
  '00000000-0000-0000-0000-000000000010': 'DE',
  '00000000-0000-0000-0000-000000000004': 'ES',
  '00000000-0000-0000-0000-000000000009': 'FR',
  '00000000-0000-0000-0000-000000000018': 'IT',
  '00000000-0000-0000-0000-000000000027': 'LA',
  '00000000-0000-0000-0000-000000000017': 'PL',
  '00000000-0000-0000-0000-000000000006': 'PT',
  '00000000-0000-0000-0000-000000000011': 'FI',
  '00000000-0000-0000-0000-000000000021': 'TR',
  '00000000-0000-0000-0000-000000000028': 'ID',
  '00000000-0000-0000-0000-000000000026': 'NO',
  '00000000-0000-0000-0000-000000000025': 'SV',
  '00000000-0000-0000-0000-000000000002': 'RU',
  '00000000-0000-0000-0000-000000000019': 'TT',
  '00000000-0000-0000-0000-000000000020': 'UK',
  '00000000-0000-0000-0000-000000000024': 'KK',
  '00000000-0000-0000-0000-000000000015': 'HY',
  '00000000-0000-0000-0000-000000000014': 'HE',
  '00000000-0000-0000-0000-000000000023': 'AR',
  '00000000-0000-0000-0000-000000000029': 'FA',
  '00000000-0000-0000-0000-000000000005': 'HI',
  '00000000-0000-0000-0000-000000000022': 'TH',
  '00000000-0000-0000-0000-000000000016': 'KA',
  '00000000-0000-0000-0000-000000000013': 'ZH',
  '00000000-0000-0000-0000-000000000003': 'ZH',
  '00000000-0000-0000-0000-000000000008': 'KO',
  '00000000-0000-0000-0000-000000000012': 'Саха',
  '00000000-0000-0000-0000-000000000030': 'MNK',
  '00000000-0000-0000-0000-000000000031': 'SWA',
  '00000000-0000-0000-0000-000000000032': 'KIK',
  '00000000-0000-0000-0000-000000000033': 'LUG',
};

class TranslateLanguageByIso3 {
  final Map<String, String> languagesTranslationByIso3 = {
    'deu': S.current.rawLanguage_de_DE,
    'ara': S.current.rawLanguage_ar_AR,
    'eng': S.current.rawLanguage_en_US,
    'spa': S.current.rawLanguage_es_ES,
    'fas': S.current.rawLanguage_fa_IR,
    'fin': S.current.rawLanguage_fi_FI,
    'fra': S.current.rawLanguage_fr_FR,
    'heb': S.current.rawLanguage_he_IL,
    'hin': S.current.rawLanguage_hi_IN,
    'hye': S.current.rawLanguage_hy_AM,
    'ind': S.current.rawLanguage_id_ID,
    'ita': S.current.rawLanguage_it_IT,
    'jpn': S.current.rawLanguage_ja_JP,
    'kat': S.current.rawLanguage_ka_GE,
    'kaz': S.current.rawLanguage_kk_KZ,
    'kor': S.current.rawLanguage_ko_KR,
    'pol': S.current.rawLanguage_pl_PL,
    'por': S.current.rawLanguage_pt_BR,
    'rus': S.current.rawLanguage_ru_RU,
    'swe': S.current.rawLanguage_sv_SV,
    'tha': S.current.rawLanguage_th_TH,
    'tur': S.current.rawLanguage_tr_TR,
    'tat': S.current.rawLanguage_tt_RU,
    'ukr': S.current.rawLanguage_uk_UA,
    'zho': S.current.rawLanguage_zh_CN,
    'lat': S.current.rawLanguage_la_LA,
    'nor': S.current.rawLanguage_no_NO,
  };
  String translate(String iso3) {
    return languagesTranslationByIso3[iso3] ?? '';
  }
}
