class BranchModel {
  int branchId;
  String branchName;
  String branchAddr;
  String numberPhone;
  String image;

  BranchModel({
    required this.branchId,
    required this.branchName,
    required this.branchAddr,
    required this.numberPhone,
    required this.image,
  });

  BranchModel.fromJson(Map<String, dynamic> json)
      : branchId = json['branchId'],
        branchName = json['branchName'],
        branchAddr = json['branchAddr'],
        numberPhone = json['numberPhone'],
        image = json['image'] ?? "";

  Map<String, dynamic> toJson() => {
        'branchId': branchId,
        'branchName': branchName,
        'branchAddr': branchAddr,
        'numberPhone': numberPhone,
        'image': image,
      };
}
