class Usuario {
  final String nome;
  final String email;
  final String senha;

  const Usuario({
    required this.nome,
    required this.email,
    required this.senha,
  });

  /// Primeiro nome, usado na saudação do dashboard ("Bom dia, Sônia").
  String get primeiroNome {
    final partes = nome.trim().split(' ');
    return partes.isNotEmpty ? partes.first : nome;
  }
}
