import 'package:flutter/material.dart';
import '../../models/subject_model.dart';
import '../../models/user_model.dart';
import '../../services/subject_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/notebook_card.dart';
import '../../widgets/subject_card.dart';
import 'add_edit_subject_screen.dart';
import 'subject_detail_screen.dart';

/// TaskTracker Subjects Screen
/// Extracted from Stitch Screen: c092daf5c17143eaa04c6337ba9da574
class SubjectsTab extends StatefulWidget {
  final UserModel currentUser;

  const SubjectsTab({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<SubjectsTab> createState() => _SubjectsTabState();
}

class _SubjectsTabState extends State<SubjectsTab> {
  List<SubjectModel> _subjects = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSubjects() async {
    setState(() => _isLoading = true);
    final userId = widget.currentUser.userId;
    try {
      if (userId != null) {
        final list = await SubjectService.instance.getSubjectsForUser(userId);
        if (mounted) {
          setState(() {
            _subjects = list;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading subjects: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _openAddSubject() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const AddEditSubjectScreen(),
      ),
    );
    if (result == true) {
      _loadSubjects();
    }
  }

  List<SubjectModel> get _filteredSubjects {
    if (_searchQuery.isEmpty) return _subjects;
    final q = _searchQuery.toLowerCase().trim();
    return _subjects.where((s) {
      return s.subjectCode.toLowerCase().contains(q) ||
          s.subjectName.toLowerCase().contains(q) ||
          s.instructorName.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredSubjects;

    return Scaffold(
      backgroundColor: AppTheme.paperSurface,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadSubjects,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                children: [
                  // 1. Header & Semester Badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'My Registered Subjects',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.textPrimary,
                                    ),
                              ),
                              const SizedBox(width: 6),
                              const Text('📚', style: TextStyle(fontSize: 22)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceContainerHigh,
                                  borderRadius: AppTheme.borderRadiusFull,
                                ),
                                child: const Text(
                                  'Semester 1 • 2024–2025',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: AppTheme.tertiary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${_subjects.length} Enrolled',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 2. Search & Add Subject Bar
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppTheme.paperWhite,
                            borderRadius: AppTheme.borderRadiusMd,
                            border: AppTheme.doodleBorder(1.8),
                            boxShadow: AppTheme.doodleShadow(1.5),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) {
                              setState(() => _searchQuery = val);
                            },
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                            decoration: const InputDecoration(
                              hintText:
                                  'Search subjects, codes or professors...',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textOutline,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                size: 20,
                                color: AppTheme.textSecondary,
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Add Subject Pill Button
                      GestureDetector(
                        onTap: _openAddSubject,
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: AppTheme.pastelYellow,
                            borderRadius: AppTheme.borderRadiusFull,
                            border: AppTheme.doodleBorder(1.8),
                            boxShadow: AppTheme.doodleShadow(2.0),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.add_rounded,
                                  size: 18, color: AppTheme.inkColor),
                              SizedBox(width: 4),
                              Text(
                                'Add Subject',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.inkColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 3. Subject Cards Stack
                  if (filtered.isEmpty)
                    NotebookCard(
                      backgroundColor: AppTheme.paperWhite,
                      padding: const EdgeInsets.all(28),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.school_outlined,
                                size: 48, color: AppTheme.textOutline),
                            const SizedBox(height: 12),
                            Text(
                              _searchQuery.isNotEmpty
                                  ? 'No subjects matching "$_searchQuery"'
                                  : 'No subjects enrolled yet',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Add your academic courses (e.g. CS 101, Calculus) to track tasks & exams.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _openAddSubject,
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Add Subject'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...filtered.map((subject) {
                      return SubjectCard(
                        subject: subject,
                        totalWorks: subject.totalWorks,
                        pendingWorks: subject.pendingWorks,
                        onTap: () async {
                          final res = await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder: (_) =>
                                  SubjectDetailScreen(subject: subject),
                            ),
                          );
                          if (res == true) _loadSubjects();
                        },
                        onEdit: () async {
                          final res = await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder: (_) => AddEditSubjectScreen(
                                subjectToEdit: subject,
                              ),
                            ),
                          );
                          if (res == true) _loadSubjects();
                        },
                        onDelete: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Remove Subject?'),
                              content: Text(
                                'Are you sure you want to delete "${subject.subjectName}" (${subject.subjectCode}) and all associated schoolworks?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppTheme.error,
                                  ),
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: const Text('Remove'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            await SubjectService.instance
                                .deleteSubject(subject.subjectId!);
                            _loadSubjects();
                          }
                        },
                      );
                    }).toList(),

                  const SizedBox(height: 8),

                  // 4. Bottom Showcase Banner
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLow,
                      borderRadius: AppTheme.borderRadiusLg,
                      border: AppTheme.doodleBorder(1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'Have another class?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text('✨', style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Click + to add your next subject!',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_downward_rounded,
                          size: 22,
                          color: AppTheme.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
