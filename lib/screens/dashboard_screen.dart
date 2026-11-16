import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/alerta.dart';
import '../models/circuito.dart';
import '../services/auth_service.dart';
import '../widgets/circuit_tile.dart';
import '../widgets/consumption_chart.dart';
import '../widgets/stat_card.dart';
import 'login_screen.dart';
import 'edit_profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _abaSelecionada = 0;
  bool _sistemaOnline = true;

  late List<Circuito> _circuitos;
  late List<Alerta> _alertas;
  late List<double> _barras;

  double _kw = 2.84;
  double _correnteTotal = 12.4;

  bool _notificacoesPush = true;
  bool _alertasEmail = false;

  Timer? _timer;
  final _random = Random();
  bool _carregandoInicial = true;

  @override
  void initState() {
    super.initState();
    _circuitos = circuitosIniciais();
    _alertas = alertasIniciais();
    _barras = [0.4, 0.6, 0.5, 0.8, 0.55, 0.95, 0.7];
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _atualizarLeituras());

    // Pequeno atraso simulando o carregamento inicial dos dados do
    // dispositivo, pra não "piscar" a tela cheia de números de cara.
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _carregandoInicial = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get _circuitosAtivos => _circuitos.where((c) => c.ligado).length;

  void _atualizarLeituras() {
    if (!_sistemaOnline || !mounted) return;
    setState(() {
      final somaAmperes = _circuitos.where((c) => c.ligado).fold<double>(0, (soma, c) => soma + c.amperes);
      final jitter = (_random.nextDouble() - 0.5) * 0.6;
      _correnteTotal = (somaAmperes + jitter).clamp(0, 60);
      _kw = (_correnteTotal * 220 / 1000).clamp(0, 20);

      _barras = _barras.map((v) {
        final novo = v + (_random.nextDouble() - 0.5) * 0.25;
        return novo.clamp(0.15, 1.0);
      }).toList();
    });
  }

  Future<void> _atualizarManualmente() async {
    await Future.delayed(const Duration(milliseconds: 700));
    _atualizarLeituras();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dados atualizados.'), duration: Duration(seconds: 1)),
    );
  }

  void _alternarSistema() {
    setState(() => _sistemaOnline = !_sistemaOnline);
  }

  void _removerAlerta(Alerta alerta) {
    setState(() => _alertas.removeWhere((a) => a.id == alerta.id));
  }

  void _sair() {
    AuthService.instancia.sair();
    _timer?.cancel();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_carregandoInicial) {
      return const Scaffold(
        backgroundColor: Color(0xFFF2F3F7),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Color(0xFF263238)),
              SizedBox(height: 16),
              Text('Carregando seus dados...', style: TextStyle(color: Color(0xFF8A8F98))),
            ],
          ),
        ),
      );
    }

    final usuario = AuthService.instancia.usuarioLogado;
    final nome = usuario?.primeiroNome ?? 'visitante';

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_saudacao()}, $nome',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Seu ambiente está sendo monitorado.',
                          style: TextStyle(fontSize: 13, color: Color(0xFF8A8F98)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _sair,
                    icon: const Icon(Icons.logout, color: Color(0xFF8A8F98)),
                    tooltip: 'Sair',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _abaBotao('Início', 0),
                  const SizedBox(width: 8),
                  _abaBotao('Circuitos', 1),
                  const SizedBox(width: 8),
                  _abaBotao('Alertas', 2),
                  const SizedBox(width: 8),
                  _abaBotao('Ajustes', 3),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: IndexedStack(
                index: _abaSelecionada,
                children: [
                  _abaInicio(),
                  _abaCircuitos(),
                  _abaAlertas(),
                  _abaAjustes(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _saudacao() {
    final hora = DateTime.now().hour;
    if (hora < 12) return 'Bom dia';
    if (hora < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  Widget _abaBotao(String texto, int indice) {
    final selecionada = _abaSelecionada == indice;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _abaSelecionada = indice),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selecionada ? const Color(0xFF263238) : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            texto,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selecionada ? Colors.white : const Color(0xFF8A8F98),
            ),
          ),
        ),
      ),
    );
  }

  Widget _abaInicio() {
    return RefreshIndicator(
      onRefresh: _atualizarManualmente,
      color: const Color(0xFF263238),
      child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      children: [
        _cardStatusSistema(),
        const SizedBox(height: 16),
        _cardConsumo(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatCard(
                legenda: 'CORRENTE TOTAL',
                valor: '${_correnteTotal.toStringAsFixed(1).replaceAll('.', ',')} A',
                rodape: 'Limite configurado: 40 A',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                legenda: 'CIRCUITOS ATIVOS',
                valor: '$_circuitosAtivos de ${_circuitos.length}',
                rodape: '${_circuitos.length - _circuitosAtivos} em espera',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Circuitos em destaque',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
        ),
        const SizedBox(height: 10),
        ..._circuitos.take(2).map((c) => CircuitTile(circuito: c)),
        TextButton(
          onPressed: () => setState(() => _abaSelecionada = 1),
          child: const Text('Ver todos os circuitos'),
        ),
      ],
      ),
    );
  }

  Widget _cardStatusSistema() {
    final online = _sistemaOnline;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: online ? const Color(0xFFE6F7EC) : const Color(0xFFFDECEC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            online ? Icons.check_circle : Icons.error_outline,
            color: online ? const Color(0xFF2E7D32) : const Color(0xFFE53935),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  online ? 'Sistema protegido' : 'Sistema desprotegido',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
                ),
                Text(
                  online ? 'Circuitos dentro dos limites configurados' : 'Monitoramento em tempo real pausado',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF8A8F98)),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _alternarSistema,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: online ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                online ? 'ONLINE' : 'OFFLINE',
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardConsumo() {
    final delta = _sistemaOnline ? '↑ 8% em relação à última hora' : 'Sem leitura — sistema offline';
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Consumo em tempo real', style: TextStyle(fontSize: 12, color: Color(0xFF8A8F98))),
          const SizedBox(height: 6),
          Text(
            '${_kw.toStringAsFixed(2).replaceAll('.', ',')} kW',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
          ),
          const SizedBox(height: 4),
          Text(delta, style: const TextStyle(fontSize: 12, color: Color(0xFF2E7D32))),
          const SizedBox(height: 16),
          const Text(
            'POTÊNCIA TOTAL · ÚLTIMAS 6 HORAS',
            style: TextStyle(fontSize: 10, color: Color(0xFF8A8F98), letterSpacing: 0.4),
          ),
          const SizedBox(height: 10),
          ConsumptionChart(valores: _barras, rotulos: const ['9h', '11h', '13h', '15h', '17h', '19h', '21h']),
        ],
      ),
    );
  }

  Widget _abaCircuitos() {
    return RefreshIndicator(
      onRefresh: _atualizarManualmente,
      color: const Color(0xFF263238),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          Text(
            '$_circuitosAtivos de ${_circuitos.length} circuitos ligados agora',
            style: const TextStyle(fontSize: 13, color: Color(0xFF8A8F98)),
          ),
          const SizedBox(height: 12),
          ..._circuitos.map((circuito) => CircuitTile(circuito: circuito)),
        ],
      ),
    );
  }

  Widget _abaAlertas() {
    if (_alertas.isEmpty) {
      return const Center(
        child: Text('Nenhum alerta no momento 🎉', style: TextStyle(color: Color(0xFF8A8F98))),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      children: _alertas
          .map(
            (a) => Dismissible(
              key: ValueKey(a.id),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => _removerAlerta(a),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(color: const Color(0xFFE53935), borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.delete_outline, color: Colors.white),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(a.icone, color: a.cor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.titulo, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text(a.descricao, style: const TextStyle(fontSize: 12, color: Color(0xFF8A8F98))),
                          const SizedBox(height: 6),
                          Text(a.horario, style: const TextStyle(fontSize: 10, color: Color(0xFFB0B4BB))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _abaAjustes() {
    final usuario = AuthService.instancia.usuarioLogado;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const EditProfileScreen()),
            );
            setState(() {});
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                const CircleAvatar(radius: 24, backgroundColor: Color(0xFF263238), child: Icon(Icons.person, color: Colors.white)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(usuario?.nome ?? 'Visitante', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      Text(usuario?.email ?? '-', style: const TextStyle(fontSize: 12, color: Color(0xFF8A8F98))),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF8A8F98)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _ajusteSwitch(
          titulo: 'Notificações push',
          subtitulo: 'Receber alertas em tempo real no celular',
          valor: _notificacoesPush,
          onChanged: (v) => setState(() => _notificacoesPush = v),
        ),
        _ajusteSwitch(
          titulo: 'Alertas por e-mail',
          subtitulo: 'Resumo diário enviado para seu e-mail',
          valor: _alertasEmail,
          onChanged: (v) => setState(() => _alertasEmail = v),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: _sair,
          icon: const Icon(Icons.logout, color: Color(0xFFE53935)),
          label: const Text('Sair da conta', style: TextStyle(color: Color(0xFFE53935))),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: Color(0xFFE53935)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }

  Widget _ajusteSwitch({
    required String titulo,
    required String subtitulo,
    required bool valor,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: SwitchListTile(
        value: valor,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFF4CAF50),
        title: Text(titulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitulo, style: const TextStyle(fontSize: 11, color: Color(0xFF8A8F98))),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
