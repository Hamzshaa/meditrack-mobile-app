import 'package:flutter/material.dart';

class ThemeDialog extends StatelessWidget {
  const ThemeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final currentBrightness = Theme.of(context).brightness;

    return AlertDialog(
      title: const Text('Select Theme'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text('Light Theme'),
            leading: Radio<Brightness>(
              value: Brightness.light,
              groupValue: currentBrightness,
              onChanged: (Brightness? value) {
                if (value != null) _changeTheme(context, value);
                Navigator.pop(context);
              },
            ),
            onTap: () {
              _changeTheme(context, Brightness.light);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Dark Theme'),
            leading: Radio<Brightness>(
              value: Brightness.dark,
              groupValue: currentBrightness,
              onChanged: (Brightness? value) {
                if (value != null) _changeTheme(context, value);
                Navigator.pop(context);
              },
            ),
            onTap: () {
              _changeTheme(context, Brightness.dark);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void _changeTheme(BuildContext context, Brightness brightness) {
    print('Theme change requested: $brightness');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Theme switching not fully implemented yet.')));
  }
}
