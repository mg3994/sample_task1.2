import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


// Shimmer
class SosShimmerLoading extends StatelessWidget {
  final Size size;

  const SosShimmerLoading({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: size.width,
        margin: const EdgeInsets.only(right: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 0.5, color: Colors.grey),
        ),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.025),
          child: Row(
            children: [
              Container(
                height: size.width * 0.13,
                width: size.width * 0.13,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
              ),
              SizedBox(width: size.width * 0.025),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 15,
                      width: size.width * 0.4,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: size.width * 0.02),
                    Container(
                      height: 15,
                      width: size.width * 0.3,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
              SizedBox(width: size.width * 0.025),
              Container(
                height: 24,
                width: 24,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
