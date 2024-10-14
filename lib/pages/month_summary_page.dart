import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:snoutsaver/models/category.dart';
import 'package:snoutsaver/models/record.dart';
import 'package:snoutsaver/repository/category_repository.dart';
import 'package:snoutsaver/repository/record_repository.dart';
import 'package:snoutsaver/widgets/record_form.dart';

class MonthSummaryPage extends StatefulWidget {
  const MonthSummaryPage({super.key});

  @override
  State<MonthSummaryPage> createState() => _MonthSummaryPageState();
}

class _MonthSummaryPageState extends State<MonthSummaryPage> {
  int _currentIndex = 0;
  late Future<List<Category>> _categoriesFuture;
  late Future<List<Record>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = CategoryRepository().fetchCategories();
    _recordsFuture = RecordRepository().fetchRecords();
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _addOrEditRecord({Record? record}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: RecordBottomsheet(record: record),
        );
      },
    ).then((_) {
      setState(() {
        _recordsFuture = RecordRepository().fetchRecords();
      });
    });
  }

  Future<void> _deleteRecord(int recordId) async {
    try {
      await RecordRepository().deleteRecord(recordId);
      setState(() {
        _recordsFuture = RecordRepository().fetchRecords();
      });
    } catch (error) {
      print('Failed to delete record: $error');
    }
  }

  // Pie chart section
  List<PieChartSectionData> _generatePieChartSections(
      List<Record> records, List<Category> categories) {
    Map<String, double> categoryTotals = {};
    double totalAmount = 0.0;

    final filteredRecords = records.where((record) =>
        (_currentIndex == 0 && record.type == 'Income') ||
        (_currentIndex == 1 && record.type == 'Expense')).toList();

    // Calculate total amounts for each category
    for (var record in filteredRecords) {
      if (categoryTotals.containsKey(record.category)) {
        categoryTotals[record.category] =
            categoryTotals[record.category]! + record.amount;
      } else {
        categoryTotals[record.category] = record.amount;
      }
      totalAmount += record.amount;
    }

    List<Color> sliceColors = [
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.redAccent,
      Colors.yellowAccent,
    ];

    int colorIndex = 0;
    return categoryTotals.entries.map((entry) {
      final percentage = (entry.value / totalAmount) * 100;
      final sectionColor = sliceColors[colorIndex % sliceColors.length];
      colorIndex++;

      return PieChartSectionData(
        color: sectionColor,
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }).toList();
  }

  List<Widget> _generateLegend(Map<String, double> categoryTotals, List<Color> sliceColors) {
    List<Widget> legendItems = [];
    int colorIndex = 0;

    categoryTotals.forEach((category, total) {
      legendItems.add(
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              color: sliceColors[colorIndex % sliceColors.length],
            ),
            const SizedBox(width: 4),
            Text(category, style: GoogleFonts.outfit(fontSize: 16)),
            const SizedBox(width: 8),
          ],
        ),
      );
      colorIndex++;
    });

    return legendItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8ACDD7),
      appBar: AppBar(
        title: Text(
          'This Month',
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF90BC),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: _categoriesFuture,
        builder: (context, categorySnapshot) {
          if (categorySnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (categorySnapshot.hasError) {
            return const Center(child: Text('Failed to load categories'));
          } else if (!categorySnapshot.hasData || categorySnapshot.data!.isEmpty) {
            return const Center(child: Text('No categories found'));
          }

          final List<Category> categories = _currentIndex == 0
              ? categorySnapshot.data!.where((c) => c.type == 'Income').toList()
              : categorySnapshot.data!.where((c) => c.type == 'Expense').toList();

          return FutureBuilder<List<Record>>(
            future: _recordsFuture,
            builder: (context, recordSnapshot) {
              if (recordSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (recordSnapshot.hasError) {
                return const Center(child: Text('Failed to load records'));
              } else if (!recordSnapshot.hasData || recordSnapshot.data!.isEmpty) {
                return const Center(child: Text('No records found'));
              }

              final categoryTotals = <String, double>{};

              final List<Record> records = recordSnapshot.data!;

              final List<Color> sliceColors = [
                Colors.blueAccent,
                Colors.greenAccent,
                Colors.orangeAccent,
                Colors.purpleAccent,
                Colors.redAccent,
                Colors.yellowAccent,
              ];

              final filteredRecords = records.where((record) =>
                (_currentIndex == 0 && record.type == 'Income') ||
                (_currentIndex == 1 && record.type == 'Expense')).toList();
              
              for (var record in filteredRecords) {
                if (categoryTotals.containsKey(record.category)) {
                  categoryTotals[record.category] = categoryTotals[record.category]! + record.amount;
                } else {
                  categoryTotals[record.category] = record.amount;
                }
              }
              
              return Center(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    RecordTabbar(onTabChanged: _onTabChanged),
                    const SizedBox(height: 16),

                    Stack(
                      children: [
                        Center(
                          child: Container(
                            width: 360,
                            height: 300,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20)),
                              )
                          ),
                        ),
                        Column(
                          children: [
                            // Pie Chart
                            SizedBox(
                            height: 250,
                            child: PieChart(
                              PieChartData(
                                sections: _generatePieChartSections(records, categories),
                                centerSpaceRadius: 60,
                                sectionsSpace: 5,
                              ),
                            ),
                          ),
                          // Legend
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _generateLegend(categoryTotals, sliceColors),
                            ),
                          ),
                          ]
                        ),
                      ]
                    ),
                    
                    // Accordion separated by Category
                    RecordList(
                      categories: categories,
                      records: records,
                      currentIndex: _currentIndex,
                      onDelete: _deleteRecord,
                      onEdit: _addOrEditRecord,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditRecord(),
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFFFFD200),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}

class RecordList extends StatefulWidget {
  final List<Category> categories;
  final List<Record> records;
  final int currentIndex;
  final Function(int recordId) onDelete;
  final Function({Record? record}) onEdit;

  const RecordList({
    super.key,
    required this.categories,
    required this.records,
    required this.currentIndex,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  _RecordListState createState() => _RecordListState();
}

class _RecordListState extends State<RecordList> {

  String formatAmount(double amount) {
    if (amount == amount.toInt()) {
      return amount.toInt().toString();
    } else {
      return amount.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Record>> groupedRecordsByDate = {};
    final today = DateTime.now();

    for (var record in widget.records) {
      // Filter records by month
      if (record.recordDate.year == today.year &&
          record.recordDate.month == today.month) {
        // Group records by date, and filter them by the selected type (Income/Expense)
        final recordTypeMatches = widget.currentIndex == 0
            ? record.type == 'Income'
            : record.type == 'Expense';
        if (recordTypeMatches) {
          final recordDate = DateFormat('dd MMM, yyyy').format(record.recordDate);
          groupedRecordsByDate.putIfAbsent(recordDate, () => []).add(record);
        }
      }
    }

    // Sort dates (oldest first)
    final sortedDates = groupedRecordsByDate.keys.toList()
      ..sort((a, b) => DateFormat('dd MMM, yyyy').parse(a).compareTo(DateFormat('dd MMM, yyyy').parse(b)));

    return Expanded(
      child: sortedDates.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 90.0),
                child: Text(
                  '${widget.currentIndex == 0 ? 'Income' : 'Expense'} not found',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: sortedDates.length,
              itemBuilder: (context, index) {
                final dateKey = sortedDates[index];
                final dateRecords = groupedRecordsByDate[dateKey] ?? [];
                
                // Group records by category for the specific date
                final Map<String, List<Record>> groupedByCategory = {};
                for (var record in dateRecords) {
                  groupedByCategory.putIfAbsent(record.category, () => []).add(record);
                }

                // Sum the total amount for the date
                final double totalAmount = dateRecords.fold<double>(0, (sum, record) => sum + record.amount);

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    key: PageStorageKey<String>(dateKey),
                    initiallyExpanded: false,
                    shape: const Border(),
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    childrenPadding: const EdgeInsets.all(4),
                    title: Row(
                      children: [
                        Text(
                          dateKey,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${totalAmount.toStringAsFixed(2)} ฿',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: widget.currentIndex == 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    children: groupedByCategory.entries.map((categoryEntry) {
                      final categoryName = categoryEntry.key;
                      final categoryRecords = categoryEntry.value;

                      // Calculate total amount for each category within this date
                      final double categoryTotal = categoryRecords.fold<double>(0, (sum, record) => sum + record.amount);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                            child: Row(
                              children: [
                                Icon(
                                  Category.convertIcon(categoryRecords.first.categoryId, null),
                                  color: const Color(0xFFFF90BC),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  categoryName,
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${categoryTotal.toStringAsFixed(2)} ฿',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: widget.currentIndex == 0 ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          ...categoryRecords.map((record) {
                            return Slidable(
                              key: ValueKey(record.id),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      widget.onEdit(record: record);
                                    },
                                    backgroundColor: const Color(0xFF21B7CA),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.all(0),
                                    icon: Icons.edit,
                                    label: 'Edit',
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {
                                      widget.onDelete(record.id);
                                    },
                                    backgroundColor: const Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.all(0),
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              child: ListTile(
                                subtitle: record.description == '' ? null : Text(record.description!),
                                title: Text(
                                  record.description == '' ? record.category : record.description!,
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: Text(
                                  '${formatAmount(record.amount)} ฿',
                                  style: GoogleFonts.outfit(color: Colors.black, fontSize: 16),
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }
}
