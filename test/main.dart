import "persistent_expense_service_test.dart"
    as persistent_expense_service_test;

import "persistent_expense_service_filter_test.dart"
    as persistent_expense_filter_test;

import "persistent_expense_service_total_test.dart"
    as persistent_expense_total_test;

import "persistent_category_service_test.dart"
    as persistent_category_service_test;

void main() {
  persistent_expense_service_test.main();
  persistent_expense_filter_test.main();
  persistent_expense_total_test.main();
  persistent_category_service_test.main();
}
