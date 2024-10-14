import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:snoutsaver/models/category.dart';
import 'package:snoutsaver/models/record.dart';
import 'package:snoutsaver/repository/category_repository.dart';
import 'package:snoutsaver/repository/record_repository.dart';
import 'package:snoutsaver/widgets/record_form.dart';

class TodaySummaryPage extends StatefulWidget {
  const TodaySummaryPage({super.key});

  @override
  State<TodaySummaryPage> createState() => _TodaySummaryPageState();
}

class _TodaySummaryPageState extends State<TodaySummaryPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8ACDD7),
      appBar: AppBar(
        title: Text(
          'Today',
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

              final List<Record> records = recordSnapshot.data!;
              
              return Center(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    RecordTabbar(onTabChanged: _onTabChanged),
                    const SizedBox(height: 8),

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
    final Map<String, List<Record>> groupedRecords = {};
    final today = DateTime.now();

    for (var record in widget.records) {
      // Filter Records by today
      if (record.recordDate.year == today.year &&
          record.recordDate.month == today.month &&
          record.recordDate.day == today.day) {
        groupedRecords.putIfAbsent(record.category, () => []).add(record);
      }
    }

    // Filter Records by category
    final filteredCategories = widget.categories.where((category) {
      final categoryRecords = groupedRecords[category.name];
      return categoryRecords != null && categoryRecords.isNotEmpty;
    }).toList();

    return Expanded(
      child: filteredCategories.isEmpty
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
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                final categoryRecords = groupedRecords[category.name] ?? [];

                // Sum the total amount for the category
                final double totalAmount = categoryRecords.fold<double>(0, (sum, record) => sum + record.amount);

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    key: PageStorageKey<String>(category.name),
                    initiallyExpanded: false,
                    shape: const Border(),
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    childrenPadding: const EdgeInsets.all(4),
                    leading: Icon(category.icon, color: const Color(0xFFFF90BC)),
                    title: Row(
                      children: [
                        Text(
                          category.name,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${totalAmount.toStringAsFixed(2)} ฿',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: widget.currentIndex == 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    children: categoryRecords.map((record) {
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
                          subtitle: Text(
                            DateFormat('dd MMM, yyyy').format(record.recordDate),
                            style: GoogleFonts.outfit(fontSize: 14),
                          ),
                          title: Text(
                            record.description == ''
                                ? record.category
                                : record.description!,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text(
                            '${formatAmount(record.amount)} ฿',
                            style: GoogleFonts.outfit(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }
}
