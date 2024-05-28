import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String imgLink;
  final String title;
  final String time;
  final String description;
  final VoidCallback? onPressed;

  const ServiceCard(
      {super.key,
      required this.imgLink,
      required this.title,
      required this.time,
      required this.description,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            // height: 205,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Row(children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
          
                child: 
                Image.network(
                       imgLink,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: 90,
                    )
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        time,
                        style: const TextStyle(fontSize: 13, color: Colors.black45),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                   const SizedBox(
                        height: 5,
                      ),                      
                    ],
                  ),
                ),
              )
            ]),
          ),
          const SizedBox(height: 20,),       
        ],
      ),
    );
  }
}