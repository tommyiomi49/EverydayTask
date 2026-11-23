import 'package:flutter/material.dart';
import '../../models/schoolwork_with_subject.dart';
import '../../models/subject_model.dart';
import '../../services/schoolwork_service.dart';
import '../../services/subject_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/notebook_card.dart';
import '../../widgets/ruler_progress_bar.dart';
import '../../widgets/schoolwork_card.dart';
import '../schoolworks/add_edit_schoolwork_screen.dart';
import '../schoolworks/schoolwork_detail_screen.dart';
import 'add_edit_subject_screen.dart';

class SubjectDetailScreen extends StatefulWidget {
  final SubjectModel subject;

  const SubjectDetailScreen({Key? key, required this.subject}) : super(key: key);

  @override
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> {
  late SubjectModel _subject;
  List<SchoolworkWithSubject> _works = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _subject = widget.subject;
    _loadSubjectData();
  }

  Future<void> _loadSubjectData() async {
    setState(() => _isLoading = true);
    final freshSubject =
        await SubjectService.instance.getSubjectById(_subject.subjectId!);
    final works = await SchoolworkService.instance
        .getSchoolworksForSubject(_subject.subjectId!);

    setState(() {
      if (freshSubject != null) _subject = freshSubject;
      _works = works;
      _isLoading = false;
    });
  }

  Future<void> _handleEditSubject() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddEditSubjectScreen(subjectToEdit: _subject),
      ),
    );
    if (result == true) {
      _loadSubjectData();
    }
  }

  Future<void> _handleDeleteSubject() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Subject?'),
        content: Text(
          'Are you sure you want to delete "${_subject.subjectName}" (${_subject.subjectCode})?\n\nThis will also delete all ${_works.length} schoolworks under this subject.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppTheme.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await SubjectService.instance.deleteSubject(_subject.subjectId!);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _handleAddSchoolwork() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddEditSchoolworkScreen(
          preselectedSubjectId: _subject.subjectId,
        ),
      ),
    );
    if (result == true) {
      _loadSubjectData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paperSurface,
      appBar: AppBar(
        title: Text(_subject.subjectCode),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Subject',
            onPressed: _handleEditSubject,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppTheme.error),
            tooltip: 'Delete Subject',
            onPressed: _handleDeleteSubject,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.pastelYellow,
        foregroundColor: AppTheme.inkColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.inkColor, width: 2),
        ),
        icon: const Icon(Icons.edit_note_rounded, size: 24),
        label: const Text(
          'Add Schoolwork',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        onPressed: _handleAddSchoolwork,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadSubjectData,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                children: [
                  // 1. Subject Folder Divider Hero Card
                  NotebookCard(
                    backgroundColor: AppTheme.paperWhite,
                    hasWashiTape: true,
                    washiText: 'Enrolled Course',
                    washiColor: AppTheme.pastelLilac.withAlpha(220),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.pastelLilac,
                                borderRadius: BorderRadius.circular(6),
                                border: AppTheme.doodleBorder(1.2),
                                boxShadow: AppTheme.doodleShadow(1.0),
                              ),
                              child: Text(
                                _subject.subjectCode,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.inkColor,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceContainerLow,
                                borderRadius: AppTheme.borderRadiusFull,
                                border: AppTheme.doodleBorder(1.0),
                              ),
                              child: Text(
                                '${_subject.completedWorks}/${_subject.totalWorks} Completed',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _subject.subjectName,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.person_rounded,
                                size: 16, color: AppTheme.textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              'Instructor: ${_subject.instructorName}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Ruler Progress
                        RulerProgressBar(
                          progress: _subject.progress,
                          label: 'Subject Progress',
                        ),
                      ],
                    ),
                  ),

                  // 2. Section Header: Schoolworks
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Text('📋', style: TextStyle(fontSize: 18)),
                            SizedBox(width: 6),
                            Text(
                              'Enrolled Schoolworks',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${_works.length} Tasks',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 3. Schoolworks List
                  if (_works.isEmpty)
                    NotebookCard(
                      backgroundColor: AppTheme.paperWhite,
                      padding: const EdgeInsets.all(28),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.checklist_rounded,
                                size: 48, color: AppTheme.textOutline),
                            const SizedBox(height: 10),
                            const Text(
                              'No assignments added yet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Tap "+ Add Schoolwork" below to log assignments, readings or problem sets.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 14),
                            ElevatedButton.icon(
                              onPressed: _handleAddSchoolwork,
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Add Schoolwork'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ..._works.map((item) {
                      return SchoolworkCard(
                        item: item,
                        onTap: () async {
                          final res = await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder: (_) => SchoolworkDetailScreen(item: item),
                            ),
                          );
                          if (res == true) _loadSubjectData();
                        },
                        onToggleComplete: (val) async {
                          await SchoolworkService.instance
                              .toggleCompleted(item.workId!, val ?? false);
                          _loadSubjectData();
                        },
                        onStatusChange: (newStatus) async {
                          await SchoolworkService.instance
                              .updateStatus(item.workId!, newStatus);
                          _loadSubjectData();
                        },
                        onEdit: () async {
                          final res = await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder: (_) => AddEditSchoolworkScreen(
                                schoolworkToEdit: item.schoolwork,
                              ),
                            ),
                          );
                          if (res == true) _loadSubjectData();
                        },
                        onDelete: () async {
                          await SchoolworkService.instance
                              .deleteSchoolwork(item.workId!);
                          _loadSubjectData();
                        },
                      );
                    }).toList(),
                ],
              ),
            ),
    );
  }
}
