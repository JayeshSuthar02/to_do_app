import 'package:flutter/material.dart';
import '../model/task_list.dart';

class EditTaskDialog extends StatefulWidget {
  final TaskList task;
  final Function(String newTodo, bool newCompleted) onEdit;

  const EditTaskDialog({
    super.key,
    required this.task,
    required this.onEdit,
  });

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late TextEditingController controller;
  late bool isCompleted;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.task.todo);
    isCompleted = widget.task.completed;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titleTextStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      title: const Text('Edit Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter Task',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            title: Text(
              isCompleted ? 'Completed' : 'Pending',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: isCompleted ? Colors.green : Colors.red,
              ),
            ),
            value: isCompleted,
            activeColor: Colors.green,
            onChanged: (value) {
              setState(() {
                isCompleted = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final text = controller.text.trim();
            if (text.isNotEmpty) {
              widget.onEdit(text, isCompleted);
            }
            Navigator.of(context).pop();
          },
          child: const Text('Edit'),
        ),
      ],
    );
  }
}
