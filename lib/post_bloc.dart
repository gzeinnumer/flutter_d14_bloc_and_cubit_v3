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

