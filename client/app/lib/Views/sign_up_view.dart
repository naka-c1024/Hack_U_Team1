import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpView extends HookConsumerWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNameController = useTextEditingController(text: '');
    final passwordController = useTextEditingController(text: '');
    final selectedPrefecture = useState<int>(12); // デフォルトは東京
    final prefectures = [
      '北海道',
      '青森県',
      '岩手県',
      '宮城県',
      '秋田県',
      '山形県',
      '福島県',
      '茨城県',
      '栃木県',
      '群馬県',
      '埼玉県',
      '千葉県',
      '東京都',
      '神奈川県',
      '新潟県',
      '富山県',
      '石川県',
      '福井県',
      '山梨県',
      '長野県',
      '岐阜県',
      '静岡県',
      '愛知県',
      '三重県',
      '滋賀県',
      '京都府',
      '大阪府',
      '兵庫県',
      '奈良県',
      '和歌山県',
      '鳥取県',
      '島根県',
      '岡山県',
      '広島県',
      '山口県',
      '徳島県',
      '香川県',
      '愛媛県',
      '高知県',
      '福岡県',
      '佐賀県',
      '長崎県',
      '熊本県',
      '大分県',
      '宮崎県',
      '鹿児島県',
      '沖縄県'
    ];

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('ユーザー名'),
            TextField(
              controller: userNameController,
              onSubmitted: (String value) {
                userNameController.text = value;
              },
            ),
            const SizedBox(height: 24),
            const Text('パスワード'),
            TextField(
              controller: passwordController,
              obscureText: true,
              keyboardType: TextInputType.text,
              onSubmitted: (String value) {
                passwordController.text = value;
              },
            ),
            const SizedBox(height: 24),
            const Text('お住まいの都道府県'),
            DropdownButton(
              isExpanded: true,
              menuMaxHeight: 240,
              value: prefectures[selectedPrefecture.value],
              items: prefectures.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? value) {
                selectedPrefecture.value = prefectures.indexOf(value!);
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              child: Container(
                height: 40,
                width: 80,
                alignment: Alignment.center,
                child: const Text(
                  '登録',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
