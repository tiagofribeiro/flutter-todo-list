import 'package:flutter/material.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController taskController = TextEditingController();

  List<String> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: taskController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adicionar uma tarefa',
                        hintText: 'Ex. Estudar Flutter',
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      String task = taskController.text;
                      setState(() {
                        tasks.add(task);
                      });
                      taskController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff00d7f4),
                      padding: EdgeInsets.all(14),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 30,
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (String task in tasks)
                      ListTile(
                        title: Text(task),
                        subtitle: Text(DateTime.now().toString()),
                        onTap: () {
                          print(task);
                        },
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Você possui 0 tarefas pendentes',
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff00d7f4),
                      padding: EdgeInsets.all(14),
                    ),
                    child: Text('Limpar Tudo'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
