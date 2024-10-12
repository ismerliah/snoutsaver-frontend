import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:snoutsaver/mock_data.dart';
import 'package:snoutsaver/models/category.dart';
import 'package:snoutsaver/widgets/dialogs/category_dialog.dart';

class RecordBottomsheet extends StatefulWidget {
  const RecordBottomsheet({super.key});

  @override
  State<RecordBottomsheet> createState() => _RecordBottomsheetState();
}

class _RecordBottomsheetState extends State<RecordBottomsheet> {
  int _currentIndex = 0;
  final GlobalKey<_RecordFormState> _recordFormKey = GlobalKey<_RecordFormState>();

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Reset form when tab changes
    _recordFormKey.currentState?.resetForm();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Drag bar
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
            RecordTabbar(onTabChanged: _onTabChanged, resetForm: _recordFormKey.currentState?.resetForm),
            const SizedBox(height: 24),
            Expanded(
              child: _currentIndex == 0
                  ? RecordForm(key: _recordFormKey, isIncome: true)
                  : RecordForm(key: _recordFormKey, isIncome: false),
            ),
          ],
        ),
      ),
    );
  }
}

class RecordForm extends StatefulWidget {
  final bool isIncome;
  const RecordForm({required this.isIncome, super.key});

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

  // @override
  // void initState() {
  //   super.initState();
  //   // Set default date to today
  //   _selectedDate = DateTime.now();
  //   _dateController.text = DateFormat('dd MMM, yyyy').format(_selectedDate!);
  // }
  
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

  void _selectCategory(BuildContext context, List<Category> categories) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CategoryDialog(
          categories: categories,
          onCategorySelected: (Category selectedCategory) {
            setState(() {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Category> categories =
        widget.isIncome ? incomeCategories : expenseCategories;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Amount
          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Amount',
              labelStyle: TextStyle(
                fontSize: 18,
              ),
              prefixIcon: Icon(
                Icons.attach_money_rounded,
                color: Color(0xFF8ACDD7),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                  color: Color(0xFFff90BC),
                  width: 2.0,
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            keyboardType: TextInputType.number,
            validator: RequiredValidator(errorText: '* Required').call,
            inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
          ),
          const SizedBox(height: 24),

          // Category
          TextFormField(
            controller: _categoryController,
            readOnly: true,
            onTap: () {
              _selectCategory(context, categories);
            },
            decoration: InputDecoration(
              labelText: 'Category',
              labelStyle: const TextStyle(
                fontSize: 18,
              ),
              prefixIcon: Icon(
                _selectedCategoryIcon,
                color: const Color(0xFF8ACDD7),
              ),
              suffixIcon: const Icon(
                Icons.expand_more_rounded,
                color: Color(0xFF8ACDD7),
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                  color: Color(0xFFff90BC),
                  width: 2.0,
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
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
              labelStyle: TextStyle(
                fontSize: 18,
              ),
              prefixIcon: Icon(
                Icons.calendar_month_rounded,
                color: Color(0xFF8ACDD7),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                  color: Color(0xFFff90BC),
                  width: 2.0,
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            validator: RequiredValidator(errorText: '* Required').call,
          ),
          const SizedBox(height: 24),

          // Note
          TextFormField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Note',
              labelStyle: TextStyle(
                fontSize: 18,
              ),
              prefixIcon: Icon(
                Icons.sticky_note_2_rounded,
                color: Color(0xFF8ACDD7),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                  color: Color(0xFFff90BC),
                  width: 2.0,
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            keyboardType: TextInputType.text,
            validator: MaxLengthValidator(100,
                    errorText: '* Maximum 100 characters allowed')
                .call,
          ),
          const SizedBox(height: 32),

          // Save button
          SizedBox(
            width: double.infinity,
                        height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: Save record
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: const Color(0xFFFF90BC),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
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
            alignment: _currentIndex == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(0xFF9DCD5A),
                        radius: 16,
                        child: Icon(
                          Icons.arrow_downward_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Income',
                        style: TextStyle(
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(0xFFFF5757),
                        radius: 16,
                        child: Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Expense',
                        style: TextStyle(
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
