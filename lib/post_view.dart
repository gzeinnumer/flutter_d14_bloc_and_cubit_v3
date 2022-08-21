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
