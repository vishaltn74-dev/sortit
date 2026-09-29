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
    switch (category.icon) {
      case 'ac':
        return [
          Issue(id: 'ac1', categoryId: category.id, name: 'Not cooling'),
          Issue(id: 'ac2', categoryId: category.id, name: 'Water leaking'),
          Issue(id: 'ac3', categoryId: category.id, name: 'Making strange noise'),
          Issue(id: 'ac4', categoryId: category.id, name: 'Won\'t turn on'),
          Issue(id: 'ac5', categoryId: category.id, name: 'Other'),
        ];
      case 'phone':
        return [
          Issue(id: 'ph1', categoryId: category.id, name: 'Screen broken'),
          Issue(id: 'ph2', categoryId: category.id, name: 'Battery draining fast'),
          Issue(id: 'ph3', categoryId: category.id, name: 'Won\'t charge'),
          Issue(id: 'ph4', categoryId: category.id, name: 'Overheating'),
          Issue(id: 'ph5', categoryId: category.id, name: 'Other'),
        ];
      case 'laptop':
        return [
          Issue(id: 'lap1', categoryId: category.id, name: 'Screen blank'),
          Issue(id: 'lap2', categoryId: category.id, name: 'Keyboard not working'),
          Issue(id: 'lap3', categoryId: category.id, name: 'Battery issue'),
          Issue(id: 'lap4', categoryId: category.id, name: 'Overheating'),
          Issue(id: 'lap5', categoryId: category.id, name: 'Other'),
        ];
      case 'bicycle':
        return [
          Issue(id: 'bi1', categoryId: category.id, name: 'Flat tire'),
          Issue(id: 'bi2', categoryId: category.id, name: 'Chain broken'),
          Issue(id: 'bi3', categoryId: category.id, name: 'Brakes not working'),
          Issue(id: 'bi4', categoryId: category.id, name: 'Gears slipping'),
          Issue(id: 'bi5', categoryId: category.id, name: 'Other'),
        ];
      case 'electrical':
        return [
          Issue(id: 'el1', categoryId: category.id, name: 'Short circuit'),
          Issue(id: 'el2', categoryId: category.id, name: 'Light fixture broken'),
          Issue(id: 'el3', categoryId: category.id, name: 'Outlet not working'),
          Issue(id: 'el4', categoryId: category.id, name: 'Wiring issue'),
          Issue(id: 'el5', categoryId: category.id, name: 'Other'),
        ];
      case 'washing_machine':
      default:
        return [
          Issue(id: 'wm1', categoryId: category.id, name: 'Not draining'),
          Issue(id: 'wm2', categoryId: category.id, name: 'Not starting'),
          Issue(id: 'wm3', categoryId: category.id, name: 'Water leaking'),
          Issue(id: 'wm4', categoryId: category.id, name: 'Not spinning'),
          Issue(id: 'wm5', categoryId: category.id, name: 'Making strange noise'),
          Issue(id: 'wm6', categoryId: category.id, name: 'Other'),
        ];
    }
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
