import 'dart:async';

import 'package:flutter/material.dart';

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
      _branches = await _service.fetchBranches();
    } catch (e) {
      print("Error fetching branches: $e");
    }
  }

  Future<void> addBranch(BranchModel branch) async {
    try {
      await _service.addBranch(branch);
      _branches.add(branch);
    } catch (e) {
      print("Error adding branch: $e");
    }
  }

  Future<void> updateBranch(BranchModel branch) async {
    try {
      await _service.updateBranch(branch);
      int index = _branches.indexWhere((b) => b.branchId == branch.branchId);
      if (index != -1) {
        _branches[index] = branch;
      }
    } catch (e) {
      print("Error updating branch: $e");
    }
  }

  Future<void> deleteBranch(int id) async {
    try {
      await _service.deleteBranch(id);
      _branches.removeWhere((branch) => branch.branchId == id);
    } catch (e) {
      print("Error deleting branch: $e");
    }
  }
}
