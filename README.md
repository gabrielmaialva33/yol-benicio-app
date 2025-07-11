<div align="center">
  <br/>
  <p align="center">
    <a href="https://github.com/gabrielmaialva33/yol-benicio-app">
      <img src="https://raw.githubusercontent.com/gabrielmaialva33/yol-benicio-app/main/assets/icons/logo.svg" width="200" alt="Benicio Logo"/>
    </a>
  </p>
  <br/>
  <p align="center">
    <a href="https://flutter.dev">
      <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter"/>
    </a>
    <a href="https://dart.dev">
      <img src="https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/>
    </a>
    <a href="https://github.com/gabrielmaialva33/yol-benicio-app/blob/main/LICENSE">
      <img src="https://img.shields.io/github/license/gabrielmaialva33/yol-benicio-app?style=for-the-badge&color=582FFF" alt="License"/>
    </a>
  </p>
  <h3 align="center">Benicio</h3>
  <p align="center">
    ⚡️ Sistema jurídico moderno e intuitivo para Benício Advogados
    <br />
    <br />
    <a href="#features">Features</a>
    ·
    <a href="#tech-stack">Tech Stack</a>
    ·
    <a href="#getting-started">Getting Started</a>
  </p>
</div>

<br/>

<div align="center">
  <img src="https://raw.githubusercontent.com/gabrielmaialva33/yol-benicio-app/main/.github/assets/preview.png" alt="Benicio App Preview" width="100%">
</div>

<br/>

## ✨ Features

<table>
  <tr>
    <td align="center" width="33%">
      <img src="https://raw.githubusercontent.com/gabrielmaialva33/yol-benicio-app/main/.github/assets/responsive.svg" width="80" height="80" alt="Responsive"/>
      <br />
      <strong>Totalmente Responsivo</strong>
      <br />
      <sub>Interface adaptativa para mobile, tablet e desktop</sub>
    </td>
    <td align="center" width="33%">
      <img src="https://raw.githubusercontent.com/gabrielmaialva33/yol-benicio-app/main/.github/assets/performance.svg" width="80" height="80" alt="Performance"/>
      <br />
      <strong>Alta Performance</strong>
      <br />
      <sub>Otimizado com Flutter para experiência nativa</sub>
    </td>
    <td align="center" width="33%">
      <img src="https://raw.githubusercontent.com/gabrielmaialva33/yol-benicio-app/main/.github/assets/secure.svg" width="80" height="80" alt="Secure"/>
      <br />
      <strong>Seguro</strong>
      <br />
      <sub>Autenticação robusta e proteção de dados</sub>
    </td>
  </tr>
</table>

### 🎯 Funcionalidades Principais

- 📊 **Dashboard Inteligente** - Visualize métricas e KPIs em tempo real
- 📁 **Gestão de Pastas** - Organize processos jurídicos de forma eficiente
- 👥 **Controle de Clientes** - Gerencie informações e histórico completo
- 📈 **Relatórios Detalhados** - Análises e insights para tomada de decisão
- 🔔 **Notificações** - Fique atualizado sobre prazos e compromissos
- 🔍 **Busca Avançada** - Encontre informações rapidamente

## 🚀 Tech Stack

<div align="center">
  <table>
    <tr>
      <td align="center" width="96">
        <img src="https://www.vectorlogo.zone/logos/flutterio/flutterio-icon.svg" width="48" height="48" alt="Flutter" />
        <br>Flutter
      </td>
      <td align="center" width="96">
        <img src="https://www.vectorlogo.zone/logos/dartlang/dartlang-icon.svg" width="48" height="48" alt="Dart" />
        <br>Dart
      </td>
      <td align="center" width="96">
        <img src="https://www.vectorlogo.zone/logos/google/google-icon.svg" width="48" height="48" alt="Material" />
        <br>Material Design
      </td>
      <td align="center" width="96">
        <img src="https://raw.githubusercontent.com/gabrielmaialva33/yol-benicio-app/main/.github/assets/provider.png" width="48" height="48" alt="Provider" />
        <br>Provider
      </td>
    </tr>
  </table>
</div>

### 📦 Principais Dependências

```yaml
dependencies:
  flutter: sdk
  provider: ^6.1.2          # State Management
  google_fonts: ^6.2.1      # Typography
  flutter_svg: ^2.0.10      # SVG Support
  http: ^1.2.1              # API Calls
  shared_preferences: ^2.2.3 # Local Storage
  intl: ^0.20.2             # Internationalization
```

