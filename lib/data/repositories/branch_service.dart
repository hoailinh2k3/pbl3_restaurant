import 'dart:convert';

import '/data/models/branch_model.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/api.dart';

class BranchService {
  Future<List<BranchModel>> fetchBranches() async {
    try {
      final url = Uri.parse(Api.branchList);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        final List<dynamic> dataList = jsonData["data"];

        final List<BranchModel> branches =
            dataList.map((item) => BranchModel.fromJson(item)).toList();
        return branches;
      } else {
        throw Exception('Failed to load branches');
      }
    } catch (e) {
      print("Error fetching branches: $e");
      rethrow;
    }
  }

  Future<void> addBranch(BranchModel branch) async {
    try {
      final url = Uri.parse(Api.branchList).replace(queryParameters: {
        'TenChiNhanh': branch.branchName,
        'DiaChi': branch.branchAddr,
        'phone': branch.numberPhone,
        'image': branch.image,
      });

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
        },
        body: '',
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to add branch');
      }
    } catch (e) {
      print("Error adding branch: $e");
      rethrow;
    }
  }

  Future<void> updateBranch(BranchModel branch) async {
    try {
      final url = Uri.parse(Api.branchList).replace(queryParameters: {
        'ID': branch.branchId.toString(),
        'TenChiNhanh': branch.branchName,
        'DiaChi': branch.branchAddr,
        'phone': branch.numberPhone,
        'image': branch.image,
      });

      final response = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
        },
        body: '',
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update branch');
      }
    } catch (e) {
      print("Error updating branch: $e");
      rethrow;
    }
  }

  Future<void> deleteBranch(int branchId) async {
    try {
      final url = Uri.parse(Api.branchList).replace(queryParameters: {
        'ID': branchId.toString(),
      });

      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
        },
        body: '',
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete branch');
      }
    } catch (e) {
      print("Error deleting branch: $e");
      rethrow;
    }
  }
}
