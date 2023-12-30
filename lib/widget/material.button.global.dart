import 'package:flutter/material.dart';
import 'package:application_des_activites_mai/constant/colors.dart';

class MaterialButtonGlobal extends StatelessWidget{
  const MaterialButtonGlobal({
    super.key,
    required this.text,
    required this.textColor,
    required this.buttonColor, 
    required this.onPressed
    });
    final String text;
    final Color textColor;
    final Color buttonColor;
    final VoidCallback onPressed;
  
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
                          
                          onPressed:onPressed,
                          color: buttonColor,
                          textColor: textColor,
                          splashColor: pPrimapryColor,
                          minWidth: double.infinity,
                          height: 49,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(48)),
                          child: Text(
                            text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        );
  }
  
}