## 🏗️ Arquitetura

```
lib/
├── 🎯 features/           # Feature-based modules
│   ├── 🔐 auth/          # Authentication
│   ├── 📊 dashboard/     # Dashboard & widgets
│   ├── 🧭 navigation/    # App navigation
│   ├── 🔍 search/        # Search functionality
│   ├── 👤 profile/       # User profile
│   ├── 📜 history/       # History tracking
│   └── 📈 reports/       # Reports generation
├── 🎨 shared/            # Shared components
└── 🚀 main.dart          # Application entry
```

## 🛠️ Getting Started

### Pré-requisitos

Certifique-se de ter instalado:
- [Flutter](https://flutter.dev/docs/get-started/install) (3.5.4 ou superior)
- [Dart](https://dart.dev/get-dart) (3.0 ou superior)
- Um editor de código ([VS Code](https://code.visualstudio.com/) ou [Android Studio](https://developer.android.com/studio))

### 📥 Instalação

```bash
# Clone o repositório
git clone https://github.com/gabrielmaialva33/yol-benicio-app.git

# Entre no diretório
cd yol-benicio-app

# Instale as dependências
flutter pub get

# Execute o app
flutter run
```

### 🏃‍♂️ Scripts Disponíveis

```bash
# Desenvolvimento
flutter run                    # Executa em modo debug
flutter run --release         # Executa em modo release

# Build
flutter build apk            # Build APK para Android
flutter build ios            # Build para iOS
flutter build web            # Build para Web

# Testes
flutter test                 # Executa os testes
flutter analyze             # Análise estática do código

# Outros
flutter clean               # Limpa arquivos de build
flutter doctor             # Verifica configuração do ambiente
```

## 🎨 Customização

### Temas e Cores

O app utiliza um sistema de cores personalizável:

```dart
// Cor primária
const primaryColor = Color(0xFF582FFF);  // Roxo vibrante

// Cor secundária  
const secondaryColor = Color(0xFF1F2A37); // Azul escuro

// Cores de status
const successColor = Color(0xFF22C55E);   // Verde
const warningColor = Color(0xFFF59E0B);   // Amarelo
const errorColor = Color(0xFFEF4444);     // Vermelho
```

### Fontes

Utilizamos Google Fonts para tipografia consistente:
- **Inter** - Interface principal
- **Work Sans** - Elementos específicos
- **Montserrat** - Títulos e destaques

## 📱 Screenshots

<div align="center">
  <table>
    <tr>
      <td><img src="https://raw.githubusercontent.com/gabrielmaialva33/yol-benicio-app/main/.github/assets/screenshots/login.png" alt="Login" width="200"/></td>
      <td><img src="https://raw.githubusercontent.com/gabrielmaialva33/yol-benicio-app/main/.github/assets/screenshots/dashboard.png" alt="Dashboard" width="200"/></td>
      <td><img src="https://raw.githubusercontent.com/gabrielmaialva33/yol-benicio-app/main/.github/assets/screenshots/folders.png" alt="Folders" width="200"/></td>
      <td><img src="https://raw.githubusercontent.com/gabrielmaialva33/yol-benicio-app/main/.github/assets/screenshots/profile.png" alt="Profile" width="200"/></td>
    </tr>
  </table>
</div>

## 🤝 Contribuindo

Contribuições são sempre bem-vindas! Por favor, leia o [guia de contribuição](CONTRIBUTING.md) primeiro.

1. Fork o projeto
2. Crie sua feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 🙏 Agradecimentos

- [Flutter Team](https://flutter.dev/) pela incrível framework
- [Benício Advogados](https://benicio.com.br) pela confiança no projeto
- Todos os [contribuidores](https://github.com/gabrielmaialva33/yol-benicio-app/graphs/contributors)

## 📞 Contato

<div align="center">
  
  [![LinkedIn](https://img.shields.io/badge/LinkedIn-%230077B5.svg?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/gabrielmaialva33)
  [![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/gabrielmaialva33)
  [![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:gabriel.maia@benicio.com.br)

</div>

---

<div align="center">
  <sub>Built with 💜 by <a href="https://github.com/gabrielmaialva33">Gabriel Maia</a></sub>
</div>
