# AfetRadar

Türkiye'deki son depremleri anlık olarak takip etmeyi ve afet anında en yakın toplanma alanını bulmayı sağlayan Flutter mobil uygulaması. Panik anında bilgi kirliliğini azaltmak için veriyi sade bir arayüzle sunar. Şu an Bursa'daki toplanma alanlarını (Osmangazi, Nilüfer, Mudanya) içerir.

## Özellikler

- **Canlı deprem listesi:** Kandilli Rasathanesi verileri; büyüklük, derinlik, zaman ve konum bilgisiyle
- **Deprem detayı:** Seçilen depremi Google Haritalar'da açma, AFAD'ın resmi deprem sayfasına tek tıkla gitme
- **En yakın toplanma alanları:** GPS konumuna göre Haversine formülüyle mesafe hesaplama ve en yakın alanları sıralama
- **Toplanma haritası:** Konumunu ve toplanma alanlarını harita üzerinde görme, ilçeye göre filtreleme
- **Çevrimdışı veri:** Bursa toplanma alanları uygulamanın içinde; internet olmadan da görüntülenebilir
- **Ailem:** Aile üyelerini ekleyip tek dokunuşla WhatsApp veya SMS ile "İyiyim" mesajı gönderme
- **Ayarlar:** Koyu tema, konum izni ve toplanma alanı bilgileri
- Bağlantı yoksa anlamlı uyarılar ve yükleniyor göstergeleri

## Kullanılan Teknolojiler

- **Flutter / Dart**
- **Riverpod:** durum yönetimi
- **flutter_map + latlong2:** harita
- **geolocator:** konum
- **Firebase Authentication (anonim giriş) ve Cloud Firestore:** aile listesinin saklanması
- **http:** deprem verisi (Kandilli verilerini JSON olarak sunan `api.orhanaydogdu.com.tr` API'si)
- **url_launcher:** Google Haritalar, AFAD, WhatsApp ve SMS bağlantıları

## Proje Yapısı

```
lib/
  main.dart                 Uygulama girişi, Firebase başlatma
  data/                     Osmangazi, Nilüfer ve Mudanya toplanma alanları (çevrimdışı)
  models/                   Deprem ve toplanma alanı modelleri
  providers/                Riverpod sağlayıcıları (deprem listesi, toplanma alanları)
  screens/                  Depremler, harita, toplanma haritası, Ailem, Ayarlar
  services/location_service.dart   Konum izni ve konum alma
```

## Çalıştırma

Firebase yapılandırma dosyaları güvenlik nedeniyle bu depoda yer almaz. Projeyi çalıştırmak için kendi Firebase projenizi bağlayın:

```bash
flutter pub get
dart pub global activate flutterfire_cli
flutterfire configure      # lib/firebase_options.dart ve google-services.json dosyalarını oluşturur
flutter run
```

Firebase projesinde **Anonymous** giriş yöntemi ve **Cloud Firestore** etkin olmalıdır.

## Veri Kaynakları

- Deprem verileri: Boğaziçi Üniversitesi Kandilli Rasathanesi (api.orhanaydogdu.com.tr üzerinden)
- Toplanma alanları: Osmangazi, Nilüfer ve Mudanya belediyelerinin internet sitelerinde paylaştığı veriler
