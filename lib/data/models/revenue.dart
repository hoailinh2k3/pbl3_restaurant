import 'package:flutter/material.dart';

class Revenue {
  final String date;
  final int total;

  Revenue({
    required this.date,
    required this.total,
  });

  factory Revenue.fromJson(Map<String, dynamic> json) {
    return Revenue(
      date: json['ngay'] ?? "",
      total: json['tongDoanhThu'] as int,
    );
  }
}

class TopFoods {
  final int foodId;
  final String name;
  final String picture;
  final int quantity;

  TopFoods({
    required this.foodId,
    required this.name,
    required this.picture,
    required this.quantity,
  });

  factory TopFoods.fromJson(Map<String, dynamic> json) {
    return TopFoods(
      foodId: json['foodId'] as int,
      name: json['foodName'] as String,
      picture: json['picture'] as String,
      quantity: json['soLuong'] as int,
    );
  }
}

class RevenueByBranch {
  final int branchId;
  final String name;
  final int total;

  RevenueByBranch({
    required this.branchId,
    required this.name,
    required this.total,
  });

  factory RevenueByBranch.fromJson(Map<String, dynamic> json) {
    return RevenueByBranch(
      branchId: json['branchId'] as int,
      name: json['chiNhanh'] as String,
      total: json['tongDoanhThu'] as int,
    );
  }
}

class TableRates {
  final int hour;
  final String dayOfWeek;
  final double ratio;

  TableRates({
    required this.hour,
    required this.dayOfWeek,
    required this.ratio,
  });

  factory TableRates.fromJson(Map<String, dynamic> json) {
    return TableRates(
      hour: json['hour'] as int,
      dayOfWeek: json['dayOfWeek'] as String,
      ratio: (json['tiLeSuDung'] as num).toDouble(),
    );
  }
}

enum TimeRange {
  Days(1, ' 7 Ngày'),
  Weeks(2, ' 12 Tuần'),
  Months(3, ' 12 Tháng'),
  Years(4, ' 5 Năm');

  final int range;
  final String label;

  const TimeRange(this.range, this.label);
}

/// 1 điểm dữ liệu: ngày (hoặc tháng) và giá trị revenue
class RevenuePoint {
  final DateTime time;
  final double value;
  RevenuePoint(this.time, this.value);
}

// Model đơn giản cho mỗi chi nhánh
class BranchRevenue {
  final String name;
  final double value;
  final Color color;

  BranchRevenue(this.name, this.value, this.color);
}

// Giả lập dữ liệu
final List<BranchRevenue> mockData = [
  BranchRevenue('Chi nhánh A', 1570000, Colors.blueAccent),
  BranchRevenue('Chi nhánh B', 500000, Colors.grey),
  BranchRevenue('Chi nhánh C', 1167000, Colors.white54),
];

// Giả lập biến % tăng giảm
final double percentChange = 18.56;
final bool isIncrease = true;
