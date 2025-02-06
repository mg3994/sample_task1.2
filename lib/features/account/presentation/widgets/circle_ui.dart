import 'package:flutter/material.dart';

class CircleOne extends StatelessWidget {
  const CircleOne({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.black.withOpacity(0.03)),
          ),
        ],
      ),
    );
  }
}

class CircleTwo extends StatelessWidget {
  const CircleTwo({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.black.withOpacity(0.03)
                  )),
        ],
      ),
    );
  }
}
