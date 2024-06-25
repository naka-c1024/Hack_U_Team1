import 'dart:convert';
import 'package:http/http.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../Domain/description.dart';
import '../Domain/furniture.dart';
import 'provider.dart';

// 家具の説明を取得
Future<void> describeFurniture(WidgetRef ref, String imagePath) async {
  ref.watch(descriptionProvider.notifier).state = null;
  try {
    final uri = Uri.parse('http://192.168.2.152:8080/furniture/describe');
    final request = MultipartRequest('POST', uri);
    // 画像を読み込む
    var file = await MultipartFile.fromPath('image', imagePath);
    request.files.add(file);
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final jsonResponse = jsonDecode(responseBody);
    if (response.statusCode == 200) {
      final description = Description(
        productName: jsonResponse['product_name'],
        description: jsonResponse['description'],
        category: jsonResponse['category'],
        color: jsonResponse['color'],
      );
      ref.read(descriptionProvider.notifier).state = description;
    } else {
      final msg = jsonResponse['detail'];
      throw Exception('Failed to describe furniture: $msg');
    }
  } catch (e) {
    throw Exception('Undefined Error: $e');
  }
}

// 部屋の雰囲気にあった家具を取得
Future<void> recommendFurniture(WidgetRef ref, String imagePath) async {
  try {
    final uri = Uri.parse('http://192.168.2.152:8080/furniture/recommend');
    final request = MultipartRequest('POST', uri);
    // 画像を読み込む
    var file = await MultipartFile.fromPath('room_photo', imagePath);
    request.files.add(file);
    request.fields['category'] = ref.read(categoryProvider).toString();
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final jsonResponse = jsonDecode(responseBody);
    if (response.statusCode == 200) {
      ref.read(colorProvider.notifier).state = jsonResponse['color'];
      ref.read(reasonProvider.notifier).state = jsonResponse['reason'];
      final items = jsonResponse['furniture_list'];
      List<Furniture> furnitureList = [];
      for (Map<String, dynamic> item in items) {
        var furniture = Furniture(
            furnitureId: item['furniture_id'],
            image: base64Decode(item['image']),
            area: item['area'],
            userName: item['username'],
            productName: item['product_name'],
            description: item['description'],
            height: double.parse(item['size'].split(' ')[0]),
            width: double.parse(item['size'].split(' ')[1]),
            depth: double.parse(item['size'].split(' ')[2]),
            category: item['category'],
            color: item['color'],
            condition: item['condition'],
            isSold: item['is_sold'],
            startDate: item['start_date'] == null
                ? null
                : DateTime.parse(item['start_date']),
            endDate: item['end_date'] == null
                ? null
                : DateTime.parse(item['end_date']),
            tradePlace: item['trade_place'],
            isFavorite: item['is_favorite']);
        furnitureList.add(furniture);
      }
      ref.read(recommendFurnitureListProvider.notifier).state = furnitureList;
    } else if (response.statusCode == 404) {
      ref.read(recommendFurnitureListProvider.notifier).state = [];
    } else {
      final msg = jsonResponse['detail'];
      throw Exception('Failed to recommend furniture list: $msg');
    }
  } catch (e) {
    throw Exception('Undefined Error: $e');
  }
}
