import 'package:flutter/material.dart';
import 'package:sortit/models/category.dart';
import 'package:sortit/models/issue.dart';
import 'package:sortit/theme/app_theme.dart';
import 'package:sortit/widgets/issue_tile.dart';
import 'package:sortit/screens/diagnosis/diagnosis_screen.dart';

class CategoryScreen extends StatelessWidget {
  final Category category;

  const CategoryScreen({super.key, required this.category});

  List<Issue> _getIssues() {
    return [
      Issue(id: '1', categoryId: category.id, name: 'Not draining'),
      Issue(id: '2', categoryId: category.id, name: 'Not starting'),
      Issue(id: '3', categoryId: category.id, name: 'Water leaking'),
      Issue(id: '4', categoryId: category.id, name: 'Not spinning'),
      Issue(id: '5', categoryId: category.id, name: 'Making strange noise'),
      Issue(id: '6', categoryId: category.id, name: 'Other'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final issues = _getIssues();
    
    return Scaffold(
      backgroundColor: AppTheme.bgLightGrey,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Image.asset(
              'assets/images/bg_gradient.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  foregroundColor: AppTheme.pureWhite,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(category.name),
                ),
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'Select Issue',
                    style: TextStyle(
                      color: AppTheme.pureWhite,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppTheme.pureWhite,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 32, left: 24, right: 24),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: issues.length,
                      itemBuilder: (context, index) {
                        return IssueTile(
                          issue: issues[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DiagnosisScreen(
                                  category: category,
                                  issue: issues[index],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
