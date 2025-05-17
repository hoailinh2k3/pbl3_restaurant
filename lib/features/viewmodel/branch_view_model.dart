import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/helpers/get_token.dart';

import '../../data/models/branch_model.dart';
import '../../data/repositories/branch_service.dart';

class BranchViewModel extends ChangeNotifier {
  BranchViewModel() {
    fetchBranches();
  }
  final BranchService _service = BranchService();
  List<BranchModel> _branches = [];
  List<BranchModel> get branches => _branches;

  BranchModel? getBranchById(int id) {
    if (_branches.isEmpty) {
      return null;
    }
    return _branches.firstWhere((branch) => branch.branchId == id);
  }

  Future<void> fetchBranches() async {
    try {
      String token = await getToken();
      _branches = await _service.fetchBranches(token);
    } catch (e) {
      print("Error fetching branches: $e");
    }
  }

  Future<void> addBranch(BranchModel branch) async {
    try {
      String token = await getToken();
      await _service.addBranch(branch, token);
      _branches.add(branch);
    } catch (e) {
      print("Error adding branch: $e");
    }
  }

  Future<void> updateBranch(BranchModel branch) async {
    try {
      String token = await getToken();
      await _service.updateBranch(branch, token);
      int index = _branches.indexWhere((b) => b.branchId == branch.branchId);
      if (index != -1) {
        _branches[index] = branch;
      }
    } catch (e) {
      print("Error updating branch: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteBranch(int id) async {
    try {
      String token = await getToken();
      await _service.deleteBranch(id, token);
      _branches.removeWhere((branch) => branch.branchId == id);
    } catch (e) {
      print("Error deleting branch: $e");
    } finally {
      notifyListeners();
    }
  }
}
