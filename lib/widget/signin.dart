import 'package:application_des_activites_mai/constant/colors.dart';
import 'package:application_des_activites_mai/widget/material.button.global.dart';
import 'package:application_des_activites_mai/widget/text.form.global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

TextEditingController emailController =  TextEditingController();
TextEditingController passwordController =  TextEditingController();


class SignInWidget extends StatelessWidget {
  const SignInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: pPrimapryColor,
        title: const Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 8),
            child: Text( "Marrakech AI",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              
            )),
          ),
        centerTitle: true,
        ),
    body: SingleChildScrollView(
        
        child: SafeArea(
          child:  Container(
            margin: const EdgeInsets.symmetric(horizontal: 50),
            height: 250,
            child: Column(  
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              
              TextFormGlobal(controller:emailController , text: "Email", textInputType: TextInputType.text, obscure: false,enabled: true),
              const SizedBox(height: 20,),
              TextFormGlobal(controller:passwordController , text: "Password", textInputType: TextInputType.text, obscure: true,enabled: true),
              const SizedBox(height: 20,),
              MaterialButtonGlobal(text: "Se connecter", textColor: Colors.white, buttonColor: pPrimapryColor, 
              onPressed:  (){
              FirebaseAuth.instance.signInWithEmailAndPassword(email: 
              emailController.text, password: passwordController.text);
            },)
                
            ],),
          ),
        ),
    
      ),
    ) ; 
  }
}