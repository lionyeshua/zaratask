import 'package:flutter/material.dart';

class Material3TextFormField extends StatelessWidget {
  const Material3TextFormField({
    required this.labelText,
    required this.textEditingController,
    this.autocorrect = true,
    this.autofillHints = const <String>[],
    this.autofocus = false,
    this.iconData,
    this.keyboardType,
    this.maxLength,
    this.validator,
    super.key,
  });

  final bool autocorrect;
  final Iterable<String>? autofillHints;
  final bool autofocus;
  final IconData? iconData;
  final TextInputType? keyboardType;
  final String labelText;
  final int? maxLength;
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Without this padding, the top of the floating label is cut off.
      padding: const EdgeInsets.only(top: 4),
      child: TextFormField(
        autocorrect: autocorrect,
        autofillHints: autofillHints,
        autofocus: autofocus,
        controller: textEditingController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          errorBorder: const OutlineInputBorder(),
          icon: iconData != null ? Icon(iconData) : null,
          labelText: labelText,
        ),
        keyboardType: keyboardType,
        maxLength: maxLength,
        validator: validator,
      ),
    );
  }
}
