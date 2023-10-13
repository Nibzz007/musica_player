import 'package:flutter/material.dart';
import '../palettes/color_palette.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.textController,
    required this.validator,
    this.onChanged,
  });

  final String hintText;
  final IconData icon;
  final TextEditingController textController;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        onChanged: onChanged,
        validator: validator,
        controller: textController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        style: const TextStyle(color: kBlack),
        decoration: InputDecoration(
          // prefixIcon: Icon(
          //   icon,
          //   color: kLightBlue,
          //   size: 25,
          // ),
          hintText: hintText,
          hintStyle: const TextStyle(color: kBlack
              //kLightBlue,
              ),
          filled: true,
          fillColor: kWhite,
          //const Color(0xFF153950),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 0, color: Color(0xFF153950)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 0, color: Color(0xFF153950)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 1,
              color: kBlue,
            ),
          ),
        ),
      ),
    );
  }
}
