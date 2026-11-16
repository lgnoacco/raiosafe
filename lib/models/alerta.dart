import 'package:flutter/material.dart';

enum SeveridadeAlerta { info, atencao, critico }

class Alerta {
  final String id;
  final String titulo;
  final String descricao;
  final String horario;
  final SeveridadeAlerta severidade;

  const Alerta({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.horario,
    required this.severidade,
  });

  Color get cor {
    switch (severidade) {
      case SeveridadeAlerta.critico:
        return const Color(0xFFE53935);
      case SeveridadeAlerta.atencao:
        return const Color(0xFFFF9800);
      case SeveridadeAlerta.info:
        return const Color(0xFF3F51B5);
    }
  }

  IconData get icone {
    switch (severidade) {
      case SeveridadeAlerta.critico:
        return Icons.warning_amber_rounded;
      case SeveridadeAlerta.atencao:
        return Icons.notifications_active_outlined;
      case SeveridadeAlerta.info:
        return Icons.info_outline;
    }
  }
}

List<Alerta> alertasIniciais() {
  return const [
    Alerta(
      id: 'a1',
      titulo: 'Pico de consumo detectado',
      descricao: 'O consumo total ultrapassou 3,2 kW às 14:32.',
      horario: 'Hoje, 14:32',
      severidade: SeveridadeAlerta.atencao,
    ),
    Alerta(
      id: 'a2',
      titulo: 'Chuveiro acima do normal',
      descricao: 'Corrente de 18A é próxima do limite do circuito.',
      horario: 'Hoje, 09:15',
      severidade: SeveridadeAlerta.critico,
    ),
    Alerta(
      id: 'a3',
      titulo: 'Atualização concluída',
      descricao: 'O firmware do dispositivo RaioSafe foi atualizado.',
      horario: 'Ontem, 22:04',
      severidade: SeveridadeAlerta.info,
    ),
  ];
}
