import 'package:flutter/material.dart';
import '../models/subject_model.dart';
import '../theme/app_theme.dart';

class SubjectCard extends StatelessWidget {
  final SubjectModel subject;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final int totalWorks;
  final int pendingWorks;

  const SubjectCard({
    Key? key,
    required this.subject,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.totalWorks = 0,
    this.pendingWorks = 0,
  }) : super(key: key);

  Color _getSubjectPastel(String code) {
    final pastels = [
      AppTheme.pastelLilac,
      AppTheme.pastelYellow,
      AppTheme.pastelMint,
      AppTheme.pastelPink,
      AppTheme.pastelBlue,
    ];
    final hash = code.hashCode.abs();
    return pastels[hash % pastels.length];
  }

  @override
  Widget build(BuildContext context) {
    final pastelColor = _getSubjectPastel(subject.subjectCode);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Folder Divider Card
          InkWell(
            onTap: onTap,
            borderRadius: AppTheme.borderRadiusLg,
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spaceMd),
              decoration: BoxDecoration(
                color: AppTheme.paperWhite,
                borderRadius: AppTheme.borderRadiusLg,
                border: AppTheme.doodleBorder(2.0),
                boxShadow: AppTheme.doodleShadow(3.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Code Pill & Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: pastelColor,
                          borderRadius: BorderRadius.circular(6),
                          border: AppTheme.doodleBorder(1.2),
                          boxShadow: AppTheme.doodleShadow(1.0),
                        ),
                        child: Text(
                          subject.subjectCode,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.inkColor,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          if (onEdit != null)
                            IconButton(
                              icon: const Icon(Icons.edit_rounded, size: 18),
                              onPressed: onEdit,
                              tooltip: 'Edit Subject',
                              visualDensity: VisualDensity.compact,
                              splashRadius: 18,
                            ),
                          if (onDelete != null)
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded,
                                  size: 18, color: AppTheme.error),
                              onPressed: onDelete,
                              tooltip: 'Delete Subject',
                              visualDensity: VisualDensity.compact,
                              splashRadius: 18,
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Subject Name
                  Text(
                    subject.subjectName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                          height: 1.2,
                        ),
                  ),
                  const SizedBox(height: 8),

                  // Instructor Row with Illustrated Avatar placeholder
                  Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: pastelColor.withAlpha(180),
                          shape: BoxShape.circle,
                          border: AppTheme.doodleBorder(1.2),
                        ),
                        child: const Center(
                          child: Icon(Icons.person_rounded,
                              size: 16, color: AppTheme.inkColor),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        subject.instructorName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Stitched divider
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: AppTheme.outlineVariant.withAlpha(90),
                  ),
                  const SizedBox(height: 10),

                  // Footer: Schoolworks count & View Details link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.assignment_rounded,
                            size: 16,
                            color: AppTheme.tertiary,
                          ),
                          const SizedBox(width: 5),
                          if (totalWorks > 0)
                            Text(
                              pendingWorks > 0
                                  ? '$totalWorks Schoolworks ($pendingWorks Pending)'
                                  : '$totalWorks Schoolworks (Completed 🎉)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: pendingWorks > 0
                                    ? AppTheme.textSecondary
                                    : AppTheme.tertiary,
                              ),
                            )
                          else
                            const Text(
                              'Tap to view details',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: const [
                          Text(
                            'View Details',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primary,
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: AppTheme.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Simulated Top Folder Tab Accent
          Positioned(
            top: -6,
            left: 28,
            child: Container(
              width: 60,
              height: 7,
              decoration: BoxDecoration(
                color: pastelColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
                border: const Border(
                  top: BorderSide(color: AppTheme.inkColor, width: 1.5),
                  left: BorderSide(color: AppTheme.inkColor, width: 1.5),
                  right: BorderSide(color: AppTheme.inkColor, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
