import '../models/usuario.dart';

/// Serviço de autenticação simples, em memória (sem backend).
/// Guarda os usuários cadastrados durante a execução do app e controla
/// quem está logado no momento. Troque por uma API real quando quiser.
class AuthService {
  AuthService._interno();
  static final AuthService instancia = AuthService._interno();

  final Map<String, Usuario> _usuarios = {};
  Usuario? usuarioLogado;

  /// Conta de demonstração já pré-cadastrada, para testar o login sem
  /// precisar passar pela tela de cadastro.
  void _seedDemo() {
    if (_usuarios.containsKey('sonia@raiosafe.com')) return;
    _usuarios['sonia@raiosafe.com'] = const Usuario(
      nome: 'Sônia Pereira',
      email: 'sonia@raiosafe.com',
      senha: '123456',
    );
  }

  void iniciar() => _seedDemo();

  bool emailJaCadastrado(String email) {
    return _usuarios.containsKey(email.trim().toLowerCase());
  }

  /// Retorna null em caso de sucesso, ou uma mensagem de erro.
  String? cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) {
    final emailNormalizado = email.trim().toLowerCase();
    if (emailJaCadastrado(emailNormalizado)) {
      return 'Já existe uma conta com este e-mail.';
    }
    _usuarios[emailNormalizado] = Usuario(
      nome: nome.trim(),
      email: emailNormalizado,
      senha: senha,
    );
    usuarioLogado = _usuarios[emailNormalizado];
    return null;
  }

  /// Retorna null em caso de sucesso, ou uma mensagem de erro.
  String? login({required String email, required String senha}) {
    final emailNormalizado = email.trim().toLowerCase();
    final usuario = _usuarios[emailNormalizado];
    if (usuario == null) {
      return 'Nenhuma conta encontrada com este e-mail.';
    }
    if (usuario.senha != senha) {
      return 'Senha incorreta.';
    }
    usuarioLogado = usuario;
    return null;
  }

  /// Atualiza nome/e-mail do usuário logado.
  /// Retorna null em caso de sucesso, ou uma mensagem de erro.
  String? atualizarPerfil({required String nome, required String email}) {
    final atual = usuarioLogado;
    if (atual == null) return 'Nenhum usuário logado.';

    final novoEmail = email.trim().toLowerCase();
    if (novoEmail != atual.email && emailJaCadastrado(novoEmail)) {
      return 'Já existe uma conta com este e-mail.';
    }

    final atualizado = Usuario(nome: nome.trim(), email: novoEmail, senha: atual.senha);
    _usuarios.remove(atual.email);
    _usuarios[novoEmail] = atualizado;
    usuarioLogado = atualizado;
    return null;
  }

  void sair() {
    usuarioLogado = null;
  }
}
