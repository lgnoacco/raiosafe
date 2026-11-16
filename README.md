# RaioSafe

Aplicativo de monitoramento de energia residencial, construído em Flutter.

> **Status:** MVP em desenvolvimento. Funcionalidades e telas ainda em evolução.

---

## Sobre

O RaioSafe é um app multiplataforma (Android, iOS, Web e Desktop) para
acompanhar o consumo de energia elétrica de uma residência. Este repositório
contém o código-fonte do aplicativo Flutter.

> Dica: substitua este parágrafo por uma descrição das funcionalidades reais
> do MVP (ex.: "visualização de consumo em tempo real", "histórico diário",
> "alertas de pico") conforme forem ficando prontas.

---

## Pré-requisitos

Antes de rodar, você precisa ter instalado:

- **Flutter SDK** (canal `stable`, Flutter 3.x) — guia oficial:
  https://docs.flutter.dev/get-started/install
- **Git** — https://git-scm.com/downloads
- Um destes ambientes, dependendo de onde vai rodar:
  - **Android:** Android Studio + um emulador ou um celular com depuração USB
  - **iOS:** apenas no macOS, com Xcode instalado
  - **Web:** Google Chrome
  - **Desktop:** Windows, macOS ou Linux (conforme o seu sistema)

Confirme que está tudo certo rodando:

```bash
flutter doctor
```

Resolva o que aparecer com ✗ antes de seguir.

---

## Como obter o projeto

### Opção A — Clonar com Git (recomendado)

```bash
git clone https://github.com/lgnoacco/raiosafe.git
cd raiosafe
```

Vantagem: você recebe atualizações depois com um simples `git pull`.

### Opção B — Baixar o ZIP (sem Git)

1. Acesse https://github.com/lgnoacco/raiosafe
2. Clique no botão verde **Code** → **Download ZIP**
3. Extraia o arquivo e abra a pasta `raiosafe` no terminal

---

## Instalar as dependências

Dentro da pasta do projeto:

```bash
flutter pub get
```

Isso baixa todos os pacotes listados no `pubspec.yaml`.

---

## Rodar o app

Liste os dispositivos disponíveis:

```bash
flutter devices
```

Rode no dispositivo conectado (ou no único disponível):

```bash
flutter run
```

Para escolher a plataforma explicitamente:

```bash
flutter run -d android      # Android (emulador ou celular)
flutter run -d ios          # iOS (somente no macOS)
flutter run -d chrome       # Web (Chrome)
flutter run -d windows      # Desktop Windows
flutter run -d macos        # Desktop macOS
flutter run -d linux        # Desktop Linux
```

Com o app rodando, aperte `r` no terminal para *hot reload* e `R` para
*hot restart*.

---

## Gerar build de release

| Plataforma | Comando | Saída |
|---|---|---|
| Android APK | `flutter build apk --release` | `build/app/outputs/flutter-apk/app-release.apk` |
| Android (Play Store) | `flutter build appbundle --release` | `build/app/outputs/bundle/release/app-release.aab` |
| iOS | `flutter build ios --release` | abrir em seguida no Xcode para assinar/publicar |
| Web | `flutter build web --release` | `build/web/` |
| Windows | `flutter build windows --release` | `build/windows/` |
| macOS | `flutter build macos --release` | `build/macos/` |
| Linux | `flutter build linux --release` | `build/linux/` |

> Para desktop, se o comando reclamar que a plataforma não está habilitada,
> rode uma vez: `flutter config --enable-windows-desktop`
> (troque por `macos`/`linux` conforme o caso).

---

## Estrutura do projeto

```
raiosafe/
├── lib/            # Código Dart do app (telas, lógica, widgets)
│   └── main.dart   # Ponto de entrada
├── android/        # Projeto nativo Android
├── ios/            # Projeto nativo iOS
├── web/            # Arquivos da versão Web
├── windows/ macos/ linux/   # Projetos desktop
├── test/           # Testes automatizados
└── pubspec.yaml    # Dependências e metadados do projeto
```

---

## Testes

```bash
flutter test
```

---

## Licença

Projeto privado. Todos os direitos reservados a Luis Noacco.

> Se quiser abrir o código no futuro, adicione um arquivo `LICENSE`
> (ex.: MIT) e atualize esta seção.
