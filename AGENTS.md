# AGENTS.md - Yapay Zeka Ajanları Kılavuzu

Bu kılavuz, bu projeyi geliştiren, bakımını yapan veya üzerinde yeni özellikler ekleyen Yapay Zeka Ajanları (AI Agents) için hazırlanmıştır. Projeyi daha hızlı anlamanız ve güvenli bir şekilde katkıda bulunabilmeniz için tasarlanmıştır.

---

## 1. Projenin Amacı ve Özeti

`flutter-factory`, Mason tuğlalarını (bricks) ve özel bir CLI (`flutter_factory`) aracını birleştirerek, Clean Architecture ve Feature-First yapısına uygun, üretime hazır (production-ready) Flutter uygulamalarını saniyeler içinde oluşturan bir kod üretecidir.

Temel hedefler:
- Tekrarlayan Flutter kurulum işlemlerini (klasör yapısı, state yönetimi, yönlendirme, ağ katmanı, test şablonları vb.) otomatikleştirerek hız kazandırmak.
- Ekiplerin standart, tahmin edilebilir ve sürdürülebilir bir mimari ile projeye başlamasını sağlamak.

---

## 2. Monorepo Klasör Yapısı

Proje küçük bir monorepo yapısına sahiptir. Geliştirme yaparken dosya konumlarına dikkat edilmelidir:

- **[cli/](file:///Users/mehmetfiskindal/flutter-starter-project/cli)**: `flutter_factory` komut satırı aracının Dart kodları. Mason tuğlalarını sarmalar, parametre doğrulaması yapar ve ortam kontrollerini (`doctor`) çalıştırır.
- **[bricks/](file:///Users/mehmetfiskindal/flutter-starter-project/bricks)**: Üretimde kullanılan Mason tuğlaları. Her biri bağımsız birer şablondur (`feature`, `page`, `api_service`, `usecase`, `widget`).
- **[starter/](file:///Users/mehmetfiskindal/flutter-starter-project/starter)**: Yeni bir uygulama oluşturulduğunda (`create` komutu ile) baz alınacak Flutter şablon projesi.
- **[packages/](file:///Users/mehmetfiskindal/flutter-starter-project/packages)**: CLI, starter şablonu veya üretilen projeler tarafından paylaşılan ortak Dart/Flutter kütüphaneleri.
- **[docs/](file:///Users/mehmetfiskindal/flutter-starter-project/docs)**: Katkıda bulunanlar ve kullanıcılar için mimari, CLI ve tuğla belgeleri.
- **[mason.yaml](file:///Users/mehmetfiskindal/flutter-starter-project/mason.yaml)**: Yerel tuğlaların Mason CLI ile doğrudan kullanılabilmesi için kayıt dosyası.

---

## 3. Geliştirme Ortamı Kurulumu ve Hazırlık

Geliştirme yaparken ve testleri çalıştırırken şu adımları izlemelisiniz:

### A. Ortam Değişkenleri (Environment Variables)
CLI'ın yerel şablonları ve tuğlaları bulabilmesi için `FLUTTER_FACTORY_ROOT` ortam değişkeninin ayarlanmış olması gerekir.
```bash
export FLUTTER_FACTORY_ROOT="$(pwd)"
```

### B. Mason CLI Kurulumu ve Tuğlaları Alma
Yerel olarak tuğlaları almak ve Mason'ı hazır hale getirmek için:
```bash
dart pub global activate mason_cli
mason get
```

### C. CLI'ı Yerel Olarak Global Aktif Etme
Geliştirme yaparken CLI değişikliklerini test edebilmek için CLI paketini yerel yoldan aktif edin:
```bash
dart pub global activate -s path ./cli
```
Eğer global aktif etmeden tek seferlik çalıştırmak isterseniz:
```bash
dart run cli/bin/flutter_factory.dart <komut>
```

---

## 4. Sık Kullanılan Geliştirme ve Test Komutları

Ajanlar yaptıkları değişikliklerin doğruluğunu kontrol etmek için aşağıdaki komutları kullanmalıdır:

### CLI Testlerini Çalıştırma
CLI içindeki komut işleme ve parametre doğrulama testlerini çalıştırmak için:
```bash
cd cli
dart test
```

### Proje Doğrulama (Verify)
Değişikliklerin (özellikle `starter/` veya `bricks/` değişikliklerinin) geçerli ve derlenebilir kodlar ürettiğinden emin olmak için `verify` komutunu kullanın. Bu komut örnek kombinasyonlar üretir ve opsiyonel olarak `flutter analyze` ile kod analizi yapar:

```bash
# Hızlı doğrulama (4 temel kombinasyon üretir ve analiz eder)
flutter_factory verify

# Tüm state, backend, auth ve offline kombinasyonlarını üretir
flutter_factory verify --full

# Pub get ve analiz adımlarını atlayarak sadece kod üretimini test eder
flutter_factory verify --no-analyze
```

---

## 5. Mimari ve Kod Üretim Standartları

Üretilen Flutter uygulamaları şu standartlara kesinlikle uymalıdır:

- **Clean Architecture + Feature-First**: Kodlar katmanlar yerine özellikler (features) altında toplanır. Her özellik kendi `data`, `domain` ve `presentation` katmanlarına sahiptir.
- **State Management**: Proje Riverpod ve Bloc yapılarını destekler. Yeni şablonlar eklerken her iki durum yönetimi için de uygun yapılar sağlanmalıdır.
- **Networking**: Dio tabanlı, interceptor'lı ve hata yakalama mekanizmasına sahip bir ağ yapısı kurulmalıdır.
- **Code Generation**: Freezed ve json_serializable kullanılır. Yapılan model değişikliklerinden sonra `build_runner` kod üretiminin düzgün çalıştığından emin olunmalıdır.

---

## 6. Ajanlar İçin Altın Kurallar (Golden Rules)

1. **Dosya Değişikliklerinde Hassasiyet**: Mevcut dosyaları düzenlerken gereksiz yere tüm dosyayı ezmeyin. Sadece hedeflenen satırları değiştirmek için `replace_file_content` veya `multi_replace_file_content` araçlarını kullanın.
2. **Kırıcı Değişiklikler (Breaking Changes)**: `starter/` şablonu veya tuğla parametrelerinde yapılan değişiklikler mevcut komutları kırabilir. Değişiklik sonrasında mutlaka `flutter_factory verify --full` komutunu çalıştırarak tüm varyasyonların derlendiğini test edin.
3. **Bağımlılık Yönetimi**: `starter/pubspec.yaml` dosyasına yeni bir paket eklerken, paketin kararlı olduğundan ve hem Riverpod hem de Bloc şablonlarıyla uyumlu çalıştığından emin olun.
4. **Referanslar ve Linkler**: Yanıtlarınızda veya oluşturduğunuz dokümanlarda dosya adlarına veya kod bloklarına atıfta bulunurken mutlaka `file://` şemasına sahip tıklanabilir markdown linkleri kullanın. (Örn: [README.md](file:///Users/mehmetfiskindal/flutter-starter-project/README.md)).
5. **Gereksiz Dosya Üretmeyin**: Projenin ana dizininde geçici test çıktıları veya deneme klasörleri oluşturmaktan kaçının. Testler için işletim sisteminin geçici dizinlerini veya git tarafından yoksayılan yolları tercih edin.
