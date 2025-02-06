import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWalletHistory extends StatelessWidget {
  final Size size;

  const ShimmerWalletHistory({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: size.width,
        height: size.width * 0.175,
        margin: EdgeInsets.only(bottom: size.width * 0.030),
        padding: EdgeInsets.all(size.width * 0.025),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 0.5, color: Colors.grey),
        ),
        child: Row(
          children: [
            Container(
              height: size.width * 0.15,
              width: size.width * 0.125,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(width: size.width * 0.025),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.5,
                    height: 16,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: size.width * 0.35,
                    height: 14,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
            SizedBox(width: size.width * 0.025),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.12,
                  height: 16,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
