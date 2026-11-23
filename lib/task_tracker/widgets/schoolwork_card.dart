import 'package:flutter/material.dart';
import '../models/schoolwork_with_subject.dart';
import '../theme/app_theme.dart';
import 'doodle_checkbox.dart';
import 'priority_badge.dart';
import 'status_badge.dart';

class SchoolworkCard extends StatelessWidget {
  final SchoolworkWithSubject item;
  final VoidCallback onTap;
  final ValueChanged<bool?> onToggleComplete;
  final Function(String newStatus)? onStatusChange;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const SchoolworkCard({
    Key? key,
    required this.item,
    required this.onTap,
    required this.onToggleComplete,
    this.onStatusChange,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  Color get _tapeColor {
    switch (item.priority.toLowerCase()) {
      case 'high':
        return AppTheme.pastelPink;
      case 'medium':
        return AppTheme.pastelYellow;
      case 'low':
      default:
        return AppTheme.pastelLilac;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = item.isCompleted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Task Card
          InkWell(
            onTap: onTap,
            borderRadius: AppTheme.borderRadiusLg,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(AppTheme.spaceMd),
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppTheme.paperCard
                    : AppTheme.paperWhite,
                borderRadius: AppTheme.borderRadiusLg,
                border: AppTheme.doodleBorder(2.0),
                boxShadow: isCompleted
                    ? AppTheme.doodleShadow(1.5)
                    : AppTheme.doodleShadow(3.0),
              ),
              child: Opacity(
                opacity: isCompleted ? 0.72 : 1.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Subject pill + Priority + Checkbox
                    Row(
                      children: [
                        // Subject Pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: _tapeColor,
                            borderRadius: AppTheme.borderRadiusFull,
                            border: AppTheme.doodleBorder(1.2),
                            boxShadow: AppTheme.doodleShadow(1.0),
                          ),
                          child: Text(
                            item.subjectCode,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.inkColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        PriorityBadge(priority: item.priority, compact: true),
                        const Spacer(),
                        // Custom Hand-drawn Doodle Checkbox
                        DoodleCheckbox(
                          value: isCompleted,
                          onChanged: (val) => onToggleComplete(val),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Title & Description
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                    ),
                    if (item.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ],

                    const SizedBox(height: 10),

                    // Stitched / Dashed divider
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: AppTheme.outlineVariant.withAlpha(90),
                    ),
                    const SizedBox(height: 8),

                    // Footer Row: Due Info + Badge / More options
                    Row(
                      children: [
                        Icon(
                          item.isOverdue || item.isDueToday
                              ? Icons.alarm_rounded
                              : Icons.schedule_rounded,
                          size: 15,
                          color: item.isOverdue || item.isDueToday
                              ? AppTheme.error
                              : AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Due: ${item.dueDate} • ${item.dueTime}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: item.isOverdue || item.isDueToday
                                ? AppTheme.error
                                : AppTheme.textSecondary,
                          ),
                        ),
                        const Spacer(),

                        if (item.isOverdue)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.pastelPink,
                              borderRadius: BorderRadius.circular(4),
                              border: AppTheme.doodleBorder(1.0),
                            ),
                            child: const Text(
                              '⚠️ Overdue',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.pastelPinkDark,
                              ),
                            ),
                          )
                        else if (item.isDueToday)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.pastelYellow,
                              borderRadius: BorderRadius.circular(4),
                              border: AppTheme.doodleBorder(1.0),
                            ),
                            child: const Text(
                              '⚡ Due Today',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.pastelYellowDark,
                              ),
                            ),
                          )
                        else
                          StatusBadge(status: item.status),

                        if (onEdit != null || onDelete != null || onStatusChange != null)
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert_rounded, size: 18),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onSelected: (value) {
                              if (value == 'edit' && onEdit != null) {
                                onEdit!();
                              } else if (value == 'delete' && onDelete != null) {
                                onDelete!();
                              } else if (onStatusChange != null) {
                                onStatusChange!(value);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'Pending',
                                child: Text('Mark as Pending'),
                              ),
                              const PopupMenuItem(
                                value: 'In Progress',
                                child: Text('Mark as In Progress'),
                              ),
                              const PopupMenuItem(
                                value: 'Completed',
                                child: Text('Mark as Completed'),
                              ),
                              if (onEdit != null)
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit Task'),
                                ),
                              if (onDelete != null)
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete Task',
                                      style: TextStyle(color: Colors.red)),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Colored Corner Tape Accent at top right
          Positioned(
            top: -6,
            right: 24,
            child: Container(
              width: 50,
              height: 12,
              decoration: BoxDecoration(
                color: _tapeColor.withAlpha(220),
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: AppTheme.inkColor, width: 1.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
