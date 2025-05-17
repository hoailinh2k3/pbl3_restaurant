class Api {
  static const String baseUrl = "http://localhost:5177";

  // Category
  static const String categoryList = "$baseUrl/Category/List";
  static const String categoryAdd = "$baseUrl/Category/Add";
  static const String categoryUpdate = "$baseUrl/Category/Update";
  static const String categoryDelete = "$baseUrl/Category/Delete";

  // Food
  static const String foodList = "$baseUrl/Food/List";
  static const String foodAdd = "$baseUrl/Food/Add";
  static const String foodUpdate = "$baseUrl/Food/Update";
  static const String foodDelete = "$baseUrl/Food/Delete";

  // User
  static const String login = "$baseUrl/User/Login";
  static const String changePassword = "$baseUrl/User/ChangePassword";

  // Table
  static const tableList = "$baseUrl/Table/ByBranch";
  static const tableAdd = "$baseUrl/Table/Add";
  static const tableUpdate = "$baseUrl/Table/Update";
  static const tableDelete = "$baseUrl/Table/Delete";

  // Bill
  static const String billList = "$baseUrl/Bill/GetByTable";
  static const String billUpsertFood = "$baseUrl/Bill/UpsertFood";
  static const String billDeleteFood = "$baseUrl/Bill/DeleteFoods";
  static const String billCheckout = "$baseUrl/Bill/Checkout";
  static const String confirmTransfer = "$baseUrl/Bill/ConfirmTransfer";

  // Branch
  static const String branchList = "$baseUrl/Branch/List";
  static const String branchAdd = "$baseUrl/Branch/Add";
  static const String branchUpdate = "$baseUrl/Branch/Update";
  static const String branchDelete = "$baseUrl/Branch/Delete";

  // Revenue
  static const String tableRateByBranch =
      '$baseUrl/Statistics/TableUtilizationRate';
  static const String revenueByBranch = '$baseUrl/Statistics/RevenueByBranch';
  static const String topFoodsByBranch = '$baseUrl/Statistics/TopFoods';
  static const String bottomFoodsByBranch = '$baseUrl/Statistics/BottomFoods';
  static const String revenueByBranchAndTime = '$baseUrl/Statistics/Revenue';
}
