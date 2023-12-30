import 'dart:io';
import 'package:application_des_activites_mai/constant/colors.dart';
import 'package:application_des_activites_mai/list_activites_ecran.dart';
import 'package:application_des_activites_mai/login_ecran.dart';
import 'package:application_des_activites_mai/model/activite.dart';
import 'package:application_des_activites_mai/profile_ecran.dart';
import 'package:application_des_activites_mai/widget/material.button.global.dart';
import 'package:application_des_activites_mai/widget/text.form.global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

// ignore: must_be_immutable
class AddActiviteEcranWidget extends StatefulWidget {
  AddActiviteEcranWidget(
      {super.key, required this.currentIndex, required this.email});
  int currentIndex;
  String email;

  @override
  State<AddActiviteEcranWidget> createState() => _AddActiviteEcranWidgetState();
}

class _AddActiviteEcranWidgetState extends State<AddActiviteEcranWidget> {
  
  TextEditingController categoryController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController lieuController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController nbrPersonMinController = TextEditingController();
  TextEditingController prixController = TextEditingController();


  final CollectionReference _activiteCollection =
      FirebaseFirestore.instance.collection('activite');

  XFile? _image;
  File? file;
  String? url;

  // ignore: prefer_typing_uninitialized_variables
  var _recognitions;
  var imageName="";
  var category = "";
  


  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  loadmodel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future<void> getImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? imageGallery =
          await picker.pickImage(source: ImageSource.gallery);
      if (imageGallery != null) {
        setState(() {
          _image = imageGallery;
          file = File(imageGallery.path);
        });
        detectimage(file!);

        imageName = basename(imageGallery.path);
      }
      setState(() {});
    } catch (e) {
      // ignore: avoid_print
      print('image erreur !!! : $e');
    }
  }

  Future detectimage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions;

      category = _recognitions[0]['label'];

      category = category.replaceAll(RegExp(r'^\s*\d+(\.\d+)?\s*'), '');

      categoryController.text = category;
    });
  }

  Future<void> _ajouterActivite() async {
    try {
      DocumentReference documentReference = _activiteCollection.doc();

      String titre = titleController.text;
      String lieu = lieuController.text;
      String categorie = categoryController.text;
      double prix = double.parse(prixController.text);
      int nbrPersonMin = int.parse(nbrPersonMinController.text) ;

      var refStorage = FirebaseStorage.instance
          .ref('$imageName-${DateTime.now().millisecondsSinceEpoch}');
      await refStorage.putFile(file!);
      url = await refStorage.getDownloadURL();

      Activite nouveauActivite = Activite(
        id: documentReference.id,
          titre : titre,
          lieu : lieu,
          categorie : categorie,
          prix : prix,
          image : url.toString(),
          nbrPersonMin : nbrPersonMin,
      );

      await documentReference.set(nouveauActivite.toJson());
      titleController.clear();
      lieuController.clear();
      categoryController.clear();
      prixController.clear();
      nbrPersonMinController.clear();
      setState(() {
        _image = null; 
      });
        } catch (e) {
       // ignore: avoid_print
       print('Erreur lors de l\'ajout de l\'activité : $e');
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return ListActiviteEcran(
                      currentIndex: 0, email: widget.email);
                },
              ),
            );
          },
        ),
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
                    print("Error signing out: $e");
                  }
                })
          ],
      ),

      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
          child: Center(
            child: Column(children: [
              const SizedBox(height: 20),
              TextFormGlobal(
                controller: titleController,
                text: "Titre",
                textInputType: TextInputType.text,
                obscure: false,
                enabled: true,
              ),
              const SizedBox(height: 20),
              TextFormGlobal(
                controller: lieuController,
                text: "Lieu",
                textInputType: TextInputType.text,
                obscure: false,
                enabled: true,
              ),
              const SizedBox(height: 20),
              TextFormGlobal(
                  controller: nbrPersonMinController,
                  text: "Nombre minimum des personnes",
                  textInputType: TextInputType.number,
                  obscure: false,
                  enabled: true),
              const SizedBox(height: 20),
              TextFormGlobal(
                controller: prixController,
                text: "Prix",
                textInputType: TextInputType.number,
                obscure: false,
                enabled: true,
              ),
              const SizedBox(height: 20),
              Column(
                children: <Widget>[
                  if (_image != null)
                    Image.file(
                      File(_image!.path),
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    )
                  else
                    const Text("Aucun image selectionner"),
                  ElevatedButton(
                    onPressed: getImage,
                    child: const Text('importe image'),
                  ),
                ],
              ),
              TextFormGlobal(
                controller: categoryController,
                text: "Categorie",
                textInputType: TextInputType.text,
                obscure: false,
                enabled: false,
              ),
              const SizedBox(height: 20),
              MaterialButtonGlobal(
                  text: "Ajouter",
                  textColor: Colors.white,
                  buttonColor: pPrimapryColor,
                  onPressed:_ajouterActivite),
            ]),
          ),
        ),
      ),
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
