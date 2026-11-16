import 'package:flutter/material.dart';

/// Representa um circuito monitorado pelo RaioSafe (ex.: ar-condicionado,
/// geladeira, chuveiro...). O estado [ligado] é mutável para permitir
/// ligar/desligar pela tela de Circuitos e refletir no dashboard.
class Circuito {
  final String id;
  final String nome;
  final IconData icone;
  final double amperes;
  final double watts;
  bool ligado;

  Circuito({
    required this.id,
    required this.nome,
    required this.icone,
    required this.amperes,
    required this.watts,
    required this.ligado,
  });

  String get status => ligado ? 'Normal' : 'Em espera';

  Color get corStatus => ligado ? const Color(0xFF2E7D32) : const Color(0xFF9E9E9E);
}

/// Lista inicial de circuitos de demonstração, batendo com o painel
/// "6 de 8 circuitos ativos" mostrado no dashboard.
List<Circuito> circuitosIniciais() {
  return [
    Circuito(
      id: 'ac',
      nome: 'Ar-condicionado',
      icone: Icons.ac_unit,
      amperes: 6.2,
      watts: 1420,
      ligado: true,
    ),
    Circuito(
      id: 'geladeira',
      nome: 'Geladeira',
      icone: Icons.kitchen,
      amperes: 2.1,
      watts: 480,
      ligado: true,
    ),
    Circuito(
      id: 'chuveiro',
      nome: 'Chuveiro elétrico',
      icone: Icons.shower,
      amperes: 18.0,
      watts: 5400,
      ligado: false,
    ),
    Circuito(
      id: 'iluminacao',
      nome: 'Iluminação da sala',
      icone: Icons.lightbulb,
      amperes: 0.8,
      watts: 120,
      ligado: true,
    ),
    Circuito(
      id: 'tv',
      nome: 'TV e home theater',
      icone: Icons.tv,
      amperes: 1.2,
      watts: 220,
      ligado: true,
    ),
    Circuito(
      id: 'lavadora',
      nome: 'Máquina de lavar',
      icone: Icons.local_laundry_service,
      amperes: 9.5,
      watts: 1900,
      ligado: false,
    ),
    Circuito(
      id: 'bomba',
      nome: "Bomba d'água",
      icone: Icons.water_drop,
      amperes: 4.0,
      watts: 750,
      ligado: true,
    ),
    Circuito(
      id: 'carregador',
      nome: 'Carregador veicular',
      icone: Icons.ev_station,
      amperes: 32.0,
      watts: 7000,
      ligado: false,
    ),
  ];
}
