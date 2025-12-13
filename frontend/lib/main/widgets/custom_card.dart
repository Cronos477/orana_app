import 'package:flutter/material.dart';
import 'package:orana/utils/app_colors.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.onTapHandler,
    required this.valueText,
    required this.index,
    required this.items,
    this.customExpansion
  });

  final int index;
  final List items;
  final String valueText;
  final Function() onTapHandler;
  final Widget? customExpansion;

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
          items[index]['name'],
          style: TextStyle(
            color: AppColors.primary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: customExpansion == null ? 0 : 8),
              child: Text(
                'R\$ $valueText',
                style: TextStyle(
                    color: AppColors.secondary
                ),
              ),
            ),
            if (customExpansion != null) ...[
              ?customExpansion
            ],
          ],
        ),
        trailing: Icon(
          Icons.edit,
          color: AppColors.primary,
        ),
        onTap: onTapHandler,
      ),
    );
  }
}
