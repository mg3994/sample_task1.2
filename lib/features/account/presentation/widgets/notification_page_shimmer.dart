import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// Shimmer
class NotificationShimmer extends StatelessWidget {
  final Size size;

  const NotificationShimmer({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (_, index) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: size.width * 0.05),
                  padding: EdgeInsets.all(size.width * 0.025),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: size.width * 0.0025,
                      color: Colors.grey,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 18,
                                height: 18,
                                color: Colors.grey[300],
                              ),
                            ),
                            SizedBox(width: size.width * 0.02),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: size.width * 0.3,
                                    height: 10,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: size.width * 0.25,
                                    height: 10,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: size.width * 0.15,
                                  height: 10,
                                  color: Colors.grey[300],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: size.width * 0.15,
                                  height: 10,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: size.width * 0.01),
                          Container(
                            height: size.width * 0.1,
                            width: size.width * 0.002,
                            color: Colors.grey[300],
                          ),
                          SizedBox(width: size.width * 0.01),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 18,
                              height: 18,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
