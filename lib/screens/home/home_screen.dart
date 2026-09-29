import 'package:flutter/material.dart';
import 'package:sortit/theme/app_theme.dart';
import 'package:sortit/models/category.dart';
import 'package:sortit/widgets/category_card.dart';
import 'package:sortit/screens/category/category_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Category> categories = const [
    Category(id: '1', name: 'AC', icon: 'ac'),
    Category(id: '2', name: 'Phone', icon: 'phone'),
    Category(id: '3', name: 'Washing Machine', icon: 'washing_machine'),
    Category(id: '4', name: 'Laptop', icon: 'laptop'),
    Category(id: '5', name: 'Bicycle', icon: 'bicycle'),
    Category(id: '6', name: 'Electrical', icon: 'electrical'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.royalBlue,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SortIt',
                    style: TextStyle(
                      color: AppTheme.pureWhite,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Something\'s broken?',
                    style: TextStyle(
                      color: AppTheme.pureWhite,
                      fontSize: 36,
                      fontWeight: FontWeight.w300,
                      height: 1.2,
                    ),
                  ),
                  const Text(
                    'SortIt.',
                    style: TextStyle(
                      color: AppTheme.pureWhite,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Hero(
                      tag: 'hero_icon',
                      child: Container(
                        height: 160,
                        width: 160,
                        decoration: const BoxDecoration(
                          color: AppTheme.lightBlueBg,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.handyman,
                          size: 80,
                          color: AppTheme.accentYellow,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.pureWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What needs fixing?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return CategoryCard(
                            category: categories[index],
                            isBlack: index == 0,
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => 
                                      CategoryScreen(category: categories[index]),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutCubic,
                                      )),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
