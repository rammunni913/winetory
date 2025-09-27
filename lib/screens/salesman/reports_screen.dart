import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../providers/sales_provider.dart';
import '../../providers/expense_provider.dart';
import '../../utils/theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([
      Provider.of<SalesProvider>(context, listen: false).fetchSales(),
      Provider.of<ExpenseProvider>(context, listen: false).fetchExpenses(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Sales', icon: Icon(Icons.trending_up)),
            Tab(text: 'Expenses', icon: Icon(Icons.money_off)),
            Tab(text: 'Summary', icon: Icon(Icons.analytics)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSalesReport(),
          _buildExpensesReport(),
          _buildSummaryReport(),
        ],
      ),
    );
  }

  Widget _buildSalesReport() {
    return Consumer<SalesProvider>(
      builder: (context, salesProvider, child) {
        if (salesProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final sales = salesProvider.sales;
        final totalSales = sales.fold<double>(0, (sum, sale) => sum + sale.totalAmount);
        final totalCommission = sales.fold<double>(0, (sum, sale) => sum + (sale.commission ?? 0));

        return RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSalesOverviewCard(totalSales, totalCommission, sales.length),
                const SizedBox(height: 24),
                _buildSalesChart(sales),
                const SizedBox(height: 24),
                _buildSalesList(sales),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpensesReport() {
    return Consumer<ExpenseProvider>(
      builder: (context, expenseProvider, child) {
        if (expenseProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final expenses = expenseProvider.expenses;
        final totalExpenses = expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
        final dukaanExpenses = expenses.where((e) => e.type == 'Dukaan Kharcha Khata').fold<double>(0, (sum, expense) => sum + expense.amount);
        final commissionExpenses = expenses.where((e) => e.type == 'Commission Kharcha Khata').fold<double>(0, (sum, expense) => sum + expense.amount);

        return RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildExpensesOverviewCard(totalExpenses, dukaanExpenses, commissionExpenses, expenses.length),
                const SizedBox(height: 24),
                _buildExpensesChart(expenses),
                const SizedBox(height: 24),
                _buildExpensesList(expenses),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryReport() {
    return Consumer2<SalesProvider, ExpenseProvider>(
      builder: (context, salesProvider, expenseProvider, child) {
        if (salesProvider.isLoading || expenseProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final sales = salesProvider.sales;
        final expenses = expenseProvider.expenses;
        
        final totalSales = sales.fold<double>(0, (sum, sale) => sum + sale.totalAmount);
        final totalExpenses = expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
        final totalCommission = sales.fold<double>(0, (sum, sale) => sum + (sale.commission ?? 0));
        final netProfit = totalSales - totalExpenses;

        return RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryOverviewCard(totalSales, totalExpenses, totalCommission, netProfit),
                const SizedBox(height: 24),
                _buildProfitLossChart(totalSales, totalExpenses),
                const SizedBox(height: 24),
                _buildDetailedSummary(sales, expenses),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSalesOverviewCard(double totalSales, double totalCommission, int salesCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Sales Overview',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildOverviewItem(
                  'Total Sales',
                  '₹${totalSales.toStringAsFixed(0)}',
                  Icons.attach_money,
                  Colors.white,
                ),
              ),
              Expanded(
                child: _buildOverviewItem(
                  'Commission',
                  '₹${totalCommission.toStringAsFixed(0)}',
                  Icons.percent,
                  Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildOverviewItem(
                  'Transactions',
                  salesCount.toString(),
                  Icons.receipt,
                  Colors.white,
                ),
              ),
              Expanded(
                child: _buildOverviewItem(
                  'Date',
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  Icons.calendar_today,
                  Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.3, end: 0);
  }

  Widget _buildExpensesOverviewCard(double totalExpenses, double dukaanExpenses, double commissionExpenses, int expensesCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.errorColor, AppTheme.errorColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.errorColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.money_off,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Expenses Overview',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildOverviewItem(
                  'Total Expenses',
                  '₹${totalExpenses.toStringAsFixed(0)}',
                  Icons.attach_money,
                  Colors.white,
                ),
              ),
              Expanded(
                child: _buildOverviewItem(
                  'Dukaan',
                  '₹${dukaanExpenses.toStringAsFixed(0)}',
                  Icons.store,
                  Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildOverviewItem(
                  'Commission',
                  '₹${commissionExpenses.toStringAsFixed(0)}',
                  Icons.percent,
                  Colors.white,
                ),
              ),
              Expanded(
                child: _buildOverviewItem(
                  'Count',
                  expensesCount.toString(),
                  Icons.receipt,
                  Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.3, end: 0);
  }

  Widget _buildSummaryOverviewCard(double totalSales, double totalExpenses, double totalCommission, double netProfit) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.successColor, AppTheme.successColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.successColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Summary Overview',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildOverviewItem(
                  'Total Sales',
                  '₹${totalSales.toStringAsFixed(0)}',
                  Icons.trending_up,
                  Colors.white,
                ),
              ),
              Expanded(
                child: _buildOverviewItem(
                  'Total Expenses',
                  '₹${totalExpenses.toStringAsFixed(0)}',
                  Icons.money_off,
                  Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildOverviewItem(
                  'Commission',
                  '₹${totalCommission.toStringAsFixed(0)}',
                  Icons.percent,
                  Colors.white,
                ),
              ),
              Expanded(
                child: _buildOverviewItem(
                  'Net Profit',
                  '₹${netProfit.toStringAsFixed(0)}',
                  Icons.account_balance_wallet,
                  Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.3, end: 0);
  }

  Widget _buildOverviewItem(String label, String value, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color.withOpacity(0.8),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSalesChart(sales) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sales Trend',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: sales.isEmpty
                ? Center(
                    child: Text(
                      'No sales data available',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: sales.asMap().entries.map((entry) {
                            return FlSpot(entry.key.toDouble(), entry.value.totalAmount);
                          }).toList(),
                          isCurved: true,
                          color: AppTheme.primaryColor,
                          barWidth: 3,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppTheme.primaryColor.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    )
        .animate(delay: 200.ms)
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.3, end: 0);
  }

  Widget _buildExpensesChart(expenses) {
    final dukaanExpenses = expenses.where((e) => e.type == 'Dukaan Kharcha Khata').length;
    final commissionExpenses = expenses.where((e) => e.type == 'Commission Kharcha Khata').length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expenses Distribution',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: expenses.isEmpty
                ? Center(
                    child: Text(
                      'No expenses data available',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  )
                : PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: dukaanExpenses.toDouble(),
                          title: 'Dukaan',
                          color: AppTheme.warningColor,
                          radius: 80,
                        ),
                        PieChartSectionData(
                          value: commissionExpenses.toDouble(),
                          title: 'Commission',
                          color: AppTheme.errorColor,
                          radius: 80,
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    )
        .animate(delay: 200.ms)
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.3, end: 0);
  }

  Widget _buildProfitLossChart(double totalSales, double totalExpenses) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profit & Loss',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: [totalSales, totalExpenses].reduce((a, b) => a > b ? a : b) * 1.2,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return const Text('Sales');
                          case 1:
                            return const Text('Expenses');
                          default:
                            return const Text('');
                        }
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text('₹${value.toInt()}');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: totalSales,
                        color: AppTheme.successColor,
                        width: 40,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: totalExpenses,
                        color: AppTheme.errorColor,
                        width: 40,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: 200.ms)
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.3, end: 0);
  }

  Widget _buildSalesList(sales) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Sales',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...sales.take(5).map((sale) => _buildSalesListItem(sale)).toList(),
        ],
      ),
    )
        .animate(delay: 400.ms)
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.3, end: 0);
  }

  Widget _buildExpensesList(expenses) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Expenses',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...expenses.take(5).map((expense) => _buildExpenseListItem(expense)).toList(),
        ],
      ),
    )
        .animate(delay: 400.ms)
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.3, end: 0);
  }

  Widget _buildDetailedSummary(sales, expenses) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed Summary',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryItem('Total Sales', '₹${sales.fold<double>(0, (sum, sale) => sum + sale.totalAmount).toStringAsFixed(0)}', AppTheme.successColor),
          _buildSummaryItem('Total Expenses', '₹${expenses.fold<double>(0, (sum, expense) => sum + expense.amount).toStringAsFixed(0)}', AppTheme.errorColor),
          _buildSummaryItem('Total Commission', '₹${sales.fold<double>(0, (sum, sale) => sum + (sale.commission ?? 0)).toStringAsFixed(0)}', AppTheme.warningColor),
          _buildSummaryItem('Net Profit', '₹${(sales.fold<double>(0, (sum, sale) => sum + sale.totalAmount) - expenses.fold<double>(0, (sum, expense) => sum + expense.amount)).toStringAsFixed(0)}', AppTheme.primaryColor),
        ],
      ),
    )
        .animate(delay: 400.ms)
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.3, end: 0);
  }

  Widget _buildSalesListItem(sale) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.shopping_cart,
              color: AppTheme.successColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sale #${sale.id}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${sale.saleDate.day}/${sale.saleDate.month}/${sale.saleDate.year}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹${sale.totalAmount.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.successColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseListItem(expense) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.errorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.money_off,
              color: AppTheme.errorColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${expense.expenseDate.day}/${expense.expenseDate.month}/${expense.expenseDate.year}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹${expense.amount.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.errorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadData();
    }
  }
}
