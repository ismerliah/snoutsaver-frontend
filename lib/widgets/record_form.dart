import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:snoutsaver/bloc/record/record_bloc.dart';
import 'package:snoutsaver/models/category.dart';
import 'package:snoutsaver/models/record.dart';
import 'package:snoutsaver/repository/category_repository.dart';
import 'package:snoutsaver/widgets/dialogs/category_dialog.dart';

class RecordBottomsheet extends StatefulWidget {
  final Record? record;
  const RecordBottomsheet({super.key, this.record});

  @override
  State<RecordBottomsheet> createState() => _RecordBottomsheetState();
}

class _RecordBottomsheetState extends State<RecordBottomsheet> {
  int _currentIndex = 0;
  final GlobalKey<_RecordFormState> _recordFormKey = GlobalKey<_RecordFormState>();
  bool get isEditMode => widget.record != null;

  @override
  void initState() {
    super.initState();
    if (widget.record != null) {
      _currentIndex = widget.record!.type == 'Income' ? 0 : 1;
    }
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Reset form when tab changes
    _recordFormKey.currentState?.resetForm();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecordBloc(),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7F7F7F),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              RecordTabbar(
                onTabChanged: _onTabChanged,
                resetForm: _recordFormKey.currentState?.resetForm,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: RecordForm(
                  key: _recordFormKey,
                  isIncome: _currentIndex == 0,
                  record: widget.record,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecordForm extends StatefulWidget {
  final bool isIncome;
  final Record? record;

  const RecordForm({required this.isIncome, this.record, super.key});

  @override
  State<RecordForm> createState() => _RecordFormState();
}

class _RecordFormState extends State<RecordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  IconData _selectedCategoryIcon = Icons.category_rounded;
  DateTime? _selectedDate;

  late String _selectedType;
  Category? _selectedCategory;

  String formatAmount(double amount) {
    if (amount == amount.toInt()) {
      return amount.toInt().toString();
    } else {
      return amount.toStringAsFixed(2);
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedType = widget.isIncome ? 'Income' : 'Expense';

    // If in "edit" mode, populate the form with existing data
    if (widget.record != null) {
      final record = widget.record!;
      _amountController.text = formatAmount(record.amount);
      _selectedCategory = Category(
        id: record.categoryId,
        name: record.category,
        type: record.type,
        icon: Category.convertIcon(record.categoryId, record.category),
      );
      _categoryController.text = record.category;
      _noteController.text = record.description ?? '';
      _selectedDate = record.recordDate;
      _dateController.text = DateFormat('dd MMM, yyyy').format(_selectedDate!);
      _selectedCategoryIcon = Icons.category_rounded;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF90BC),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('dd MMM, yyyy').format(pickedDate);
      });
    }
  }

  void _selectCategory(BuildContext context) async {
    List<Category> allCategories = await CategoryRepository().fetchCategories();
    List<Category> filteredCategories = allCategories
        .where((category) => widget.isIncome
            ? category.type == 'Income'
            : category.type == 'Expense')
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CategoryDialog(
          categories: filteredCategories,
          onCategorySelected: (Category selectedCategory) {
            setState(() {
              _selectedCategory = selectedCategory;
              _categoryController.text = selectedCategory.name;
              _selectedCategoryIcon = selectedCategory.icon;
            });
          },
        );
      },
    );
  }

  // Method to reset form fields
  void resetForm() {
    _formKey.currentState?.reset();
    _amountController.clear();
    _categoryController.clear();
    _dateController.clear();
    _noteController.clear();
    setState(() {
      _selectedCategoryIcon = Icons.category_rounded;
      _selectedDate = null;
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecordBloc, RecordState>(
      listener: (context, state) {
        if (state is RecordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          Navigator.pop(context);
        } else if (state is RecordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Amount
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(
                  Icons.attach_money_rounded,
                  color: Color(0xFF8ACDD7),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: RequiredValidator(errorText: '* Required').call,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
            ),
            const SizedBox(height: 24),

            // Category
            TextFormField(
              controller: _categoryController,
              readOnly: true,
              onTap: () {
                _selectCategory(context);
              },
              decoration: InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(_selectedCategoryIcon, color: const Color(0xFF8ACDD7)),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              validator: RequiredValidator(errorText: '* Required').call,
            ),
            const SizedBox(height: 24),

            // Date
            TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: () {
                _selectDate(context);
              },
              decoration: const InputDecoration(
                labelText: 'Date',
                prefixIcon: Icon(Icons.calendar_month_rounded, color: Color(0xFF8ACDD7)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              validator: RequiredValidator(errorText: '* Required').call,
            ),
            const SizedBox(height: 24),

            // Note
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note',
                prefixIcon: Icon(Icons.sticky_note_2_rounded, color: Color(0xFF8ACDD7)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              keyboardType: TextInputType.text,
              validator: MaxLengthValidator(100, errorText: '* Maximum 100 characters allowed').call,
            ),
            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedCategory == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a category')),
                      );
                      return;
                    }

                    if (widget.record == null) {
                      // If creating a new record
                      context.read<RecordBloc>().add(
                        CreateRecordEvent(
                          type: _selectedType,
                          amount: double.parse(_amountController.text),
                          categoryId: _selectedCategory!.id.toString(),
                          categoryName: _selectedCategory!.name,
                          description: _noteController.text.isNotEmpty
                              ? _noteController.text
                              : null,
                          recordDate: _selectedDate!,
                        ),
                      );
                    } else {
                      // If editing an existing record
                      context.read<RecordBloc>().add(
                        UpdateRecordEvent(
                          recordId: widget.record!.id,
                          type: _selectedType,
                          amount: double.parse(_amountController.text),
                          categoryId: _selectedCategory!.id.toString(),
                          categoryName: _selectedCategory!.name,
                          description: _noteController.text.isNotEmpty
                              ? _noteController.text
                              : null,
                          recordDate: _selectedDate!,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: const Color(0xFFFF90BC),
                ),
                child: Text(
                  'Save',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecordTabbar extends StatefulWidget {
  final ValueChanged<int> onTabChanged;
  final void Function()? resetForm;
  const RecordTabbar({super.key, required this.onTabChanged, this.resetForm});

  @override
  State<RecordTabbar> createState() => _RecordTabbarState();
}

class _RecordTabbarState extends State<RecordTabbar> {
  int _currentIndex = 0;

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (widget.resetForm != null) {
      widget.resetForm!();
    }
    widget.onTabChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: 360,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xFFD9D9D9)),
        color: const Color(0xFFFFFFFF),
      ),
      child: Stack(
        children: [
          // Animated indicator for selected tab
          AnimatedAlign(
            alignment: _currentIndex == 0 ? Alignment.centerLeft : Alignment.centerRight,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: 175,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color(0xFFFFEC92),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Income Tab
              GestureDetector(
                onTap: () => _changeTab(0),
                child: Container(
                  width: 160,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFF9DCD5A),
                        radius: 16,
                        child: Icon(
                          Icons.arrow_downward_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Income',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Expense Tab
              GestureDetector(
                onTap: () => _changeTab(1),
                child: Container(
                  width: 175,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFFFF5757),
                        radius: 16,
                        child: Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Expense',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
