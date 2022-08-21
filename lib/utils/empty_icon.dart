import 'package:flutter/material.dart';

class EmptyPageWithIcon extends StatelessWidget {
  const EmptyPageWithIcon({
    Key? key,
    required this.icon,
    required this.title,
    this.description,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50),
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.60,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.grey,
            size: 120,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          SizedBox(
            height: 20,
          ),
          description == null ? Container() :
          Text(
            description!,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
                fontSize: 16),
          )
        ],
      ),
    );
  }
}
