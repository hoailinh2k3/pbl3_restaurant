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

  // Table
  static const tableList = "$baseUrl/Table/ByBranch";

  // Bill
  static const String billList = "$baseUrl/Bill/GetOrCreateByTable";
  static const String billUpsertFood = "$baseUrl/Bill/UpsertFood";
}
