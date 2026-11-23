import 'package:flutter/material.dart';
import '../../models/subject_model.dart';
import '../../services/auth_service.dart';
import '../../services/subject_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/notebook_card.dart';

class AddEditSubjectScreen extends StatefulWidget {
  final SubjectModel? subjectToEdit;

  const AddEditSubjectScreen({Key? key, this.subjectToEdit}) : super(key: key);

  @override
  State<AddEditSubjectScreen> createState() => _AddEditSubjectScreenState();
}

class _AddEditSubjectScreenState extends State<AddEditSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _instructorController;

  bool _isLoading = false;
  bool get isEditing => widget.subjectToEdit != null;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(
      text: widget.subjectToEdit?.subjectCode ?? '',
    );
    _nameController = TextEditingController(
      text: widget.subjectToEdit?.subjectName ?? '',
    );
    _instructorController = TextEditingController(
      text: widget.subjectToEdit?.instructorName ?? '',
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _instructorController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final currentUser = AuthService.instance.currentUser;
    if (currentUser == null || currentUser.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in first')),
      );
      setState(() => _isLoading = false);
      return;
    }

    try {
      final code = _codeController.text.trim().toUpperCase();
      final name = _nameController.text.trim();
      final instructor = _instructorController.text.trim();

      if (isEditing) {
        final updated = widget.subjectToEdit!.copyWith(
          subjectCode: code,
          subjectName: name,
          instructorName: instructor,
        );
        await SubjectService.instance.updateSubject(updated);
      } else {
        final newSubject = SubjectModel(
          userId: currentUser.userId!,
          subjectCode: code,
          subjectName: name,
          instructorName: instructor,
        );
        await SubjectService.instance.addSubject(newSubject);
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save subject: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paperSurface,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Subject' : 'Add New Subject 📚'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded, size: 26),
            tooltip: 'Save Subject',
            onPressed: _isLoading ? null : _handleSave,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NotebookCard(
                backgroundColor: AppTheme.paperWhite,
                hasWashiTape: true,
                washiColor: AppTheme.pastelLilac.withAlpha(220),
                washiText: isEditing ? 'Edit Subject' : 'Course Enrollment',
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subject Code (ERD: subject_code)
                    const Text(
                      'Subject Code',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _codeController,
                      textCapitalization: TextCapitalization.characters,
                      style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                      cursorColor: AppTheme.inkColor,
                      decoration: const InputDecoration(
                        hintText: 'e.g. CS 101, MATH 301, ENG 202',
                        prefixIcon: Icon(Icons.tag_rounded, size: 20),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter a course code';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Subject Name (ERD: subject_name)
                    const Text(
                      'Subject Title / Course Name',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                      cursorColor: AppTheme.inkColor,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Intro to Computer Science & Structures',
                        prefixIcon: Icon(Icons.menu_book_rounded, size: 20),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter course title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Instructor Name (ERD: instructor_name)
                    const Text(
                      'Instructor / Professor Name',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _instructorController,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                      cursorColor: AppTheme.inkColor,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Prof. Sarah Jenkins, Ph.D.',
                        prefixIcon: Icon(Icons.person_rounded, size: 20),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter professor name';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isEditing ? 'Save Changes' : 'Enroll Subject',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.check_circle_rounded, size: 20),
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
}
