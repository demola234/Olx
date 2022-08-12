import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'config.dart';

class OlxTextFormField extends StatelessWidget {
  final String? labelText;
  final String? initialValue;
  final Widget? suffixIcon;
  final TextInputType? inputType;
  final String? Function(String? input)? validator;
  final Function(String input)? onChanged;
  final Function(String?)? onSaved;
  final Function()? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final FocusNode? focusNode;
  final bool enableInteractiveSelection;
  final TextAlign textAlign;
  final String? hintText;
  final bool? obscureText;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final bool enabled;
  final bool? readOnly;
  final void Function()? onTap;

  const OlxTextFormField(
      {Key? key,
      this.labelText,
      this.initialValue,
      this.suffixIcon,
      this.inputType,
      this.onChanged,
      this.onEditingComplete,
      this.onSaved,
      this.validator,
      this.inputFormatters,
      this.maxLines = 1,
      this.focusNode,
      this.textAlign = TextAlign.start,
      this.obscureText = false,
      this.enableInteractiveSelection = true,
      this.hintText,
      this.prefixIcon,
      this.controller,
      this.readOnly = false,
      this.onTap,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onSaved: onSaved,
      onEditingComplete: onEditingComplete,
      obscureText: obscureText!,
      enableInteractiveSelection: enableInteractiveSelection,
      maxLines: maxLines,
      readOnly: readOnly!,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      initialValue: initialValue,
      keyboardType: inputType,
      textAlign: textAlign,
      enabled: enabled,
      decoration: InputDecoration(
        fillColor: const Color(0XFFF4F4F4),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: labelText,
        hintText: hintText,
        hintStyle: Config.b2(context).copyWith(
          fontWeight: FontWeight.w100,
          color: const Color(0xFF77869E),
        ),
      ),
      onChanged: onChanged,
      validator: validator,
      onTap: onTap,
    );
  }
}

class OlxMoneyTextFormField extends StatelessWidget {
  final String? labelText;
  final String? initialValue;
  final Widget? suffixIcon;
  final TextInputType? inputType;
  final String? Function(String? input)? validator;
  final Function(String input)? onChanged;
  final Function(String?)? onSaved;
  final Function()? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final FocusNode? focusNode;
  final bool enableInteractiveSelection;
  final TextAlign textAlign;
  final String? hintText;
  final bool? obscureText;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final bool enabled;
  final bool? readOnly;
  final void Function()? onTap;

  const OlxMoneyTextFormField(
      {Key? key,
      this.labelText,
      this.initialValue,
      this.suffixIcon,
      this.inputType,
      this.onChanged,
      this.onEditingComplete,
      this.onSaved,
      this.validator,
      this.inputFormatters,
      this.maxLines = 1,
      this.focusNode,
      this.textAlign = TextAlign.start,
      this.obscureText = false,
      this.enableInteractiveSelection = true,
      this.hintText,
      this.prefixIcon,
      this.controller,
      this.readOnly = false,
      this.onTap,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFEBF1F9),
              border: Border.all(color: const Color(0xFFC4D5ED)),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "₦",
                style: Config.b3(context).copyWith(
                  fontSize: 16,
                  color: const Color(0xFF24374E),
                ),
              ),
            )),
        Flexible(
          child: TextFormField(
            controller: controller,
            onSaved: onSaved,
            onEditingComplete: onEditingComplete,
            obscureText: obscureText!,
            enableInteractiveSelection: enableInteractiveSelection,
            maxLines: maxLines,
            readOnly: readOnly!,
            focusNode: focusNode,
            inputFormatters: inputFormatters,
            initialValue: initialValue,
            keyboardType: inputType,
            textAlign: textAlign,
            enabled: enabled,
            decoration: InputDecoration(
                fillColor: const Color(0xFFF6F6F6),
                filled: true,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                labelText: labelText,
                hintText: hintText,
                hintStyle: Config.b2(context).copyWith()),
            onChanged: onChanged,
            validator: validator,
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
