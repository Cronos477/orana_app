import 'package:flutter/material.dart';
import 'package:orana/main/services/get_data.dart';
import 'package:orana/utils/app_colors.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMenu(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                    color: AppColors.primary
                ),
              ),
            );
          } else if (snapshot.hasData) {
            List menuItems = snapshot.data;
            return Scaffold(
              backgroundColor: AppColors.background,
              floatingActionButton: FloatingActionButton(
                backgroundColor: AppColors.primary,
                onPressed: () async {
                  
                },
                child: Icon(
                  Icons.add,
                  color: AppColors.icons,
                ),
              ),
              body: ListView.builder(
                itemCount: menuItems.length,
                padding: const EdgeInsetsGeometry.symmetric(vertical: 8),
                itemBuilder: (BuildContext context, int index) {
                  return Placeholder();
                }
              ),
            );
          }
          return Center(
            child: Text(
              'Sem dados.',
              style: TextStyle(
                  color: AppColors.primary
              ),
            ),
          );
      }
    );
  }
}
