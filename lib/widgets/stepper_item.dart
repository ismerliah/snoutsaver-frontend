import 'package:flutter/material.dart';

class StepperItem extends StatelessWidget {
  final int stepNumber;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const StepperItem({
    super.key,
    required this.stepNumber,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive || isCompleted
                  ? const Color(0xFFFF90BC)
                  : Colors.grey.shade500,
              width: 2.0,
            ),
          ),
          child: CircleAvatar(
            radius: 15,
            backgroundColor:
                isCompleted ? const Color(0xFFFF90BC) : Colors.white,
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                : Text(
                    '$stepNumber',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isActive
                          ? const Color(0xFFFF90BC)
                          : Colors.grey.shade700,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),

        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isActive || isCompleted ? const Color(0xFFFF90BC) : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
