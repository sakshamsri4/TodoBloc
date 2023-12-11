import 'package:bloc_api_integration/bloc/home_event.dart';
import 'package:bloc_api_integration/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitial()) {
    on<LoadTasks>((event, emit) {
      final List<Map<String, dynamic>> tasks = [
        {
          'title': 'Shape Website',
          'progress': 0.75,
          'taskCount': 46,
          'image':
              "https://media.istockphoto.com/id/1130907832/photo/stunning-young-woman.jpg?s=1024x1024&w=is&k=20&c=Dc8QN55OfE5mqgAVU34c-umwx32KKuMBA7M24VKx_kE=",
        },
        {
          'title': 'Shape Website',
          'progress': 0.75,
          'taskCount': 46,
          'image':
              "https://media.istockphoto.com/id/1290658063/photo/portrait-of-a-beautiful-woman-with-natural-make-up.jpg?s=2048x2048&w=is&k=20&c=dZsBcuhog3SZnTj6bq5Is_isO2TpBNWunUwlKkln_dw=",
        },
        {
          'title': 'Shape Website',
          'progress': 0.75,
          'taskCount': 46,
          'image':
              "https://media.istockphoto.com/id/1174452879/photo/i-do-all-my-work-on-this-device.jpg?s=612x612&w=0&k=20&c=ukqiZAIztp7olWY2h4kbcvdZJQ4e0G6zqwNPRlF5Q9Y=",
        },
        {
          'title': 'Shape Website',
          'progress': 0.75,
          'taskCount': 46,
          'image':
              "https://media.istockphoto.com/id/1040964880/photo/stay-hungry-for-success.jpg?s=612x612&w=0&k=20&c=rA1HTQ_BS1bv1POYCRthD179B3yENJhJITVeJTt_vJg=",
        },
        {
          'title': 'Shape Website',
          'progress': 0.75,
          'taskCount': 46,
          'image':
              "https://media.istockphoto.com/id/1198027123/photo/real-woman.jpg?s=2048x2048&w=is&k=20&c=DEn5JjgfQOJL2o4hRcluSuU5AepL-NaNhiI7sdg8jcs=",
        },
        {
          'title': 'Shape Website',
          'progress': 0.75,
          'taskCount': 46,
          'image':
              "https://media.istockphoto.com/id/1364917563/photo/businessman-smiling-with-arms-crossed-on-white-background.jpg?s=612x612&w=0&k=20&c=NtM9Wbs1DBiGaiowsxJY6wNCnLf0POa65rYEwnZymrM=",
        },

        // Add more task maps...
      ];

      emit(TasksLoadSuccess(tasks));
    });

    on<AddTask>((event, emit) {
      if (state is TasksLoadSuccess) {
        final currentState = state as TasksLoadSuccess;
        final updatedTasks = List<Map<String, dynamic>>.from(currentState.tasks)
          ..add(event.newTask);
        emit(TaskAdditionSuccess(updatedTasks));
      }
    });
  }
}
