import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/bloc/new_bloc.dart';
import 'package:flutter_bloc_pattern/models/article.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var newBloc =NewBloc();

  @override
  void initState() {
    newBloc.eventSink.add(NewsAction.Fetch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('New in Bloc Pattern',style: TextStyle(
        color: Colors.black
      ),),
      elevation: 0.0,
      backgroundColor: Colors.white,),
      body: StreamBuilder<List<Article>>(
        stream: newBloc.newsStream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData){
            List<Article> articles=snapshot.data;
            return ListView.builder(
                itemCount: articles.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context,int index){
              Article article=articles[index];
              return Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child:Row(
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(article.urlToImage),radius: 35,),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(article.title,
                            overflow: TextOverflow.ellipsis,
                            style:
                          const TextStyle(color:Colors.black,
                              fontSize: 18,fontWeight: FontWeight.bold),),


                          Text(article.description,style:
                          const TextStyle(color:Colors.black,
                              fontSize: 18),),
                        ],
                      ),
                    )
                  ],
                ),
              );
            });
          }
          if(snapshot.hasError){
            return const Center(child: Text('Something Went Wrong.'),);
          }
          else{
            return const Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }
}
