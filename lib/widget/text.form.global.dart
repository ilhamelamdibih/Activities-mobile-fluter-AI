import 'package:flutter/material.dart';
import 'package:application_des_activites_mai/constant/colors.dart';

class TextFormGlobal extends StatelessWidget{
   const TextFormGlobal({
    super.key,
    this.controller,
    this.initialValue,
    required this.text,
    required this.textInputType,
    required this.obscure,
    required this.enabled});

    final TextEditingController? controller ;
    final String? initialValue ;
    final String text;
    final TextInputType textInputType;
    final bool obscure;
    final bool enabled;
  
  @override
  Widget build(BuildContext context) {
     return TextFormField(

        controller: controller,
        keyboardType: textInputType,
        obscureText:obscure,
        cursorColor: pPrimapryColor,
        enabled: enabled,
        initialValue: initialValue,
        
        
        decoration: InputDecoration(
          
          contentPadding: const EdgeInsets.all(13),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: text, 
          labelStyle: const TextStyle(
            color: pPrimapryColor,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 2,
          ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: pPrimapryColor,
              width: 2,
            ),
          ),
        ),
    ); 
  }
  
}