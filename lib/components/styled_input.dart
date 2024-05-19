import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_market/core/app_themes.dart';

class StyledInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final bool isDisabled;
  final bool isNumber;
  final String? Function(String?)? validatorFn;
  final void Function(String)? handleChange;
  final Widget? prefixIcon;

  const StyledInput({
    super.key,
    required this.controller,
    required this.hint,
    this.validatorFn,
    this.handleChange,
    this.isPassword = false,
    this.isDisabled = false,
    this.isNumber = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: handleChange,
      autocorrect: false,
      controller: controller,
      validator: validatorFn,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      inputFormatters: isNumber
          ? [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))]
          : [],
      obscureText: isPassword,
      enabled: !isDisabled,
      readOnly: isDisabled,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
        contentPadding: Theme.of(context).inputDecorationTheme.contentPadding,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        filled: Theme.of(context).inputDecorationTheme.filled,
        border: Theme.of(context).inputDecorationTheme.border,
        focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
        disabledBorder: Theme.of(context).inputDecorationTheme.disabledBorder,
        prefixIcon: prefixIcon,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 32,
          minHeight: 32,
        ),
      ),
      style: body,
    );
  }
}
