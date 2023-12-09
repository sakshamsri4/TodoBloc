import 'package:bloc_api_integration/screens/todo_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List of tasks and their progress. This could come from your backend or state management logic.
  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'Shape Website',
      'progress': 0.75,
      'taskCount': 46,
      'team': [
        "https://media.istockphoto.com/id/1130907832/photo/stunning-young-woman.jpg?s=1024x1024&w=is&k=20&c=Dc8QN55OfE5mqgAVU34c-umwx32KKuMBA7M24VKx_kE=",
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150'
      ],
    },
    {
      'title': 'Shape Website',
      'progress': 0.75,
      'taskCount': 46,
      'team': [
        "https://media.istockphoto.com/id/1290658063/photo/portrait-of-a-beautiful-woman-with-natural-make-up.jpg?s=2048x2048&w=is&k=20&c=dZsBcuhog3SZnTj6bq5Is_isO2TpBNWunUwlKkln_dw=",
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150'
      ],
    },
    {
      'title': 'Shape Website',
      'progress': 0.75,
      'taskCount': 46,
      'team': [
        "https://media.istockphoto.com/id/1174452879/photo/i-do-all-my-work-on-this-device.jpg?s=612x612&w=0&k=20&c=ukqiZAIztp7olWY2h4kbcvdZJQ4e0G6zqwNPRlF5Q9Y=",
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150'
      ],
    },
    {
      'title': 'Shape Website',
      'progress': 0.75,
      'taskCount': 46,
      'team': [
        "https://media.istockphoto.com/id/1040964880/photo/stay-hungry-for-success.jpg?s=612x612&w=0&k=20&c=rA1HTQ_BS1bv1POYCRthD179B3yENJhJITVeJTt_vJg=",
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150'
      ],
    },
    {
      'title': 'Shape Website',
      'progress': 0.75,
      'taskCount': 46,
      'team': [
        "https://media.istockphoto.com/id/1198027123/photo/real-woman.jpg?s=2048x2048&w=is&k=20&c=DEn5JjgfQOJL2o4hRcluSuU5AepL-NaNhiI7sdg8jcs=",
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150'
      ],
    },
    {
      'title': 'Shape Website',
      'progress': 0.75,
      'taskCount': 46,
      'team': [
        "https://media.istockphoto.com/id/1364917563/photo/businessman-smiling-with-arms-crossed-on-white-background.jpg?s=612x612&w=0&k=20&c=NtM9Wbs1DBiGaiowsxJY6wNCnLf0POa65rYEwnZymrM=",
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150'
      ],
    },
    {
      'title': 'Shape Website',
      'progress': 0.75,
      'taskCount': 46,
      'team': [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150'
      ],
    },
    {
      'title': 'Shape Website',
      'progress': 0.75,
      'taskCount': 46,
      'team': [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150'
      ],
    },
    {
      'title': 'Shape Website',
      'progress': 0.75,
      'taskCount': 46,
      'team': [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150'
      ],
    },
    // Add more task maps...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildBody() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        return TaskCard(
          title: tasks[index]['title'],
          progress: tasks[index]['progress'],
          taskCount: tasks[index]['taskCount'],
          team: tasks[index]['team'],
        );
      },
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Goals'),
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8), // Add some margin if needed
        width: 20, // Set your desired width
        height: 20, // Set your desired height
        child: CircleAvatar(
          backgroundImage: NetworkImage(tasks[0]['team'][0]),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Implement search functionality
          },
        ),
      ],
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final double progress;
  final int taskCount;
  final List<String> team;
  final VoidCallback? onTap;

  const TaskCard(
      {Key? key,
      required this.title,
      required this.progress,
      required this.taskCount,
      required this.team,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodoScreen(title: title),
          ),
        );
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 8, top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                // First member of the team
                backgroundImage: NetworkImage(team[0]),
                radius: 18,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$taskCount Tasks',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 136, 51, 151)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
