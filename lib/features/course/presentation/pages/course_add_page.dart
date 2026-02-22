import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/course.dart';
import '../providers/course_provider.dart';

class CourseAddPage extends ConsumerStatefulWidget {
  final Course? courseToEdit;

  const CourseAddPage({super.key, this.courseToEdit});

  @override
  ConsumerState<CourseAddPage> createState() => _CourseAddPageState();
}

class _CourseAddPageState extends ConsumerState<CourseAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _facultyAcronymController = TextEditingController();

  Color _selectedColor = AppColors.courseColors.first;

  @override
  void initState() {
    super.initState();
    if (widget.courseToEdit != null) {
      _nameController.text = widget.courseToEdit!.name;
      _codeController.text = widget.courseToEdit!.code;
      _facultyAcronymController.text = widget.courseToEdit!.facultyAcronym;
      _selectedColor = AppColors.hexToColor(widget.courseToEdit!.colorHex);
    }
  }

  void _saveCourse() async {
    if (_formKey.currentState!.validate()) {
      if (widget.courseToEdit != null) {
        await ref
            .read(courseControllerProvider)
            .updateCourse(
              id: widget.courseToEdit!.id,
              uuid: widget.courseToEdit!.uuid,
              name: _nameController.text.trim(),
              code: _codeController.text.trim(),
              facultyAcronym: _facultyAcronymController.text.trim(),
              colorHex: AppColors.colorToHex(_selectedColor),
            );
      } else {
        await ref
            .read(courseControllerProvider)
            .addCourse(
              name: _nameController.text.trim(),
              code: _codeController.text.trim(),
              facultyAcronym: _facultyAcronymController.text.trim(),
              colorHex: AppColors.colorToHex(_selectedColor),
            );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Course saved!')));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _facultyAcronymController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseToEdit != null ? 'Edit Course' : 'Add Course'),
        actions: [
          TextButton(
            onPressed: _saveCourse,
            child: Text('Save', style: AppTextStyles.actionButton()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'COURSE DETAILS',
                style: AppTextStyles.sectionHeader(context),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Course Name',
                  hintText: 'e.g., Computer Graphics',
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _codeController,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          return newValue.copyWith(
                            text: newValue.text.toUpperCase(),
                          );
                        }),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Course Code',
                        hintText: 'CSE-401',
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _facultyAcronymController,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          return newValue.copyWith(
                            text: newValue.text.toUpperCase(),
                          );
                        }),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Faculty Acronym',
                        hintText: 'e.g., MMH',
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text('THEME COLOR', style: AppTextStyles.sectionHeader(context)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: AppColors.courseColors.map((color) {
                  final isSelected = _selectedColor == color;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 3,
                              )
                            : null,
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              color: color.computeLuminance() > 0.5
                                  ? Colors.black87
                                  : Colors.white,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
