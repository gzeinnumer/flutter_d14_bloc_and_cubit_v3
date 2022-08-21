import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_d14_bloc_and_cubit_v3/data_service.dart';
import 'package:flutter_d14_bloc_and_cubit_v3/post.dart';

//event
abstract class PostEvent{}

class PostInitEvent extends PostEvent{}

class PostRefreshEvent extends PostEvent{}

//state
abstract class PostState{}

class PostOnLoadingStatus extends PostState{}

class PostOnSuccessStatus extends PostState{
  final List<Post> list;

  PostOnSuccessStatus(this.list);
}

class PostOnFailedState extends PostState{
  final Error exception;

  PostOnFailedState(this.exception);
}

//bloc
class PostBloc extends Bloc<PostEvent, PostState>{
  final _dataService = DataService();

  PostBloc() : super(PostOnLoadingStatus());

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if(event is PostInitEvent || event is PostRefreshEvent){
      yield PostOnLoadingStatus();
      try{
        final res = await _dataService.getPost();
        yield PostOnSuccessStatus(res);
      } on Error catch(e){
        yield PostOnFailedState(e);
      }
    }
  }
}

