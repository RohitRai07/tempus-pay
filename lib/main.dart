import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const TempusPayApp());
}

// ---------------------------------------------------------------------------
// MODELS & SERVICES
// ---------------------------------------------------------------------------

class UserProfile {
  final String name;
  final String customerId;
  final String mobile;
  final String email;
  final String city;

  UserProfile({
    required this.name,
    required this.customerId,
    required this.mobile,
    required this.email,
    required this.city,
  });
}

class Account {
  final String id;
  final String name;
  final String accountNumber;
  final String type;
  double availableBalance;
  double ledgerBalance;

  Account({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.type,
    required this.availableBalance,
    required this.ledgerBalance,
  });
}

class BankCard {
  final String id;
  final String title;
  final String cardNumber;
  final String expiry;
  final String type;
  double limit;
  bool isFrozen;

  BankCard({
    required this.id,
    required this.title,
    required this.cardNumber,
    required this.expiry,
    required this.type,
    required this.limit,
    this.isFrozen = false,
  });
}

class Beneficiary {
  final String id;
  final String name;
  final String accountNumber;
  final String bankName;
  final String ifsc;

  Beneficiary({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.bankName,
    required this.ifsc,
  });
}

class TransactionItem {
  final String id;
  final String title;
  final String category;
  final double amount;
  final bool isCredit;
  final DateTime date;
  final String status;
  final String referenceNumber;

  TransactionItem({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.isCredit,
    required this.date,
    required this.status,
    required this.referenceNumber,
  });
}

class MockPaymentGateway {
  static Future<Map<String, dynamic>> processPayment({
    required double amount,
    required String scenario,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    switch (scenario) {
      case 'success':
        return {'status': 'SUCCESS', 'message': 'Payment processed successfully.', 'ref': 'TP-PG-${DateTime.now().millisecondsSinceEpoch}'};
      case 'declined':
        return {'status': 'FAILED', 'message': 'Gateway declined the transaction.', 'ref': ''};
      case 'insufficient_funds':
        return {'status': 'FAILED', 'message': 'Insufficient funds in account.', 'ref': ''};
      case 'cancelled':
        return {'status': 'CANCELLED', 'message': 'User cancelled payment checkout.', 'ref': ''};
      case 'timeout':
        return {'status': 'TIMEOUT', 'message': 'Gateway connection timed out.', 'ref': ''};
      case 'pending':
        return {'status': 'PENDING', 'message': 'Transaction is pending settlement.', 'ref': 'TP-PEN-${DateTime.now().millisecondsSinceEpoch}'};
      case 'duplicate':
        return {'status': 'DUPLICATE', 'message': 'Duplicate transaction request detected.', 'ref': ''};
      default:
        return {'status': 'SUCCESS', 'message': 'Processed.', 'ref': 'TP-GEN-${DateTime.now().millisecondsSinceEpoch}'};
    }
  }
}

// ---------------------------------------------------------------------------
// APP ROOT & THEME
// ---------------------------------------------------------------------------

class TempusPayApp extends StatelessWidget {
  const TempusPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tempus Pay UAT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F172A),
          primary: const Color(0xFF0F172A),
          secondary: const Color(0xFF0D9488),
          surface: const Color(0xFFF8FAFC),
        ),
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// SPLASH & AUTH SCREENS
// ---------------------------------------------------------------------------

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0D9488),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.account_balance_wallet, size: 64, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              'TEMPUS PAY',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'UAT Demo Environment',
              style: TextStyle(color: Colors.tealAccent, fontSize: 14, letterSpacing: 1),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController(text: '9000000001');
  bool _isLoading = false;

  void _requestOtp() {
    if (_mobileController.text.trim() != '9000000001') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please use demo mobile: 9000000001')),
      );
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isLoading = false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OtpScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tempus Pay Login'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: const Text(
                'TEMPUS PAY — UAT DEMO ENVIRONMENT\nDemo Mobile: 9000000001 | Static OTP: 123456 | MPIN: 2580',
                style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 32),
            const Text('Enter Mobile Number', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
                labelText: 'Mobile Number',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _requestOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Continue with OTP', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController(text: '123456');
  bool _isLoading = false;

  void _verifyOtp() {
    if (_otpController.text.trim() != '123456') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Use static OTP: 123456')),
      );
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MpinScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP'), backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Enter 6-digit OTP sent to 9000000001 (Static: 123456)', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'OTP'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Verify OTP', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class MpinScreen extends StatefulWidget {
  const MpinScreen({super.key});

  @override
  State<MpinScreen> createState() => _MpinScreenState();
}

