import 'package:flutter/material.dart';
import 'package:orana/utils/app_colors.dart';

class CustomDropdownList extends StatefulWidget {
  const CustomDropdownList({
    super.key,
    required this.items,
    required this.parentValue,
    required this.initial
  });

  final List<String> items;
  final ValueChanged<String?> parentValue;
  final String initial;

  @override
  State<CustomDropdownList> createState() => _CustomDropdownListState();
}

class _CustomDropdownListState extends State<CustomDropdownList> {
  late String? selectedItem;

  @override
  void initState() {
    selectedItem = widget.initial;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final List<DropdownMenuItem<String>> dropdownItems = widget.items.map((String item) {
      return DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
            color: AppColors.primary,
          ),
        ),
      );
    }).toList();


    return DropdownButton(
      dropdownColor: AppColors.background,
      items: dropdownItems,
      value: selectedItem,
      onChanged: (newValue) {
        setState(() {
          selectedItem = newValue;
        });
        widget.parentValue(newValue);
      },
    );
  }
}
