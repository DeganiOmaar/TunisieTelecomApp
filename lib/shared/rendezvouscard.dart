import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RendezVousCard extends StatelessWidget {
  final String nom;
  final String time;
  final VoidCallback onConfirm;
  final VoidCallback onDecline;
  final VoidCallback onTap;
  const RendezVousCard(
      {super.key,
      required this.nom,
      required this.time,
      required this.onConfirm,
      required this.onDecline, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/profilepic.svg',
                height: 60.0,
                width: 60.0,
                allowDrawingOutsideViewBox: true,
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nom,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    time,
                    style: const TextStyle(color: Colors.black45, fontSize: 14),
                  )
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  InkWell(
                      onTap: onConfirm,
                      child: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 20,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: onDecline,
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 20,
                      )),
             
                ],
                
              )
            ],
          ),
             const SizedBox(height: 30,),
        ],
      ),
    );
  }
}
