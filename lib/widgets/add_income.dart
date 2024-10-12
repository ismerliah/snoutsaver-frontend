import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snoutsaver/mock_data.dart';
import 'package:snoutsaver/models/category.dart';
import 'package:snoutsaver/widgets/dialogs/category_dialog.dart';

class AddIncome extends StatefulWidget {
  const AddIncome({super.key});

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  IconData _selectedCategoryIcon = Icons.category_rounded;
  DateTime? _selectedDate;

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
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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

          // Title: Add income
          const Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFF8ACDD7),
                radius: 25,
                child: Icon(
                  Icons.arrow_downward_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              SizedBox(width: 16),
              Text(
                'Add income',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Amount
          const TextField(
            decoration: InputDecoration(
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
          ),
          const SizedBox(height: 24),
          
          // Category
          TextField(
            controller: _categoryController,
            readOnly: true,
            onTap: () {
              _selectCategory(context, incomeCategories);
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
          ),
          const SizedBox(height: 24),
          
          // Date
          TextField(
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
          ),
          const SizedBox(height: 24),
          
          // Note
          const TextField(
            decoration: InputDecoration(
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
          ),
          const SizedBox(height: 32),
          
          // Save button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
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
                  color: Color(0xFFFFFFFF),
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