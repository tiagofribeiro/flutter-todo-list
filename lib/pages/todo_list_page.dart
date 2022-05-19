import 'package:flutter/material.dart';
import 'package:flutter_todo_list/models/task.dart';
import 'package:flutter_todo_list/repositories/todo_repository.dart';
import 'package:flutter_todo_list/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController taskController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  Color mainColor = const Color(0xff66a832);
  Color errorColor = const Color(0xff702edb);

  List<Task> tasks = [];
  int? deletedTaskPos;
  Task? deletedTask;

  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTaskList().then((value) {
      setState(() {
        tasks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: taskController,
                        cursorColor: mainColor,
                        decoration: InputDecoration(
                          floatingLabelStyle: TextStyle(
                            color: mainColor,
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: mainColor,
                            ),
                          ),
                          labelText: 'Adicionar uma tarefa',
                          hintText: 'Ex. Estudar Flutter',
                          errorText: errorText,
                          errorStyle: TextStyle(
                            color: errorColor,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: errorColor,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: errorColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        String task = taskController.text;

                        if (task.isEmpty) {
                          setState(() {
                            errorText = 'A tarefa não pode estar vazia!';
                          });
                          return;
                        }

                        setState(() {
                          Task newTask = Task(
                            title: task,
                            date: DateTime.now(),
                          );
                          tasks.add(newTask);
                          errorText = null;
                        });
                        taskController.clear();

                        // Salva a lista localmente
                        todoRepository.saveTaskList(tasks);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: mainColor,
                        padding: const EdgeInsets.all(14),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Task task in tasks)
                        TodoListItem(
                          task: task,
                          onDelete: onDeleteTask,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Você possui ${tasks.length} tarefas pendentes',
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: showDeleteAllTasksDialog,
                      style: ElevatedButton.styleFrom(
                        primary: mainColor,
                        padding: const EdgeInsets.all(14),
                      ),
                      child: const Text('Limpar Tudo'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDeleteTask(Task task) {
    deletedTask = task;
    deletedTaskPos = tasks.indexOf(task);

    setState(() {
      tasks.remove(task);
    });
    // Salva a lista localmente
    todoRepository.saveTaskList(tasks);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        '\'${task.title}\' foi removido com sucesso.',
        style: const TextStyle(
          color: Colors.black54,
        ),
      ),
      backgroundColor: Colors.white,
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'Desfazer',
        textColor: mainColor,
        onPressed: () {
          setState(() {
            tasks.insert(deletedTaskPos!, deletedTask!);
          });
          // Salva a lista localmente
          todoRepository.saveTaskList(tasks);
        },
      ),
    ));
  }

  void showDeleteAllTasksDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar tudo'),
        content: const Text('Tem certeza que deseja apagar todas as tarefas?'),
        actions: [
          TextButton(
              style: TextButton.styleFrom(
                primary: mainColor,
              ),
              onPressed: () {
                deleteAllTasks();
                Navigator.of(context).pop();
              },
              child: const Text('Sim')),
          TextButton(
              style: TextButton.styleFrom(
                primary: Colors.black45,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar')),
        ],
      ),
    );
  }

  void deleteAllTasks() {
    setState(() {
      tasks.clear();
    });
    // Salva a lista localmente
    todoRepository.saveTaskList(tasks);
  }
}
