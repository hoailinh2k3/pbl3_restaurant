import 'dart:convert';
import 'dart:math';
import 'package:pbl3_restaurant/core/constants/api.dart';

import '../models/revenue.dart';
import 'package:http/http.dart' as http;

class RevenueService {
  Future<List<Revenue>> fetchRevenue(
      int branchId, String token, TimeRange range) async {
    final uri = Uri.parse(Api.revenueByBranchAndTime).replace(
      queryParameters: {
        'branchId': branchId.toString(),
        'range': range.range.toString(),
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((e) => Revenue.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Failed to load top foods (status: ${response.statusCode})',
      );
    }
  }

  Future<List<TopFoods>> fetchBottomFoodsByBranch(
      int branchId, String token) async {
    final uri = Uri.parse(Api.bottomFoodsByBranch).replace(
      queryParameters: {
        'branchId': branchId.toString(),
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((e) => TopFoods.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Failed to load top foods (status: ${response.statusCode})',
      );
    }
  }

  Future<List<TopFoods>> fetchTopFoodsByBranch(
      int branchId, String token) async {
    final uri = Uri.parse(Api.topFoodsByBranch).replace(
      queryParameters: {
        'branchId': branchId.toString(),
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((e) => TopFoods.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Failed to load top foods (status: ${response.statusCode})',
      );
    }
  }

  Future<List<TableRates>> fetchUtilizationRate(
      int branchId, String token) async {
    final uri = Uri.parse(Api.tableRateByBranch).replace(
      queryParameters: {
        'branchId': branchId.toString(),
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((e) => TableRates.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Failed to load table utilization (status: ${response.statusCode})',
      );
    }
  }

  Future<List<RevenueByBranch>> fetchRevenueByBranch(
      TimeRange range, String token) async {
    final uri = Uri.parse(Api.revenueByBranch).replace(
      queryParameters: {
        'range': range.range.toString(),
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((e) => RevenueByBranch.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Failed to load revenue by branch (status: ${response.statusCode})',
      );
    }
  }

  static List<RevenuePoint> fetchData(TimeRange range) {
    final now = DateTime.now();
    final rnd = Random();
    List<RevenuePoint> data = [];

    switch (range) {
      case TimeRange.Days:
        for (int i = 6; i >= 0; i--) {
          final day = now.subtract(Duration(days: i));
          data.add(RevenuePoint(day, rnd.nextDouble() * 30000 + 5000));
        }
        break;
      case TimeRange.Weeks:
        for (int i = 29; i >= 0; i--) {
          final day = now.subtract(Duration(days: i));
          data.add(RevenuePoint(day, rnd.nextDouble() * 30000 + 5000));
        }
        break;
      case TimeRange.Months:
        for (int i = 5; i >= 0; i--) {
          final month = DateTime(now.year, now.month - i, 1);
          data.add(RevenuePoint(month, rnd.nextDouble() * 30000 + 5000));
        }
        break;
      case TimeRange.Years:
        for (int i = 11; i >= 0; i--) {
          final month = DateTime(now.year, now.month - i, 1);
          data.add(RevenuePoint(month, rnd.nextDouble() * 30000 + 5000));
        }
        break;
    }
    return data;
  }
}
