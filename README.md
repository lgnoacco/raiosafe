# RaioSafe

Monitoramento inteligente de energia residencial — dashboard em tempo real, controle de circuitos e alertas, construído em Flutter.

## Funcionalidades

- **Login e cadastro** com validação de formulário
- **Dashboard** com consumo em tempo real (kW), corrente total e circuitos ativos
- **Circuitos** monitorados individualmente (corrente, potência, status)
- **Alertas** com possibilidade de descarte
- **Ajustes** de perfil e notificações

> Por enquanto os dados do dashboard são simulados. A ideia é integrar com sensores reais (ESP32 + sensores de corrente) futuramente.

## Como rodar

```bash
flutter pub get
flutter run
```

### Conta de demonstração

Pra testar o login sem precisar cadastrar uma conta nova:

- **E-mail:** `sonia@raiosafe.com`
- **Senha:** `123456`

Ou crie uma conta própria pela tela de cadastro.

## Estrutura do projeto

```
lib/
  main.dart              # ponto de entrada do app
  models/                # Circuito, Alerta, Usuario
  services/              # AuthService (autenticação em memória)
  screens/               # Login, Cadastro, Dashboard, Editar perfil
  widgets/                # componentes reutilizáveis do dashboard
```

## Stack

- Flutter / Dart
- Sem dependências externas além do SDK (autenticação e estado em memória)
