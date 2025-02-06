import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// Shimmer
class FavouriteShimmerLoading extends StatelessWidget {
  final Size size;

  const FavouriteShimmerLoading({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: size.width * 0.06,
              height: size.width * 0.06,
              color: Colors.grey.shade300,
            ),
            SizedBox(width: size.width * 0.02),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12.0,
                    width: size.width * 0.3,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 12.0,
                    width: size.width * 0.5,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
            ),
            SizedBox(width: size.width * 0.015),
            Container(
              height: size.width * 0.07,
              width: size.width * 0.07,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
