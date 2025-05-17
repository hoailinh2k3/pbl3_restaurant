import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/helpers/get_token.dart';
import 'package:pbl3_restaurant/data/models/revenue.dart';
import 'package:pbl3_restaurant/data/repositories/revenue_service.dart';

class RevenueViewModel extends ChangeNotifier {
  final RevenueService _service = RevenueService();
  List<RevenueByBranch> revenueByBranch = [];
  List<Revenue> revenue = [];
  List<TopFoods> topFoodsByBranch = [];
  List<TopFoods> bottomFoodsByBranch = [];
  List<TableRates> tableRates = [];
  bool isLoadingTable = false;
  String? error;
  List<Color> branchColors = [];
  final _rng = Random();

  Future<void> fetchRevenueByBranchandDate(
      int branchId, TimeRange range) async {
    revenue.clear();
    notifyListeners();
    try {
      String token = await getToken();
      revenue = await _service.fetchRevenue(branchId, token, range);
    } catch (e) {
      print(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchBottomFoodsByBranch(int branchId) async {
    bottomFoodsByBranch.clear();
    notifyListeners();
    try {
      String token = await getToken();
      bottomFoodsByBranch =
          await _service.fetchBottomFoodsByBranch(branchId, token);
    } catch (e) {
      print(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchTopFoodsByBranch(int branchId) async {
    topFoodsByBranch.clear();
    notifyListeners();
    try {
      String token = await getToken();
      topFoodsByBranch = await _service.fetchTopFoodsByBranch(branchId, token);
    } catch (e) {
      print(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchTableRates(int branchId) async {
    isLoadingTable = true;
    notifyListeners();
    try {
      String token = await getToken();
      tableRates = await _service.fetchUtilizationRate(branchId, token);
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoadingTable = false;
      notifyListeners();
    }
  }

  Future<void> fetchRevenueByBranch(TimeRange range) async {
    revenueByBranch.clear();
    branchColors.clear();
    notifyListeners();
    try {
      String token = await getToken();
      revenueByBranch = await _service.fetchRevenueByBranch(range, token);
      branchColors = revenueByBranch.map((_) {
        return Color.fromRGBO(
          _rng.nextInt(256),
          _rng.nextInt(256),
          _rng.nextInt(256),
          1.0, // opacity full
        );
      }).toList();
    } catch (e) {
      print(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
