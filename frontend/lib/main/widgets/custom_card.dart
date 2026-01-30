import 'package:flutter/material.dart';
import 'package:orana/utils/app_colors.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    this.title,
    required this.onTapHandler,
    required this.valueText,
    required this.index,
    required this.items,
    this.customExpansion,
    this.trailing,
    this.trailingColor
  });

  final String? title;
  final int index;
  final List items;
  final String valueText;
  final Function() onTapHandler;
  final Widget? customExpansion;
  final IconData? trailing;
  final Color? trailingColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 5,
      child: ListTile(
        leading: Icon(
          Icons.attach_money_sharp,
          color: AppColors.primary,
        ),
        title: Text(
          title ?? items[index]['name'],
          style: TextStyle(
            color: AppColors.primary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'R\$ $valueText',
              style: TextStyle(
                  color: AppColors.secondary
              ),
            ),
            if (customExpansion != null) ...[
              ?customExpansion
            ],
          ],
        ),
        trailing: Icon(
          trailing ?? Icons.edit,
          color: trailingColor ?? AppColors.primary,
        ),
        onTap: onTapHandler,
      ),
    );
  }
}