class _MpinScreenState extends State<MpinScreen> {
  final TextEditingController _mpinController = TextEditingController(text: '2580');
  bool _isLoading = false;

  void _verifyMpin() {
    if (_mpinController.text.trim() != '2580') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid MPIN. Use static MPIN: 2580')),
      );
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter MPIN'), backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Enter 4-digit MPIN (Static Demo: 2580)', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            TextField(
              controller: _mpinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'MPIN'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyMpin,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Login to Dashboard', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// DASHBOARD & MAIN TABS
// ---------------------------------------------------------------------------

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final UserProfile user = UserProfile(
    name: 'Aarav Sharma',
    customerId: 'TP-UAT-10001',
    mobile: '9000000001',
    email: 'aarav.sharma@example.test',
    city: 'Mumbai',
  );

  final List<Account> accounts = [
    Account(id: 'acc1', name: 'Savings Account', accountNumber: 'XXXX-XXXX-4821', type: 'Savings', availableBalance: 125450.75, ledgerBalance: 127950.75),
    Account(id: 'acc2', name: 'Current Account', accountNumber: 'XXXX-XXXX-7316', type: 'Current', availableBalance: 340200.00, ledgerBalance: 340200.00),
  ];

  final List<BankCard> cards = [
    BankCard(id: 'c1', title: 'Virtual Debit Card', cardNumber: '4532 •••• •••• 4821', expiry: '12/28', type: 'Debit', limit: 100000),
    BankCard(id: 'c2', title: 'Tempus Rewards Credit', cardNumber: '5412 •••• •••• 7316', expiry: '09/27', type: 'Credit', limit: 250000),
  ];

  final List<Beneficiary> beneficiaries = [
    Beneficiary(id: 'b1', name: 'Neha Verma', accountNumber: '1234567890', bankName: 'HDFC Bank', ifsc: 'HDFC0001234'),
    Beneficiary(id: 'b2', name: 'Rahul Mehta', accountNumber: '9876543210', bankName: 'ICICI Bank', ifsc: 'ICIC0005678'),
  ];

  final List<TransactionItem> transactions = [
    TransactionItem(id: 't1', title: 'Salary Credit', category: 'Income', amount: 85000.00, isCredit: true, date: DateTime.now().subtract(const Duration(days: 1)), status: 'SUCCESS', referenceNumber: 'TP-REF-99881'),
    TransactionItem(id: 't2', title: 'Amazon India', category: 'Shopping', amount: 2499.00, isCredit: false, date: DateTime.now().subtract(const Duration(days: 2)), status: 'SUCCESS', referenceNumber: 'TP-REF-99882'),
    TransactionItem(id: 't3', title: 'Electricity Bill', category: 'Utilities', amount: 1850.50, isCredit: false, date: DateTime.now().subtract(const Duration(days: 3)), status: 'SUCCESS', referenceNumber: 'TP-REF-99883'),
  ];

  void _addTransaction(TransactionItem tx, double amount, bool isCredit, String accountId) {
    setState(() {
      transactions.insert(0, tx);
      for (var acc in accounts) {
        if (acc.id == accountId) {
          if (isCredit) {
            acc.availableBalance += amount;
            acc.ledgerBalance += amount;
          } else {
            acc.availableBalance -= amount;
            acc.ledgerBalance -= amount;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeTab(user: user, accounts: accounts, cards: cards, transactions: transactions, onNavigate: (idx) => setState(() => _currentIndex = idx)),
      AccountsTab(accounts: accounts, transactions: transactions),
      CardsTab(cards: cards),
      TransferTab(accounts: accounts, beneficiaries: beneficiaries, onTransferComplete: _addTransaction),
      ProfileTab(user: user),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF0D9488),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: 'Accounts'),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'Cards'),
          BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Transfer'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TABS IMPLEMENTATION
// ---------------------------------------------------------------------------

class HomeTab extends StatelessWidget {
  final UserProfile user;
  final List<Account> accounts;
  final List<BankCard> cards;
  final List<TransactionItem> transactions;
  final Function(int) onNavigate;

  const HomeTab({super.key, required this.user, required this.accounts, required this.cards, required this.transactions, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    double totalBalance = accounts.fold(0, (sum, acc) => sum + acc.availableBalance);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, ${user.name}'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Net Balance', style: TextStyle(color: Colors.tealAccent, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(currencyFormat.format(totalBalance), style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Customer ID: ${user.customerId}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      const Text('UAT Mode', style: TextStyle(color: Colors.tealAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                QuickActionButton(icon: Icons.send, label: 'Transfer', onTap: () => onNavigate(3)),
                QuickActionButton(icon: Icons.receipt_long, label: 'Bills', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BillPaymentScreen(onBillPaid: (tx) {})))),
                QuickActionButton(icon: Icons.credit_card, label: 'Cards', onTap: () => onNavigate(2)),
                QuickActionButton(icon: Icons.payment, label: 'Mock PG', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MockPgScreen()))),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length > 5 ? 5 : transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return Card(
                  elevation: 0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: tx.isCredit ? Colors.teal.shade100 : Colors.red.shade100,
                      child: Icon(tx.isCredit ? Icons.arrow_downward : Icons.arrow_upward, color: tx.isCredit ? Colors.teal.shade800 : Colors.red.shade800),
                    ),
                    title: Text(tx.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${DateFormat('dd MMM yyyy').format(tx.date)} • ${tx.referenceNumber}'),
                    trailing: Text(
                      '${tx.isCredit ? '+' : '-'}${currencyFormat.format(tx.amount)}',
                      style: TextStyle(color: tx.isCredit ? Colors.teal.shade700 : Colors.red.shade700, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const QuickActionButton({super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.tealAccent),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
        ],
      ),
    );
  }
}

class AccountsTab extends StatelessWidget {
  final List<Account> accounts;
  final List<TransactionItem> transactions;

  const AccountsTab({super.key, required this.accounts, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return Scaffold(
      appBar: AppBar(title: const Text('My Accounts'), backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          final acc = accounts[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(acc.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Chip(label: Text(acc.type), backgroundColor: Colors.teal.shade100),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(acc.accountNumber, style: const TextStyle(color: Colors.grey)),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Available Balance'),
                      Text(currencyFormat.format(acc.availableBalance), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0D9488))),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CardsTab extends StatefulWidget {
  final List<BankCard> cards;
  const CardsTab({super.key, required this.cards});

  @override
  State<CardsTab> createState() => _CardsTabState();
}

class _CardsTabState extends State<CardsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Card Management'), backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.cards.length,
        itemBuilder: (context, index) {
          final card = widget.cards[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            color: const Color(0xFF0F172A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(card.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(card.type, style: const TextStyle(color: Colors.tealAccent)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(card.cardNumber, style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 2)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Expires: ${card.expiry}', style: const TextStyle(color: Colors.white70)),
                      Switch(
                        value: card.isFrozen,
                        activeColor: Colors.red,
                        onChanged: (val) {
                          setState(() => card.isFrozen = val);
                        },
                      ),
                    ],
                  ),
                  Text(card.isFrozen ? 'Card Frozen' : 'Card Active', style: TextStyle(color: card.isFrozen ? Colors.redAccent : Colors.tealAccent, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class TransferTab extends StatefulWidget {
  final List<Account> accounts;
  final List<Beneficiary> beneficiaries;
  final Function(TransactionItem, double, bool, String) onTransferComplete;

  const TransferTab({super.key, required this.accounts, required this.beneficiaries, required this.onTransferComplete});

  @override
  State<TransferTab> createState() => _TransferTabState();
}

class _TransferTabState extends State<TransferTab> {
  Account? selectedAccount;
  Beneficiary? selectedBeneficiary;
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.accounts.isNotEmpty) selectedAccount = widget.accounts[0];
    if (widget.beneficiaries.isNotEmpty) selectedBeneficiary = widget.beneficiaries[0];
  }

  void _executeTransfer() {
    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid amount')));
      return;
    }
    if (selectedAccount == null || selectedBeneficiary == null) return;
    if (amount > selectedAccount!.availableBalance) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insufficient funds in selected account')));
      return;
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      final ref = 'TP-TRF-${DateTime.now().millisecondsSinceEpoch}';
      final tx = TransactionItem(
        id: ref,
        title: 'Transfer to ${selectedBeneficiary!.name}',
        category: 'Transfer',
        amount: amount,
        isCredit: false,
        date: DateTime.now(),
        status: 'SUCCESS',
        referenceNumber: ref,
      );
      widget.onTransferComplete(tx, amount, false, selectedAccount!.id);
      _amountController.clear();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Transfer Successful'),
          content: Text('Successfully transferred ₹$amount to ${selectedBeneficiary!.name}.\nRef: $ref'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fund Transfer'), backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Select Source Account', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<Account>(
              value: selectedAccount,
              isExpanded: true,
              items: widget.accounts.map((acc) => DropdownMenuItem(value: acc, child: Text('${acc.name} (${acc.accountNumber}) - ₹${acc.availableBalance}'))).toList(),
              onChanged: (acc) => setState(() => selectedAccount = acc),
            ),
            const SizedBox(height: 16),
            const Text('Select Beneficiary', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<Beneficiary>(
              value: selectedBeneficiary,
              isExpanded: true,
              items: widget.beneficiaries.map((b) => DropdownMenuItem(value: b, child: Text('${b.name} (${b.bankName})'))).toList(),
              onChanged: (b) => setState(() => selectedBeneficiary = b),
            ),
            const SizedBox(height: 16),
            const Text('Enter Amount (INR)', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: OutlineInputBorder(), prefixText: '₹ '),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _executeTransfer,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Send Money Securely', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class BillPaymentScreen extends StatefulWidget {
  final Function(TransactionItem) onBillPaid;
  const BillPaymentScreen({super.key, required this.onBillPaid});

  @override
  State<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  String selectedCategory = 'Electricity';
  final TextEditingController _billerController = TextEditingController(text: 'MSEDCL Consumer #88921');
  final TextEditingController _amountController = TextEditingController(text: '1450');
  bool _isLoading = false;

  void _payBill() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bill payment successful!')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bill Payments & Recharge'), backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,
              items: ['Electricity', 'Mobile Recharge', 'Broadband', 'Water'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => selectedCategory = val!),
            ),
            const SizedBox(height: 16),
            TextField(controller: _billerController, decoration: const InputDecoration(labelText: 'Biller / Consumer Reference', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder(), prefixText: '₹ ')),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _payBill,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Pay Bill'),
            ),
          ],
        ),
      ),
    );
  }
}

class MockPgScreen extends StatefulWidget {
  const MockPgScreen({super.key});

  @override
  State<MockPgScreen> createState() => _MockPgScreenState();
}

class _MockPgScreenState extends State<MockPgScreen> {
  String selectedScenario = 'success';
  bool _isLoading = false;
  String? resultMessage;

  void _runPg() async {
    setState(() {
      _isLoading = true;
      resultMessage = null;
    });
    final res = await MockPaymentGateway.processPayment(amount: 1500.0, scenario: selectedScenario);
    setState(() {
      _isLoading = false;
      resultMessage = 'Status: ${res['status']}\nMessage: ${res['message']}\nRef: ${res['ref']}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mock Payment Gateway'), backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Select Test Scenario:', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedScenario,
              isExpanded: true,
              items: ['success', 'declined', 'insufficient_funds', 'cancelled', 'timeout', 'pending', 'duplicate'].map((s) => DropdownMenuItem(value: s, child: Text(s.toUpperCase()))).toList(),
              onChanged: (val) => setState(() => selectedScenario = val!),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _runPg,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Simulate PG Checkout'),
            ),
            const SizedBox(height: 24),
            if (resultMessage != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                child: Text(resultMessage!, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  final UserProfile user;
  const ProfileTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Profile'), backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(title: const Text('Full Name'), subtitle: Text(user.name), leading: const Icon(Icons.person)),
          ListTile(title: const Text('Customer ID'), subtitle: Text(user.customerId), leading: const Icon(Icons.badge)),
          ListTile(title: const Text('Mobile Number'), subtitle: Text(user.mobile), leading: const Icon(Icons.phone)),
          ListTile(title: const Text('Email'), subtitle: Text(user.email), leading: const Icon(Icons.email)),
          ListTile(title: const Text('City'), subtitle: Text(user.city), leading: const Icon(Icons.location_city)),
          const Divider(),
          ListTile(
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
