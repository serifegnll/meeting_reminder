class Veriler {
  String baslik = '';
  String konu = '';
  String mekan = '';
  String zaman = '';
  String departman = '';
  String id = '';

  VerilerEkle(String baslikYeni, String konuYeni, String mekanYeni,
      String zamanYeni, String departmanYeni, String idYeni) {
    baslik = baslikYeni;
    konu = konuYeni;
    mekan = mekanYeni;
    zaman = zamanYeni;
    departman = departmanYeni;
    id = idYeni;
  }

  tekVeriEkle(String tur, String veri) {
    if (tur == 'baslik') {
      baslik = veri;
    } else if (tur == 'konu') {
      konu = veri;
    } else if (tur == 'mekan') {
      mekan == veri;
    } else if (tur == 'zaman') {
      zaman = veri;
    } else if (tur == 'deaprtman') {
      departman = veri;
    }
  }
}
