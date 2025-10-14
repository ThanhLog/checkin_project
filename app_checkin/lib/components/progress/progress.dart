import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  final List<Map<String, dynamic>> progressList;
  const Progress({super.key, required this.progressList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(progressList.length * 2 - 1, (index) {
          if (index.isEven) {
            // Step item
            final stepData = progressList[index ~/ 2];
            return _itemProgress(
              stepData["done"] ?? false,
              stepData["step"].toString(),
              stepData["title"].toString(),
            );
          } else {
            // Connector line
            final prevDone = progressList[(index - 1) ~/ 2]["done"] ?? false;
            final nextDone = progressList[(index + 1) ~/ 2]["done"] ?? false;

            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: (prevDone && nextDone)
                      ? Colors.blue
                      : Colors.grey[400],
                ),
              ),
            );
          }
        }),
      ),
    );
  }

  Widget _itemProgress(bool done, String step, String title) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? Colors.blue : Colors.grey,
          ),
          child: Text(
            step,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
