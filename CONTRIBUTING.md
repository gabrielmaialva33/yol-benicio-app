# Guia de Contribuição - YOL App

Obrigado por considerar contribuir para o YOL App! 🎉

## 📋 Índice

- [Código de Conduta](#código-de-conduta)
- [Como Contribuir](#como-contribuir)
- [Reportando Bugs](#reportando-bugs)
- [Sugerindo Melhorias](#sugerindo-melhorias)
- [Pull Requests](#pull-requests)
- [Padrões de Código](#padrões-de-código)
- [Convenções de Commit](#convenções-de-commit)

## 📜 Código de Conduta

Este projeto adota um código de conduta para garantir um ambiente acolhedor para todos. Por favor, leia e siga nosso [Código de Conduta](CODE_OF_CONDUCT.md).

## 🤝 Como Contribuir

1. **Fork o repositório**
   ```bash
   git clone https://github.com/seu-usuario/yolapp.git
   cd yolapp
   ```

2. **Crie uma branch para sua feature**
   ```bash
   git checkout -b feature/minha-nova-feature
   ```

3. **Faça suas alterações**
   - Escreva código limpo e bem documentado
   - Adicione testes quando necessário
   - Atualize a documentação

4. **Teste suas alterações**
   ```bash
   flutter test
   flutter analyze
   ```

5. **Commit suas mudanças**
   ```bash
   git commit -m "feat: adiciona nova funcionalidade X"
   ```

6. **Push para seu fork**
   ```bash
   git push origin feature/minha-nova-feature
   ```

7. **Abra um Pull Request**

## 🐛 Reportando Bugs

Antes de reportar um bug, certifique-se de:
- Verificar se o bug já não foi reportado
- Tentar reproduzir o bug na versão mais recente

### Como reportar:

1. Use o template de issue para bugs
2. Inclua:
   - Descrição clara do problema
   - Passos para reproduzir
   - Comportamento esperado vs atual
   - Screenshots (se aplicável)
   - Ambiente (OS, versão do Flutter, etc.)

## 💡 Sugerindo Melhorias

Adoramos receber sugestões! Para sugerir uma melhoria:

1. Verifique se já não existe uma issue similar
2. Use o template de feature request
3. Seja claro sobre:
   - O problema que a feature resolve
   - Como você imagina a implementação
   - Possíveis alternativas

## 🔄 Pull Requests

### Checklist antes de abrir um PR:

- [ ] Código segue os padrões do projeto
- [ ] Testes foram adicionados/atualizados
- [ ] Documentação foi atualizada
- [ ] `flutter analyze` passa sem warnings
- [ ] Todos os testes passam
- [ ] Commits seguem as convenções

### Processo de Review:

1. Um maintainer irá revisar seu PR
2. Mudanças podem ser solicitadas
3. Após aprovação, seu PR será mergeado

## 📝 Padrões de Código

### Dart/Flutter

```dart
// ✅ Bom
class UserProfile extends StatelessWidget {
  final String userName;
  final String? avatarUrl;
  
  const UserProfile({
    Key? key,
    required this.userName,
    this.avatarUrl,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      // ...
    );
  }
}

// ❌ Evitar
class userprofile extends StatelessWidget {
  String username;
  String avatar_url;
  // ...
}
```

### Diretrizes:

- Use `const` sempre que possível
- Prefira composition over inheritance
- Mantenha widgets pequenos e focados
- Use nomes descritivos para variáveis e funções
- Documente funções e classes públicas

## 📦 Convenções de Commit

Seguimos o padrão [Conventional Commits](https://www.conventionalcommits.org/):

```
<tipo>(<escopo>): <descrição>

[corpo opcional]

[rodapé opcional]
```

### Tipos:
- `feat`: Nova funcionalidade
- `fix`: Correção de bug
- `docs`: Apenas documentação
- `style`: Formatação, ponto e vírgula, etc
- `refactor`: Refatoração de código
- `test`: Adição/correção de testes
- `chore`: Tarefas de manutenção

### Exemplos:

```bash
feat(auth): adiciona autenticação biométrica

fix(dashboard): corrige cálculo de métricas

docs(readme): atualiza instruções de instalação

style: aplica formatação do dartfmt

refactor(navigation): simplifica lógica de roteamento

test(auth): adiciona testes para login service

chore(deps): atualiza dependências
```

## 🏗️ Estrutura do Projeto

```
lib/
├── features/         # Módulos por funcionalidade
│   ├── auth/        # Feature completa
│   │   ├── pages/   # Páginas/Screens
│   │   ├── widgets/ # Widgets específicos
│   │   └── services/# Lógica de negócio
│   └── ...
├── shared/          # Código compartilhado
│   ├── widgets/     # Widgets reutilizáveis
│   ├── utils/       # Funções utilitárias
│   └── constants/   # Constantes globais
└── main.dart        # Entry point
```

## 🧪 Testes

### Estrutura de testes:

```dart
void main() {
  group('UserProfile', () {
    testWidgets('should display user name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserProfile(userName: 'John Doe'),
        ),
      );
      
      expect(find.text('John Doe'), findsOneWidget);
    });
  });
}
```

### Cobertura mínima:
- Widgets críticos: 80%
- Services/Logic: 90%
- Utils: 95%

## ❓ Dúvidas?

Se tiver dúvidas:
1. Verifique a [documentação](https://github.com/gabrielmaialva33/yolapp/wiki)
2. Procure em issues existentes
3. Abra uma nova issue com a tag `question`
4. Entre em contato: gabriel.maia@benicio.com.br

---

Obrigado por contribuir! 🚀
