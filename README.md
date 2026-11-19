# FastLocation

Aplicativo Flutter (Android/iOS) da FastDelivery para consulta de endereço por CEP e busca de CEP por endereço (completo ou parcial), usando a API pública [ViaCEP](https://viacep.com.br).

## Funcionalidades

- Consulta por CEP (máscara 00000-000) e busca por UF + cidade + logradouro.
- Tela de loading durante a consulta externa.
- Componente de "nenhum resultado encontrado".
- Armazenamento local (Hive) das consultas, com tela de histórico.
- Último endereço consultado em destaque, com ação **Traçar rota** (geocoding + app de mapas instalado, partindo da localização atual).
- Estado reativo com MobX (`Observer` + `reaction` para erros).

## Arquitetura (`lib/src`)

```
shared/   colors, components, metrics, storage (Hive)
routes/   nomes das rotas
http/     configuração do Dio
modules/
  initial/page          splash animada -> home
  home/                 components, controller, model, page, repositories, service
  history/              controller, page
```

## Como executar

Requisitos: Flutter **3.3 – 3.7** (Dart 2.17–2.19), pois as versões das libs seguem as exigidas no desafio (dio 4, mobx 2, etc.).

```powershell
# 1. Gera as pastas android/ e ios/ (mantém lib/, pubspec e test/)
flutter create . --platforms=android,ios --project-name fastlocation

# 2. Dependências
flutter pub get

# 3. (Opcional) Regenera os arquivos *.g.dart; já estão versionados
dart run build_runner build --delete-conflicting-outputs

# 4. Testes e execução
flutter test
flutter run
```

### Configurações de plataforma

**Android** — em `android/app/src/main/AndroidManifest.xml`, antes de `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

e, para detectar apps de mapas (Android 11+), dentro de `<manifest>`:

```xml
<queries>
  <intent><action android:name="android.intent.action.VIEW"/><data android:scheme="geo"/></intent>
  <intent><action android:name="android.intent.action.VIEW"/><data android:scheme="https"/></intent>
</queries>
```

**iOS** — em `ios/Runner/Info.plist`:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>comgooglemaps</string>
  <string>waze</string>
</array>
```
