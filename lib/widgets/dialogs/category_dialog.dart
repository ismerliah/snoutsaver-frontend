import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snoutsaver/models/category.dart';

class CategoryDialog extends StatefulWidget {
  final List<Category> categories;
  final Function(Category) onCategorySelected;

  const CategoryDialog({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  _CategoryDialogState createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  Category? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Select Category', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),

      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.8,
          ),
          itemCount: widget.categories.length,
          itemBuilder: (BuildContext context, int index) {
            final category = widget.categories[index];
            final isSelected = _selectedCategory == category;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: isSelected
                        ? const Color(0xFFFF90BC)
                        : const Color(0xFF8ACDD7),
                    child: Icon(
                      category.icon,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(fontSize: 13.0),
                  )
                ],
              ),
            );
          },
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_selectedCategory != null) {
                  widget.onCategorySelected(_selectedCategory!);
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: const Color(0xFFFF90BC),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check, color: Color(0xFFFFFFFF)),
                  const SizedBox(width: 8),
                  Text(
                    'Done',
                    style: GoogleFonts.outfit(color: const Color(0xFFFFFFFF), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
