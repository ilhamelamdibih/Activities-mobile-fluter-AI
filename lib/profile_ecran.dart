import 'package:application_des_activites_mai/add_activite_ecran.dart';
import 'package:application_des_activites_mai/constant/colors.dart';
import 'package:application_des_activites_mai/list_activites_ecran.dart';
import 'package:application_des_activites_mai/login_ecran.dart';
import 'package:application_des_activites_mai/widget/text.form.global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ProfileEcranWidget extends StatefulWidget {
  ProfileEcranWidget(
      {super.key, required this.currentIndex, required this.email});
  int currentIndex;
  String email;
  @override
  State<ProfileEcranWidget> createState() => _ProfileEcranWidgetState();
}

class _ProfileEcranWidgetState extends State<ProfileEcranWidget> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  int verf = 0;
  TextEditingController addressController = TextEditingController();
  TextEditingController codePostalController = TextEditingController();
  TextEditingController villeController = TextEditingController();
  TextEditingController anniversaireController = TextEditingController();

  void getUserInfo() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.email)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        // ignore: avoid_print
        print(data);

        addressController.text = data["adresse"];
        villeController.text = data["ville"];
        Timestamp timestamp = data["anniversaire"];
        DateTime dateTime = timestamp.toDate();
        anniversaireController.text = DateFormat('dd/MM/yyyy').format(dateTime);
        codePostalController.text = data["codePostal"].toString();
      } else {
        // ignore: avoid_print
        print('Document n \'exist pas !!!');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error !!!! $e');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                  print("erreur de déconecter: $e");
                }
              })
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: db.collection('users').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('echeck !!!'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (verf == 0) {
              getUserInfo();
              verf = 1;
            }

            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  TextFormGlobal(
                      initialValue: widget.email,
                      text: "email",
                      textInputType: TextInputType.text,
                      obscure: false,
                      enabled: false),
                  const SizedBox(height: 20),
                  TextFormGlobal(
                      controller: addressController,
                      text: "adresse",
                      textInputType: TextInputType.text,
                      obscure: false,
                      enabled: false),
                  const SizedBox(height: 20),
                  TextFormGlobal(
                      controller: codePostalController,
                      text: "code postal",
                      textInputType: TextInputType.text,
                      obscure: false,
                      enabled: false),
                  const SizedBox(height: 20),
                  TextFormGlobal(
                      controller: villeController,
                      text: "ville",
                      textInputType: TextInputType.text,
                      obscure: false,
                      enabled: false),
                  const SizedBox(height: 20),
                  TextFormGlobal(
                      controller: anniversaireController,
                      text: "anniverssaire",
                      textInputType: TextInputType.text,
                      obscure: false,
                      enabled: false),
                ],
              ),
            );
          }),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (val) {
          setState(() {
            widget.currentIndex = val;
          });

          if (val == 0) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ListActiviteEcran(currentIndex: 0, email: widget.email);
            }));
          }
          if (val == 1) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AddActiviteEcranWidget(
                  currentIndex: 1, email: widget.email);
            }));
          }

          if (val == 2) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ProfileEcranWidget(currentIndex: 2, email: widget.email);
            }));
          }
        },
        currentIndex: widget.currentIndex,
        backgroundColor: pPrimapryColor,
        selectedItemColor: pSecondaryColor,
        unselectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.star_border_rounded), label: "Activités"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Ajouter"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_rounded), label: "Profile"),
        ],
      ),
    );
  }
}
