import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductListView extends HookConsumerWidget {
  final CameraDescription? camera;
  const ProductListView({super.key, required this.camera});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 8,
          backgroundColor: const Color(0xffffffff),
          title: Column(
            children: [
              Container(
                height: 56,
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffffffff),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: SizedBox(
                        width: screenSize.width - 136,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_camera_outlined),
                            SizedBox(width: 8),
                            Text('出品する'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text(
                  '取引中',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  '出品中',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  '譲渡済み',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}
