import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum CustomInputType { text, email, password, phone }

class CustomInputField extends StatefulWidget {
  final String label;
  final String hint;
  final CustomInputType inputType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hint,
    this.inputType = CustomInputType.text,
    this.controller,
    this.validator,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    TextInputType keyboardType;
    List<TextInputFormatter>? inputFormatters;
    IconData prefixIcon;

    switch (widget.inputType) {
      case CustomInputType.email:
        keyboardType = TextInputType.emailAddress;
        prefixIcon = Icons.email;
        break;
      case CustomInputType.password:
        keyboardType = TextInputType.text;
        prefixIcon = Icons.lock;
        break;
      case CustomInputType.phone:
        keyboardType = TextInputType.phone;
        prefixIcon = Icons.phone;
        inputFormatters = [FilteringTextInputFormatter.digitsOnly];
        break;
      default:
        keyboardType = TextInputType.text;
        prefixIcon = Icons.text_fields;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: keyboardType,
          obscureText:
              widget.inputType == CustomInputType.password && _obscureText,
          inputFormatters: inputFormatters,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: Icon(prefixIcon),
            suffixIcon: widget.inputType == CustomInputType.password
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscureText = !_obscureText);
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
