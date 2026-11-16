import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String legenda;
  final String valor;
  final String rodape;

  const StatCard({
    super.key,
    required this.legenda,
    required this.valor,
    required this.rodape,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            legenda,
            style: const TextStyle(fontSize: 11, color: Color(0xFF8A8F98), fontWeight: FontWeight.w600, letterSpacing: 0.4),
          ),
          const SizedBox(height: 6),
          Text(
            valor,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
          ),
          const SizedBox(height: 4),
          Text(
            rodape,
            style: const TextStyle(fontSize: 11, color: Color(0xFF8A8F98)),
          ),
        ],
      ),
    );
  }
}
