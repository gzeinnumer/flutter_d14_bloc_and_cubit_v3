# flutter_d14_bloc_and_cubit_v3

|<img src="/preview/preview1.png" width="300"/>|
|--|

- data_service.dart
```dart
import 'dart:convert';
import 'package:flutter_d14_bloc_and_cubit_v3/post.dart';
import 'package:http/http.dart' as http;

class DataService {
  final _baseUrl = 'jsonplaceholder.typicode.com';

  Future<List<Post>> getPost() async {
    try {
      final uri = Uri.https(_baseUrl, '/posts');
      // final uri = Uri.https(_baseUrl, '/postz'); //error sengaja
      final response = await http.get(uri);
      final json = jsonDecode(response.body) as List;
      final posts = json.map((postJson) => Post.fromJson(postJson)).toList();
      print(posts.toString());
      return posts;
    } on Error catch (e) {
      throw e;
    }
  }
}
```

- main.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_d14_bloc_and_cubit_v3/post_bloc.dart';
import 'package:flutter_d14_bloc_and_cubit_v3/post_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<PostBloc>(create: (context) => PostBloc()..add(PostInitEvent()))
        ],
        child: PostView(),
      ),
    );
  }
}
```

- post.dart
```dart
class Post {
  final int? userId;
  final int? id;
  final String? title;
  final String? body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body']);
}
```

- post_bloc.dart
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_d14_bloc_and_cubit_v3/data_service.dart';
import 'package:flutter_d14_bloc_and_cubit_v3/post.dart';

//gzn_dart_blocclass_full_list_v2
//EVENT-------------------------------------------------------------------------
abstract class PostEvent{}

class PostInitEvent extends PostEvent{}

class PostRefreshEvent extends PostEvent{}

//STATE-------------------------------------------------------------------------
abstract class PostState{}

class PostOnLoadingState extends PostState{}

class PostOnSuccessState extends PostState{
  final List<Post> list;

  PostOnSuccessState(this.list);
}

class PostOnFailedState extends PostState{
  final Error exception;

  PostOnFailedState(this.exception);
}

//BLOC--------------------------------------------------------------------------
class PostBloc extends Bloc<PostEvent, PostState>{
  // final ExampleRepo repo;
  final _dataService = DataService();
  PostBloc() : super(PostOnLoadingState());

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if(event is PostInitEvent || event is PostRefreshEvent){
      yield PostOnLoadingState();
      try{
        final res = await _dataService.getPost();
        // final res = <Post>[];
        yield PostOnSuccessState(res);
      } on Error catch(e){
        yield PostOnFailedState(e);
      }
    }
  }
}
```

- post_view.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_d14_bloc_and_cubit_v3/post.dart';
import 'package:flutter_d14_bloc_and_cubit_v3/post_bloc.dart';

class PostView extends StatelessWidget {
  const PostView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //type 2
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post V2 EVENT STATE BLOC'),
      ),
      body: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
        if (state is PostOnLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostOnSuccessState) {
          return RefreshIndicator(
            onRefresh: () async {
              return BlocProvider.of<PostBloc>(context).add(PostRefreshEvent());
            },
            child: ListView.builder(
                itemCount: state.list.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(state.list[index].title.toString()),
                    ),
                  );
                }),
          );
        } else if (state is PostOnFailedState) {
          return Center(
            child: Text('Error occured: ${state.exception.toString()}'),
          );
        } else {
          return Container();
        }
      }),
    );
  }
}
```

---

```
Copyright 2022 M. Fadli Zein
```