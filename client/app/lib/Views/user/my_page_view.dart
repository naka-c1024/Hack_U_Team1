import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/theme_color.dart';
import 'login_view.dart';
import 'user_menu_cell.dart';

class MyPageView extends HookConsumerWidget {
  final CameraDescription? camera;
  const MyPageView({super.key, required this.camera});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: const Color(0xffffffff),
        padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 16),
                Container(
                  height: 56,
                  width: 56,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: ThemeColors.bgGray1,),
                ),
                const SizedBox(width: 16),
                const Text(
                  'ibuibukiki',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                UserMenuCell(
                  menuIcon: Icons.favorite_outline,
                  menuText: 'いいね！一覧',
                ),
                UserMenuCell(
                  menuIcon: Icons.history,
                  menuText: '閲覧履歴',
                ),
                UserMenuCell(
                  menuIcon: Icons.search,
                  menuText: '保存した検索条件',
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                UserMenuCell(
                  menuIcon: Icons.shopping_bag_outlined,
                  menuText: '購入した商品',
                ),
                UserMenuCell(
                  menuIcon: Icons.storefront_outlined,
                  menuText: '出品した商品',
                ),
                UserMenuCell(
                  menuIcon: Icons.location_on_outlined,
                  menuText: '住まいエリア',
                ),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffffffff),
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Color(0xff424242)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  alignment: Alignment.center,
                  child: const Text(
                    'プロフィールを編集する',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff424242),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: ElevatedButton(
                onPressed: () {
                  // ログイン画面へ
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginView(camera: camera),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffe3e3e3),
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Color(0xff424242)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  alignment: Alignment.center,
                  child: const Text(
                    'ログアウト',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff424242),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
