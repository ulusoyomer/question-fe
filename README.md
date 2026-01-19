Frontend

Question mobil uygulaması, **Flutter** kullanılarak ve **Clean Architecture** mimarisi ile geliştirilmiştir.

## 🛠 Teknoloji Yığını

*   **Framework**: Flutter (Dart)
*   **Mimari**: Clean Architecture (Presentation, Domain, Data katmanları)
*   **Durum Yönetimi (State Management)**: BLoC
*   **Navigasyon**: AutoRoute
*   **Ağ İstekleri**: Dio
*   **Bağımlılık Enjeksiyonu (DI)**: GetIt & Injectable
*   **Yerelleştirme**: Easy Localization

## 🚀 Kurulum

### Gereksinimler
*   Flutter SDK (3.x)
*   Dart SDK

### Adımlar

1.  **Paketleri Yükleyin**
    ```bash
    flutter pub get
    ```

2.  **Kod Üretimi (Code Generation)**
    Bu proje, rota yönetimi ve JSON işlemleri için `build_runner` kullanır. Bu komutu çalıştırmadan proje derlenmez.
    
    ```bash
    # Tek seferlik çalıştırma
    dart run build_runner build --delete-conflicting-outputs
    
    # Değişiklikleri izleme (Geliştirme sırasında önerilir)
    dart run build_runner watch --delete-conflicting-outputs
    ```

3.  **Uygulamayı Başlatın**
    ```bash
    flutter run
    ```

## 🏗 Proje Yapısı

```
lib/
├── core/                   # Çekirdek araçlar (Router, DI, Tema, Ağ)
├── features/               # Özellik tabanlı modüller
│   ├── history/            # Geçmiş oturumlar ve yönetimi
│   ├── home/               # Ana gösterge paneli
│   ├── interactive_studio/ # Sohbet tabanlı soru düzenleme
│   ├── pdf_workspace/      # PDF işleme ve soru üretimi
│   ├── profile/            # Kullanıcı ayarları
│   └── similar_questions/  # Style Clone (Görselden Soru Üretme)
├── shared/                 # Paylaşılan widget'lar ve modeller
├── generated/              # Otomatik üretilen dosyalar
└── main.dart               # Başlangıç noktası
```

## 🔑 Önemli Özellik Uygulamaları

*   **Style Clone**: 
    - Kullanıcıdan fotoğraf/ekran görüntüsü alır.
    - Orijinal ve üretilen soruları görselleriyle listeler.
    - `SimilarQuestionsBloc` durum yönetimini sağlar.
*   **Interactive Studio**:
    - Soruları düzenlemek için chat arayüzü sunar.
    - Canlı güncellemeler sağlar.
*   **PDF Workspace**:
    - PDF seçimi ve metin ayrıştırma.
    - Kart tabanlı soru gösterimi ve çevirme (flip) animasyonları.

## 📝 Dil Desteği (Localization)
Çeviriler `assets/translations/` klasöründe tutulur. Yeni bir çeviri eklemek için:
1. `en-US.json` ve `tr-TR.json` dosyalarını güncelleyin.
2. `build_runner` komutunu tekrar çalıştırın (kod üretimi için).
