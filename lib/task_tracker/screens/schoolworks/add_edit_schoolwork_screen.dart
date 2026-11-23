import 'package:flutter/material.dart';
import '../../models/schoolwork_model.dart';
import '../../models/subject_model.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import '../../services/schoolwork_service.dart';
import '../../services/subject_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/notebook_card.dart';

class AddEditSchoolworkScreen extends StatefulWidget {
  final SchoolworkModel? schoolworkToEdit;
  final int? preselectedSubjectId;

  const AddEditSchoolworkScreen({
    Key? key,
    this.schoolworkToEdit,
    this.preselectedSubjectId,
  }) : super(key: key);

  @override
  State<AddEditSchoolworkScreen> createState() => _AddEditSchoolworkScreenState();
}

class _AddEditSchoolworkScreenState extends State<AddEditSchoolworkScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;

  int? _selectedSubjectId;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 23, minute: 59);
  String _selectedPriority = 'Medium';
  String _selectedStatus = 'Pending';
  bool _setReminder = true;

  List<SubjectModel> _availableSubjects = [];
  bool _isLoading = false;
  bool _isSaving = false;

  bool get isEditing => widget.schoolworkToEdit != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.schoolworkToEdit?.title ?? '',
    );
    _descController = TextEditingController(
      text: widget.schoolworkToEdit?.description ?? '',
    );

    if (isEditing) {
      final work = widget.schoolworkToEdit!;
      _selectedSubjectId = work.subjectId;
      _selectedPriority = work.priority;
      _selectedStatus = work.status;

      try {
        final dParts = work.dueDate.split('-').map(int.parse).toList();
        _selectedDate = DateTime(dParts[0], dParts[1], dParts[2]);
      } catch (_) {}

      try {
        final tParts = work.dueTime.split(':').map(int.parse).toList();
        _selectedTime = TimeOfDay(hour: tParts[0], minute: tParts[1]);
      } catch (_) {}
    } else {
      _selectedSubjectId = widget.preselectedSubjectId;
    }

    _loadSubjects();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _loadSubjects() async {
    setState(() => _isLoading = true);
    final user = AuthService.instance.currentUser;
    if (user != null && user.userId != null) {
      final list =
          await SubjectService.instance.getSubjectsForUser(user.userId!);
      setState(() {
        _availableSubjects = list;
        if (_selectedSubjectId == null && list.isNotEmpty) {
          _selectedSubjectId = list.first.subjectId;
        }
      });
    }
    setState(() => _isLoading = false);
  }

  String _formatDate(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: Colors.white,
              surface: AppTheme.paperSurface,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: Colors.white,
              surface: AppTheme.paperSurface,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSubjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select or enroll in a subject first.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final dueDateStr = _formatDate(_selectedDate);
      final dueTimeStr = _formatTime(_selectedTime);

      SchoolworkModel savedWork;
      if (isEditing) {
        final updated = widget.schoolworkToEdit!.copyWith(
          subjectId: _selectedSubjectId!,
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          dueDate: dueDateStr,
          dueTime: dueTimeStr,
          priority: _selectedPriority,
          status: _selectedStatus,
        );
        await SchoolworkService.instance.updateSchoolwork(updated);
        savedWork = updated;
      } else {
        final newWork = SchoolworkModel(
          subjectId: _selectedSubjectId!,
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          dueDate: dueDateStr,
          dueTime: dueTimeStr,
          priority: _selectedPriority,
          status: _selectedStatus,
        );
        savedWork = await SchoolworkService.instance.addSchoolwork(newWork);
      }

      // Schedule gentle reminder
      if (_setReminder && !savedWork.isCompleted) {
        final matchedSubject = _availableSubjects.firstWhere(
          (s) => s.subjectId == _selectedSubjectId,
          orElse: () => SubjectModel(
            userId: 0,
            subjectCode: 'TASK',
            subjectName: 'Academic Task',
            instructorName: '',
          ),
        );
        await NotificationService.instance.scheduleSchoolworkReminder(
          savedWork,
          matchedSubject,
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save task: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paperSurface,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Schoolwork' : 'New Schoolwork 📝'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded, size: 26),
            tooltip: 'Save Task',
            onPressed: _isSaving ? null : _handleSave,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    NotebookCard(
                      backgroundColor: AppTheme.paperWhite,
                      hasWashiTape: true,
                      washiColor: AppTheme.pastelYellow.withAlpha(220),
                      washiText: isEditing ? 'Edit Mode' : 'New Entry',
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Subject Dropdown
                          const Text(
                            'Academic Subject',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<int>(
                            initialValue: _selectedSubjectId,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              prefixIcon: const Icon(Icons.folder_special_rounded,
                                  size: 20),
                            ),
                            items: _availableSubjects.map((s) {
                              return DropdownMenuItem<int>(
                                value: s.subjectId,
                                child: Text(
                                  '[${s.subjectCode}] ${s.subjectName}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) =>
                                setState(() => _selectedSubjectId = val),
                            validator: (val) =>
                                val == null ? 'Please select a subject' : null,
                          ),
                          const SizedBox(height: 16),

                          // Title Field
                          const Text(
                            'Schoolwork Title',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _titleController,
                            style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                            cursorColor: AppTheme.inkColor,
                            decoration: InputDecoration(
                              hintText: 'e.g. Algorithm Analysis Paper',
                              prefixIcon: const Icon(Icons.edit_note_rounded,
                                  size: 20),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Please enter a schoolwork title';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Description Field
                          const Text(
                            'Instructions & Guidelines',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _descController,
                            maxLines: 3,
                            style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                            cursorColor: AppTheme.inkColor,
                            decoration: InputDecoration(
                              hintText:
                                  'Submit PDF to portal • Chapters 3 & 4...',
                              alignLabelWithHint: true,
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(bottom: 36),
                                child: Icon(Icons.notes_rounded, size: 20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Due Date & Time Pickers
                          const Text(
                            'Submission Deadline',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              // Due Date
                              Expanded(
                                child: InkWell(
                                  onTap: _pickDate,
                                  borderRadius: BorderRadius.circular(12),
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.calendar_month_rounded,
                                          size: 18),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                    ),
                                    child: Text(
                                      _formatDate(_selectedDate),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Due Time
                              Expanded(
                                child: InkWell(
                                  onTap: _pickTime,
                                  borderRadius: BorderRadius.circular(12),
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.access_time_rounded,
                                          size: 18),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                    ),
                                    child: Text(
                                      _selectedTime.format(context),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // Priority Selector
                          const Text(
                            'Priority Level',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildPillChoice(
                                label: 'High 🔴',
                                color: AppTheme.pastelPink,
                                isSelected: _selectedPriority == 'High',
                                onTap: () =>
                                    setState(() => _selectedPriority = 'High'),
                              ),
                              const SizedBox(width: 8),
                              _buildPillChoice(
                                label: 'Medium 🟡',
                                color: AppTheme.pastelYellow,
                                isSelected: _selectedPriority == 'Medium',
                                onTap: () =>
                                    setState(() => _selectedPriority = 'Medium'),
                              ),
                              const SizedBox(width: 8),
                              _buildPillChoice(
                                label: 'Low 🟢',
                                color: AppTheme.pastelMint,
                                isSelected: _selectedPriority == 'Low',
                                onTap: () =>
                                    setState(() => _selectedPriority = 'Low'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // Status Selector
                          const Text(
                            'Current Status',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildPillChoice(
                                label: 'Pending',
                                color: AppTheme.pastelYellow,
                                isSelected: _selectedStatus == 'Pending',
                                onTap: () =>
                                    setState(() => _selectedStatus = 'Pending'),
                              ),
                              const SizedBox(width: 6),
                              _buildPillChoice(
                                label: 'In Progress',
                                color: AppTheme.pastelLilac,
                                isSelected: _selectedStatus == 'In Progress',
                                onTap: () => setState(
                                    () => _selectedStatus = 'In Progress'),
                              ),
                              const SizedBox(width: 6),
                              _buildPillChoice(
                                label: 'Completed',
                                color: AppTheme.pastelMint,
                                isSelected: _selectedStatus == 'Completed',
                                onTap: () => setState(
                                    () => _selectedStatus = 'Completed'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Reminder Toggle
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(10),
                              border: AppTheme.doodleBorder(1.2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.notifications_active_rounded,
                                        size: 20, color: AppTheme.primary),
                                    SizedBox(width: 8),
                                    Text(
                                      'Smart Gentle Reminder',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                Switch.adaptive(
                                  value: _setReminder,
                                  activeThumbColor: AppTheme.primary,
                                  onChanged: (val) =>
                                      setState(() => _setReminder = val),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Primary Submit Button
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _handleSave,
                        child: _isSaving
                            ? const CircularProgressIndicator()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isEditing
                                        ? 'Update Schoolwork'
                                        : 'Save Schoolwork',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.check_circle_rounded,
                                      size: 20),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPillChoice({
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: isSelected ? color : AppTheme.paperWhite,
            borderRadius: BorderRadius.circular(8),
            border: AppTheme.doodleBorder(isSelected ? 2.0 : 1.2),
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
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: isSelected ? AppTheme.inkColor : AppTheme.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
