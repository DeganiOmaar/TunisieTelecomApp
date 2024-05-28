import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserCard extends StatelessWidget {
  final String nom;
  final String email;
  final VoidCallback onPressed;
  const UserCard({super.key, required this.nom, required this.email, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    bool isAdmin = true;
    return Column(
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
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  email,
                  style: const TextStyle(color: Colors.black45),
                )
              ],
            )
         , const Spacer(),
           IconButton(
                                                  onPressed: onPressed,
                                                  icon: const Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.red,
                                                  ))
          ],
        ),
    const   SizedBox(
        height: 20,)
      ],
    );
  }
}
