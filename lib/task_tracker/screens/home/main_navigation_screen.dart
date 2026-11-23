import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../theme/app_theme.dart';
import '../dashboard/dashboard_tab.dart';
import '../profile/profile_tab.dart';
import '../schoolworks/add_edit_schoolwork_screen.dart';
import '../schoolworks/schoolworks_tab.dart';
import '../subjects/subjects_tab.dart';

class MainNavigationScreen extends StatefulWidget {
  final UserModel currentUser;

  const MainNavigationScreen({Key? key, required this.currentUser})
      : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late UserModel _user;
  bool _isDark = false;
  int _refreshKey = 0;

  @override
  void initState() {
    super.initState();
    _user = widget.currentUser;
  }

  void _navigateToIndex(int index) {
    setState(() => _currentIndex = index);
  }

  Future<void> _handleQuickAdd() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const AddEditSchoolworkScreen(),
      ),
    );
    if (result == true) {
      setState(() => _refreshKey++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      DashboardTab(
        key: ValueKey('dash_${_user.userId}_$_refreshKey'),
        currentUser: _user,
        onNavigateToSchoolworks: () => _navigateToIndex(2),
        onNavigateToSubjects: () => _navigateToIndex(1),
      ),
      SubjectsTab(
        key: ValueKey('subj_${_user.userId}_$_refreshKey'),
        currentUser: _user,
      ),
      SchoolworksTab(
        key: ValueKey('works_${_user.userId}_$_refreshKey'),
        currentUser: _user,
      ),
      ProfileTab(
        key: ValueKey('prof_${_user.userId}_$_refreshKey'),
        currentUser: _user,
        isDark: _isDark,
        onThemeToggle: () {
          setState(() => _isDark = !_isDark);
        },
        onUserUpdated: (updated) {
          setState(() => _user = updated);
        },
      ),
    ];

    return Theme(
      data: _isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
      child: Scaffold(
        backgroundColor: AppTheme.paperSurface,
        body: IndexedStack(
          index: _currentIndex,
          children: tabs,
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: AppTheme.doodleShadow(3.0),
          ),
          child: FloatingActionButton(
            onPressed: _handleQuickAdd,
            tooltip: 'Quick Add Schoolwork',
            backgroundColor: AppTheme.pastelYellow,
            foregroundColor: AppTheme.inkColor,
            elevation: 0,
            child: const Icon(Icons.edit_note_rounded, size: 28),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppTheme.paperSurface,
            border: Border(
              top: BorderSide(
                color: AppTheme.outlineVariant.withAlpha(120),
                width: 1,
              ),
            ),
          ),
          child: BottomAppBar(
            elevation: 0,
            color: AppTheme.paperSurface,
            notchMargin: 8,
            shape: const CircularNotchedRectangle(),
            child: SizedBox(
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    index: 0,
                    icon: Icons.dashboard_outlined,
                    selectedIcon: Icons.dashboard_rounded,
                    label: 'Home',
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: Icons.folder_special_outlined,
                    selectedIcon: Icons.folder_special_rounded,
                    label: 'Subjects',
                  ),
                  const SizedBox(width: 48), // Spacer for centered FAB notch
                  _buildNavItem(
                    index: 2,
                    icon: Icons.checklist_rounded,
                    selectedIcon: Icons.task_alt_rounded,
                    label: 'Tasks',
                  ),
                  _buildNavItem(
                    index: 3,
                    icon: Icons.person_outline_rounded,
                    selectedIcon: Icons.person_rounded,
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => _navigateToIndex(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              size: 22,
              color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
