import 'package:flutter/material.dart';

import '../../Constants/colors.dart';
import '../controller/growth_controller.dart';

Future<dynamic> customisePopUp(
    BuildContext context, GrowthController provider) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Customised days'),
      content: TextFormField(
        controller: provider.daysController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: 'Enter number of days',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: redColor,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            provider.selectDuration();

            Navigator.of(context).pop();
          },
          child: const Text(
            'Filter',
            style: TextStyle(
              color: blueAccentColor,
            ),
          ),
        ),
      ],
    ),
  );
}
