import 'package:flutter/material.dart';

class SoldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xff707070)// 三角形の色
      ..style = PaintingStyle.fill; // 塗りつぶし

    var path = Path();
    path.moveTo(5, 0); // 角丸を避けて開始点を設定
    path.lineTo(size.width, 0); // 右上の点
    path.lineTo(0, size.height); // 左下の点
    path.lineTo(0, 5); // 角丸の終了点を少し下に移動
    path.arcToPoint(
      const Offset(5, 0), // 角丸の開始点に戻る
      radius: const Radius.circular(5), // 角の丸み
      clockwise: true,
    );
    path.close(); // パスを閉じる

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // 再描画の必要がない場合はfalse
  }
}