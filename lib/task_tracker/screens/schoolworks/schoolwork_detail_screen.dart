import 'package:flutter/material.dart';
import '../../models/schoolwork_with_subject.dart';
import '../../services/notification_service.dart';
import '../../services/schoolwork_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/notebook_card.dart';
import '../../widgets/priority_badge.dart';
import '../../widgets/status_badge.dart';
import 'add_edit_schoolwork_screen.dart';

class SchoolworkDetailScreen extends StatefulWidget {
  final SchoolworkWithSubject item;
  
  const SchoolworkDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<SchoolworkDetailScreen> createState() => _SchoolworkDetailScreenState();
}

class _SchoolworkDetailScreenState extends State<SchoolworkDetailScreen> {
  late SchoolworkWithSubject _item;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
  }

  Future<void> _updateStatus(String newStatus) async {
    setState(() => _isLoading = true);
    await SchoolworkService.instance.updateStatus(_item.workId!, newStatus);
    setState(() {
      final updatedWork = _item.schoolwork.copyWith(status: newStatus);
      _item = SchoolworkWithSubject(
        schoolwork: updatedWork,
        subject: _item.subject,
      );
      _isLoading = false;
    });

    if (newStatus == 'Completed') {
      await NotificationService.instance.cancelNotification(_item.workId!);
    }
  }

  Future<void> _handleEdit() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddEditSchoolworkScreen(
          schoolworkToEdit: _item.schoolwork,
        ),
      ),
    );
    if (result == true && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Schoolwork?'),
        content: Text('Are you sure you want to delete "${_item.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppTheme.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await SchoolworkService.instance.deleteSchoolwork(_item.workId!);
      await NotificationService.instance.cancelNotification(_item.workId!);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _triggerReminderAlert() async {
    await NotificationService.instance.scheduleSchoolworkReminder(
      _item.schoolwork,
      _item.subject,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Gentle reminder notification scheduled! 🔔',
          style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.inkColor),
        ),
        backgroundColor: AppTheme.pastelYellow,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppTheme.inkColor, width: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paperSurface,
      appBar: AppBar(
        title: const Text('Schoolwork Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            tooltip: 'Trigger Gentle Reminder',
            onPressed: _triggerReminderAlert,
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Schoolwork',
            onPressed: _handleEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppTheme.error),
            tooltip: 'Delete Schoolwork',
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Relative Due Notice Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: _item.isOverdue
                          ? AppTheme.pastelPink
                          : (_item.isCompleted
                              ? AppTheme.pastelMint
                              : AppTheme.pastelYellow),
                      borderRadius: AppTheme.borderRadiusMd,
                      border: AppTheme.doodleBorder(1.8),
                      boxShadow: AppTheme.doodleShadow(2.0),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _item.isOverdue
                              ? Icons.warning_amber_rounded
                              : (_item.isCompleted
                                  ? Icons.check_circle_rounded
                                  : Icons.alarm_rounded),
                          color: _item.isOverdue
                              ? AppTheme.pastelPinkDark
                              : (_item.isCompleted
                                  ? AppTheme.pastelMintDark
                                  : AppTheme.onPrimaryFixedVariant),
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _item.dueRelativeText,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: _item.isOverdue
                                  ? AppTheme.pastelPinkDark
                                  : (_item.isCompleted
                                      ? AppTheme.pastelMintDark
                                      : AppTheme.onPrimaryFixedVariant),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Assignment Sheet Notebook Card
                  NotebookCard(
                    backgroundColor: AppTheme.paperWhite,
                    hasWashiTape: true,
                    washiText: _item.subjectCode,
                    washiColor: AppTheme.pastelLilac.withAlpha(220),
                    showRuledLines: true,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Subject & Professor info
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.pastelLilac,
                                borderRadius: BorderRadius.circular(6),
                                border: AppTheme.doodleBorder(1.2),
                              ),
                              child: Text(
                                _item.subjectCode,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.inkColor,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _item.subjectName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_item.instructorName.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: Text(
                              'Instructor: ${_item.instructorName}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 14),

                        // Title (ERD: title)
                        Text(
                          _item.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                                decoration: _item.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                        ),
                        const SizedBox(height: 12),

                        // Badges: Priority & Status
                        Row(
                          children: [
                            PriorityBadge(priority: _item.priority),
                            const SizedBox(width: 8),
                            StatusBadge(
                                status: _item.status, isOverdue: _item.isOverdue),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Deadline Box
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceContainerLow,
                            borderRadius: AppTheme.borderRadiusDefault,
                            border: AppTheme.doodleBorder(1.2),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded,
                                  size: 18, color: AppTheme.primary),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'DEADLINE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    '${_item.dueDate} at ${_item.dueTime}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Description / Instructions
                        const Text(
                          'Instructions & Details',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.paperSurface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.outlineVariant.withAlpha(120),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _item.description.isNotEmpty
                                ? _item.description
                                : 'No additional guidelines recorded for this schoolwork.',
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 3. Status Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Update Status',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatusButton(
                                label: 'Pending',
                                color: AppTheme.pastelYellow,
                                isSelected: _item.status == 'Pending',
                                onTap: () => _updateStatus('Pending'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildStatusButton(
                                label: 'In Progress',
                                color: AppTheme.pastelLilac,
                                isSelected: _item.status == 'In Progress',
                                onTap: () => _updateStatus('In Progress'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildStatusButton(
                                label: 'Completed',
                                color: AppTheme.pastelMint,
                                isSelected: _item.status == 'Completed',
                                onTap: () => _updateStatus('Completed'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusButton({
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: isSelected ? color : AppTheme.paperWhite,
          borderRadius: BorderRadius.circular(10),
          border: AppTheme.doodleBorder(isSelected ? 2.0 : 1.5),
          boxShadow: isSelected
              ? AppTheme.doodleShadow(1.5)
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    offset: const Offset(1, 1),
                    blurRadius: 1,
                  ),
                ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: isSelected ? AppTheme.inkColor : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
