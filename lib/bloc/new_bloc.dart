

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_bloc_pattern/models/article.dart';

enum NewsAction{Fetch,Delete}
class NewBloc{

  static const String API='https://newsapi.org/v2/everything?q=bitcoin&apiKey=62a5a00544e840e7976886e499274e94';

  ///create a streamController to list for streams
  final _newsBlocController=StreamController<List<Article>>();

  ///stream Sink is used as input in stream
  ///stream is used as output from stream
  StreamSink<List<Article>> get _newsSink => _newsBlocController.sink;
  Stream<List<Article>> get newsStream => _newsBlocController.stream;

  ///this event controller will listen for events on button
  ///and provide action to newBlocController which will perform further actions.
  final _eventBlocController=StreamController<NewsAction>();
  StreamSink<NewsAction> get eventSink => _eventBlocController.sink;
  Stream<NewsAction> get _eventStream => _eventBlocController.stream;

  NewBloc(){
    _eventStream.listen((event)async {
      if(event==NewsAction.Fetch){
        try {
          var news=await getNews();
          _newsSink.add(news);
        } on Exception catch (e) {
          _newsSink.addError('Something Went Wrong');
        }
      }
      else if(event==NewsAction.Delete){
        print('Delete');
      }
    });
  }

  void dispose(){
    _eventBlocController.close();
    _newsBlocController.close();
  }


  Future<List<Article>> getNews() async{
    var client=http.Client();
    var articles;
    List<Article> articlesList=[];



    try{
      var response=await client.get(Uri.parse(API));

      if(response.statusCode==200){
        var jsonString=response.body;

        var jsonMap=json.decode(jsonString);
        articles=jsonMap['articles'];
        for(var a in articles){
          Article article=Article.fromJson(a);
          articlesList.add(article);
        }
      }
    }catch(Exception){
      return articlesList;
    }
    return articlesList;
  }
}