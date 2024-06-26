import 'package:barber_shop/src/core/ui/widgets/schedule_card.dart';
import 'package:flutter/material.dart';

class HoursPanel extends StatelessWidget {
  final void Function(String) onChangeValue;
  final Map<String, int?> selectedHours;
  const HoursPanel(
      {required this.selectedHours, required this.onChangeValue, super.key});

  @override
  Widget build(BuildContext context) {
    const hours = [
      "08:00",
      "09:00",
      "10:00",
      "11:00",
      "12:00",
      "13:00",
      "14:00",
      "15:00",
      "16:00",
      "17:00",
      "18:00",
      "19:00",
      "20:00",
      "21:00",
      "22:00",
    ];

    return Column(children: [
      const SizedBox(height: 16),
      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Selecione os horários de atendimento',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      const SizedBox(height: 8),
      GridView.builder(
        itemCount: hours.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: hours.length ~/ 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 24,
        ),
        itemBuilder: (context, index) {
          final hour = hours[index];
          return BarbershopScheduleButton(
            label: hour,
            onChangeValue: onChangeValue,
          );
        },
      ),
    ]);
  }
}
