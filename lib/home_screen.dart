import 'package:flutter/material.dart';
import 'model/task_list.dart';
import 'services/service.dart';
import 'widget/add_task_dialog.dart';
import 'widget/edit_task_dialog.dart';
import 'widget/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Service service = Service();
  List<TaskList> apiTasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getTasks();
  }

  void getTasks() async {
    try {
      List<TaskList> tasksFromApi = await service.fetchTasks();
      setState(() {
        apiTasks = tasksFromApi;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching tasks: $e');
    }
  }

  Future<void> _addNewTask(String taskText) async {
    try {
      final newTask = await service.addTask(taskText);
      setState(() {
        apiTasks.add(newTask);
      });
    } catch (e) {
      debugPrint('Error adding task: $e');
    }
  }

  void _editTask(int index, String newTodo, bool newCompleted) {
    setState(() {
      apiTasks[index] = TaskList(
        id: apiTasks[index].id,
        todo: newTodo,
        completed: newCompleted,
      );
    });
  }

  void _deleteTask(int index) {
    setState(() {
      apiTasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'TO-Do List',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddTaskDialog(onAdd: _addNewTask),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white, size: 36),
      ),
      backgroundColor: Colors.grey.shade200,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView.builder(
                itemCount: apiTasks.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                    index: index + 1,
                    task: apiTasks[index],
                    onEdit: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditTaskDialog(
                          task: apiTasks[index],
                          onEdit: (newTodo, newCompleted) {
                            _editTask(index, newTodo, newCompleted);
                          },
                        ),
                      );
                    },
                    onDelete: () => _deleteTask(index),
                  );
                },
              ),
            ),
    );
  }
}
