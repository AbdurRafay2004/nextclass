import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../course/data/models/course.dart';
import '../../data/models/class_session.dart';
import '../providers/session_provider.dart';

class SessionAddPage extends ConsumerStatefulWidget {
  final Course course;

  const SessionAddPage({super.key, required this.course});

  @override
  ConsumerState<SessionAddPage> createState() => _SessionAddPageState();
}

class _SessionAddPageState extends ConsumerState<SessionAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _roomController = TextEditingController();

  int _selectedDay = 1; // 1 = Monday, 7 = Sunday
  TimeOfDay _startTime = const TimeOfDay(hour: 10, minute: 0);
  int _durationMinutes = 90; // Default 1.5 hrs
  SessionType _selectedType = SessionType.lecture;

  final List<String> _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  void _saveSession() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(sessionControllerProvider)
          .addSession(
            courseUuid: widget.course.uuid,
            dayOfWeek: _selectedDay,
            startTimeMinutes: _startTime.hour * 60 + _startTime.minute,
            durationMinutes: _durationMinutes,
            room: _roomController.text.trim(),
            type: _selectedType,
          );

      if (mounted) {
        // Invalidate the session query for this course so the list updates
        ref.invalidate(sessionsByCourseProvider(widget.course.uuid));
        ref.invalidate(dayScheduleProvider); // Invalidate dashboard too
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Session saved!')));
      }
    }
  }

  @override
  void dispose() {
    _roomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Session',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _saveSession,
            child: const Text(
              'Save',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
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
              Text('Course', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: Text(
                  '${widget.course.code} - ${widget.course.name}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Day of Week',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final dayNumber = index + 1;
                  final isSelected = _selectedDay == dayNumber;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDay = dayNumber),
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surface,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? null
                            : Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                      ),
                      child: Text(
                        _days[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              Text(
                'Time & Duration',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _pickTime,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Time',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _startTime.format(context),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: _durationMinutes,
                      decoration: const InputDecoration(
                        labelText: 'Duration',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 45, child: Text('45 min')),
                        DropdownMenuItem(value: 60, child: Text('1 hr')),
                        DropdownMenuItem(value: 90, child: Text('1 hr 30 min')),
                        DropdownMenuItem(value: 120, child: Text('2 hrs')),
                        DropdownMenuItem(
                          value: 150,
                          child: Text('2 hrs 30 min'),
                        ),
                        DropdownMenuItem(value: 180, child: Text('3 hrs')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _durationMinutes = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Details',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SegmentedButton<SessionType>(
                segments: const [
                  ButtonSegment(
                    value: SessionType.lecture,
                    label: Text('Lecture'),
                  ),
                  ButtonSegment(value: SessionType.lab, label: Text('Lab')),
                  ButtonSegment(
                    value: SessionType.tutorial,
                    label: Text('Tutorial'),
                  ),
                ],
                selected: {_selectedType},
                onSelectionChanged: (Set<SessionType> newSelection) {
                  setState(() {
                    _selectedType = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _roomController,
                decoration: const InputDecoration(
                  labelText: 'Room Number',
                  hintText: 'e.g., B-201',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
