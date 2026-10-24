import 'package:flutter_test/flutter_test.dart';
import 'package:tempus_pay/main.dart';

void main() {
  test('MockPaymentGateway success scenario returns SUCCESS status', () async {
    final result = await MockPaymentGateway.processPayment(amount: 100.0, scenario: 'success');
    expect(result['status'], 'SUCCESS');
    expect(result['ref'], isNotEmpty);
  });

  test('MockPaymentGateway declined scenario returns FAILED status', () async {
    final result = await MockPaymentGateway.processPayment(amount: 100.0, scenario: 'declined');
    expect(result['status'], 'FAILED');
  });
}
