import 'dart:convert';

YamlData yamlDataFromJson(String str) => YamlData.fromJson(json.decode(str));

String yamlDataToJson(YamlData data) => json.encode(data.toJson());

class YamlData {
  YamlData({
    required this.gorevAdi,
    required this.gorevAciklamasi,
    required this.gorevTarihi,
    required this.gorevSaati,
    required this.gorevDurumu,
  });

  String gorevAdi;
  String gorevAciklamasi;
  String gorevTarihi;
  String gorevSaati;
  bool gorevDurumu;

  factory YamlData.fromJson(Map<String, dynamic> json) => YamlData(
        gorevAdi: json["gorevAdi"],
        gorevAciklamasi: json["gorevAciklamasi"],
        gorevTarihi: json["gorevTarihi"],
        gorevSaati: json["gorevSaati"],
        gorevDurumu: json["gorevDurumu"],
      );

  Map<String, dynamic> toJson() => {
        "gorevAdi": gorevAdi,
        "gorevAciklamasi": gorevAciklamasi,
        "gorevTarihi": gorevTarihi,
        "gorevSaati": gorevSaati,
        "gorevDurumu": gorevDurumu,
      };
}
