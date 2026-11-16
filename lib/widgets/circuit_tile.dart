import 'package:flutter/material.dart';
import '../models/circuito.dart';

/// Linha de um circuito: por enquanto só monitoramento (sem controle
/// remoto), com um indicador de status e barra de progresso
/// proporcional à corrente em relação ao limite do circuito.
class CircuitTile extends StatelessWidget {
  final Circuito circuito;
  final double limiteAmperes;

  const CircuitTile({
    super.key,
    required this.circuito,
    this.limiteAmperes = 40,
  });

  @override
  Widget build(BuildContext context) {
    final progresso = (circuito.amperes / limiteAmperes).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F3F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(circuito.icone, color: const Color(0xFF263238), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        circuito.nome,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
                      ),
                    ),
                    Text(
                      circuito.status,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: circuito.corStatus),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${circuito.amperes.toStringAsFixed(1)} A   •   ${circuito.watts.toStringAsFixed(0)} W',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF8A8F98)),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: circuito.ligado ? progresso : 0,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFE4E6EB),
                    valueColor: AlwaysStoppedAnimation(circuito.ligado ? const Color(0xFF4CAF50) : const Color(0xFF9E9E9E)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: circuito.ligado ? const Color(0xFFE6F7EC) : const Color(0xFFF2F3F7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: circuito.corStatus, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(
                  circuito.ligado ? 'Ligado' : 'Desligado',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: circuito.corStatus),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
