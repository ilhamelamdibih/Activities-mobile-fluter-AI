import 'package:application_des_activites_mai/constant/colors.dart';
import 'package:application_des_activites_mai/login_ecran.dart';
import 'package:application_des_activites_mai/model/activite.dart';
import 'package:application_des_activites_mai/widget/text.form.global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class ActiviteDetail extends StatefulWidget {
  ActiviteDetail({super.key,required this.activite});
  Activite activite;

  @override
  State<ActiviteDetail> createState() => _ActiviteDetailState();
}

class _ActiviteDetailState extends State<ActiviteDetail> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar: AppBar(
          elevation: 0,
          backgroundColor: pPrimapryColor,
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text("Activities",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                )),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.login_rounded, color: Colors.white),
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const LoginEcran();
                    }));
                  } catch (e) {
                    // ignore: avoid_print
                    print("Error signing out: $e");
                  }
                })
          ],
        ),
        
      
        body:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.network(widget.activite.image , height: 250 , width: double.infinity,),
                Text(
                      widget.activite.titre,
                      style: const TextStyle(fontSize: 17 , fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20,),
                TextFormGlobal( initialValue:  widget.activite.categorie,text: "Categorie", textInputType: TextInputType.text, obscure: false, enabled: false),
                const SizedBox(height: 20,),
                TextFormGlobal( initialValue:  widget.activite.lieu,text: "Lieu", textInputType: TextInputType.text, obscure: false, enabled: false),
                const SizedBox(height: 20,),
                TextFormGlobal( initialValue:  widget.activite.nbrPersonMin.toString(),text: "Nombre minimum des personnes", textInputType: TextInputType.text, obscure: false, enabled: false),
                const SizedBox(height: 20,),
                TextFormGlobal( initialValue:  widget.activite.prix.toString(),text: "Prix", textInputType: TextInputType.text, obscure: false, enabled: false),
                
            ]),
          ),
        )
        );
  }

}