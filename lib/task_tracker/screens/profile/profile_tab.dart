import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/schoolwork_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/notebook_card.dart';
import '../auth/login_screen.dart';

class ProfileTab extends StatefulWidget {
  final UserModel currentUser;
  final ValueChanged<UserModel> onUserUpdated;
  final VoidCallback onThemeToggle;
  final bool isDark;

  const ProfileTab({
    Key? key,
    required this.currentUser,
    required this.onUserUpdated,
    required this.onThemeToggle,
    required this.isDark,
  }) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late UserModel _user;

  @override
  void initState() {
    super.initState();
    _user = widget.currentUser;
  }

  Future<void> _showEditProfileDialog() async {
    final fNameCtrl = TextEditingController(text: _user.fName);
    final lNameCtrl = TextEditingController(text: _user.lName);
    final gmailCtrl = TextEditingController(text: _user.gmail);
    final passCtrl = TextEditingController(text: _user.password);
    final formKey = GlobalKey<FormState>();

    final updated = await showDialog<UserModel?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Student Profile'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: fNameCtrl,
                  style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                  cursorColor: AppTheme.inkColor,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: lNameCtrl,
                  style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                  cursorColor: AppTheme.inkColor,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: gmailCtrl,
                  style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                  cursorColor: AppTheme.inkColor,
                  decoration: const InputDecoration(labelText: 'Gmail / Email'),
                  validator: (v) =>
                      v!.contains('@') ? null : 'Valid email required',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: passCtrl,
                  style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                  cursorColor: AppTheme.inkColor,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (v) =>
                      v!.length >= 6 ? null : 'At least 6 characters',
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  final newUser = await AuthService.instance.updateProfile(
                    userId: _user.userId!,
                    fName: fNameCtrl.text,
                    lName: lNameCtrl.text,
                    gmail: gmailCtrl.text,
                    password: passCtrl.text,
                  );
                  Navigator.of(ctx).pop(newUser);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (updated != null) {
      setState(() => _user = updated);
      widget.onUserUpdated(updated);
    }
  }

  Future<void> _handleResetData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset & Reseed Demo Data?'),
        content: const Text(
          'This will restore sample academic subjects and schoolworks for testing.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppTheme.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final uId = _user.userId ?? 0;
      await SchoolworkService.instance.reseedDemoData(uId);
      final fresh = await AuthService.instance.loadCurrentSession();
      if (fresh != null) {
        setState(() => _user = fresh);
        widget.onUserUpdated(fresh);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Demo academic data reseeded successfully! 📚')),
      );
    }
  }

  void _showErdInfo() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.account_tree_outlined, color: AppTheme.primary),
            SizedBox(width: 8),
            Text('School Works ERD Info'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '1. Users Table (users)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• PK: user_id\n• fName, lName, gmail, password'),
              SizedBox(height: 10),
              Text(
                '2. Subject Table (subject)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  '• PK: subject_id\n• FK: user_id\n• subject_code, subject_name, instructor_name'),
              SizedBox(height: 10),
              Text(
                '3. Schoolwork Table (schoolwork)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  '• PK: work_id\n• FK: subject_id\n• title, description, due_date, due_time, priority, status'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paperSurface,
      appBar: AppBar(
        title: const Text('Student Profile & Settings ⚙️'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // 1. Profile Header Card
          NotebookCard(
            backgroundColor: AppTheme.paperWhite,
            hasWashiTape: true,
            washiColor: AppTheme.pastelYellow.withAlpha(220),
            washiText: 'Academic ID',
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppTheme.pastelYellow,
                    shape: BoxShape.circle,
                    border: AppTheme.doodleBorder(2.0),
                    boxShadow: AppTheme.doodleShadow(2.0),
                  ),
                  child: Center(
                    child: Text(
                      _user.initials,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.inkColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _user.fullName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  _user.gmail,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  icon: const Icon(Icons.edit_rounded, size: 16),
                  label: const Text('Edit Profile'),
                  onPressed: _showEditProfileDialog,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 2. Settings & Tools Menu
          NotebookCard(
            backgroundColor: AppTheme.paperWhite,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.account_tree_rounded,
                      color: AppTheme.primary),
                  title: const Text(
                    'School Works ERD Details',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Inspect database tables, keys and relationships',
                    style: TextStyle(fontSize: 11),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: _showErdInfo,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.restore_rounded,
                      color: AppTheme.secondary),
                  title: const Text(
                    'Reset & Reseed Demo Data',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Restore sample subjects and schoolwork items',
                    style: TextStyle(fontSize: 11),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: _handleResetData,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.nightlight_round,
                      color: AppTheme.tertiary),
                  title: const Text(
                    'Night Study Theme',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Switch between paper planner and dark mode',
                    style: TextStyle(fontSize: 11),
                  ),
                  trailing: Switch.adaptive(
                    value: widget.isDark,
                    activeThumbColor: AppTheme.primary,
                    onChanged: (_) => widget.onThemeToggle(),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout_rounded,
                      color: AppTheme.error),
                  title: const Text(
                    'Log Out',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: AppTheme.error,
                    ),
                  ),
                  onTap: _handleLogout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
