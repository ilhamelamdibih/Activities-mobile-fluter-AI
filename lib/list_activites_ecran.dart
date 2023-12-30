import 'package:application_des_activites_mai/add_activite_ecran.dart';
import 'package:application_des_activites_mai/constant/colors.dart';
import 'package:application_des_activites_mai/login_ecran.dart';
import 'package:application_des_activites_mai/model/activite.dart';
import 'package:application_des_activites_mai/profile_ecran.dart';
import 'package:application_des_activites_mai/widget/activite_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListActiviteEcran extends StatefulWidget {
  ListActiviteEcran(
      {super.key, required this.currentIndex, required this.email});
  String email;
  int currentIndex;
  @override
  State<ListActiviteEcran> createState() => _ListActiviteEcranState();
}

class _ListActiviteEcranState extends State<ListActiviteEcran> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Widget> listWidget = [];
  String selectedFilter = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedFilter = "tous";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
                    print("Error signing out: $e");
                  }
                })
          ],
        ),
          
        body: StreamBuilder<QuerySnapshot>(
          stream: db.collection('activite').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Une erreur est survenue'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            List<Activite> activites = snapshot.data!.docs.map((doc) {
              return Activite.fromFirestore(doc);
            }).toList();

            List<Activite> filteredData = (selectedFilter == "tous")
                ? activites
                : activites
                    .where((activity) => activity.categorie == selectedFilter)
                    .toList();

            return Column(
              children: [
                SizedBox(
                  height: 50.0,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFilter = "tous";
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedFilter == "tous"
                                  ? pPrimapryColor
                                  : Colors.white,
                              border: Border.all(color: pPrimapryColor),
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                "Tous",
                                style: TextStyle(
                                  color: selectedFilter == "tous"
                                      ? Colors.white
                                      : pPrimapryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFilter = "équitation";
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedFilter == "équitation"
                                  ? pPrimapryColor
                                  : Colors.white,
                              border: Border.all(
                                color: pPrimapryColor,
                              ),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                "équitation",
                                style: TextStyle(
                                  color: selectedFilter == "équitation"
                                      ? Colors.white
                                      : pPrimapryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFilter = "billard";
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedFilter == "billard"
                                  ? pPrimapryColor
                                  : Colors.white,
                              border: Border.all(
                                color: pPrimapryColor,
                              ),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                "billard",
                                style: TextStyle(
                                  color: selectedFilter == "billard"
                                      ? Colors.white
                                      : pPrimapryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) => ActiviteItem(
                      activite: filteredData[index],
                    ),
                  ),
                ),
              ],
            );
          },
        
        ),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (val) {
              setState(() {
                widget.currentIndex = val;
              });

              if (val == 0) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ListActiviteEcran(
                      currentIndex: 0, email: widget.email);
                }));
              }
              if (val == 1) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AddActiviteEcranWidget(
                      currentIndex: 1, email: widget.email);
                }));
              }

              if (val == 2) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return  ProfileEcranWidget(currentIndex: 2, email: widget.email);
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
