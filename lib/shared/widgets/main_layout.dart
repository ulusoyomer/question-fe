import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ai_question_generator/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ai_question_generator/generated/locale_keys.g.dart';
import 'package:ai_question_generator/features/home/presentation/pages/home_page.dart';
import 'package:ai_question_generator/features/pdf_workspace/presentation/pages/pdf_workspace_page.dart';
import 'package:ai_question_generator/features/history/presentation/pages/history_page.dart';
import 'package:ai_question_generator/features/profile/presentation/pages/profile_page.dart';
@RoutePage()
class MainLayoutPage extends StatefulWidget {
  const MainLayoutPage({super.key});
  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}
class _MainLayoutPageState extends State<MainLayoutPage> {
  int _currentIndex = 0;
  int? _selectedSessionId;
  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomePage(
            key: ValueKey('home_$locale'),
            onTabChange: (index) {
              setState(() {
                _currentIndex = index;
                _selectedSessionId = null; 
              });
            },
          ),
          PdfWorkspacePage(
            key: ValueKey('pdf_$locale'),
            sessionId: _selectedSessionId,
          ),
          HistoryPage(
            key: ValueKey('history_$locale'),
            onTabChange: (index, {int? sessionId}) {
              setState(() {
                _currentIndex = index;
                _selectedSessionId = sessionId;
              });
              if (sessionId != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Loading session #$sessionId...'),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'OK',
                      onPressed: () {},
                    ),
                  ),
                );
              }
            },
          ),
          ProfilePage(key: ValueKey('profile_$locale')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentIndex = 1;
            _selectedSessionId = null;
          });
        },
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomAppBar(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 70,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          color: Colors.white,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem(0, Icons.grid_view_rounded, LocaleKeys.menu_home.tr()),
              _buildTabItem(1, Icons.picture_as_pdf_rounded, LocaleKeys.menu_pdf.tr()),
              const SizedBox(width: 48),
              _buildTabItem(2, Icons.history_rounded, LocaleKeys.menu_history.tr()),
              _buildTabItem(3, Icons.person_outline_rounded, LocaleKeys.menu_profile.tr()),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildTabItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
          if (index != 1) {
            _selectedSessionId = null;
          }
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
