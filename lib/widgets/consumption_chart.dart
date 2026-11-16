import 'package:flutter/material.dart';

/// Mini gráfico de barras do consumo das últimas horas.
/// [valores] vai de 0.0 a 1.0 (altura relativa de cada barra).
class ConsumptionChart extends StatelessWidget {
  final List<double> valores;
  final List<String> rotulos;

  const ConsumptionChart({
    super.key,
    required this.valores,
    required this.rotulos,
  });

  @override
  Widget build(BuildContext context) {
    const alturaMaxima = 70.0;
    return Column(
      children: [
        SizedBox(
          height: alturaMaxima,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: valores.map((v) {
              final altura = (v.clamp(0.05, 1.0)) * alturaMaxima;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                width: 18,
                height: altura,
                decoration: BoxDecoration(
                  color: const Color(0xFF3F51B5),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rotulos
              .map((r) => Text(r, style: const TextStyle(fontSize: 11, color: Color(0xFF8A8F98))))
              .toList(),
        ),
      ],
    );
  }
}
