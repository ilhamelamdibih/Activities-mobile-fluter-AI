
import 'package:application_des_activites_mai/activite_detail.dart';
import 'package:application_des_activites_mai/constant/colors.dart';
import 'package:application_des_activites_mai/model/activite.dart';
import 'package:flutter/material.dart';

class ActiviteItem extends StatelessWidget {
  const ActiviteItem({Key? key, required this.activite}) : super(key: key);

  final Activite activite;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: InkWell(
        onTap: () {
           Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ActiviteDetail(activite: activite);
            }));
        },
        child: Container(
           height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              color: pPrimapryColor,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Image.network(
                  activite.image,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 2,
                child: ListTile(
                  title: Text(activite.titre),
                  subtitle: Text(activite.lieu),
                  trailing: Text('${activite.prix}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
