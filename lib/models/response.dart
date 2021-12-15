import 'package:flutter_bloc_pattern/models/article.dart';

class Response {
  String status;
  int totalResults;
  List<Article> articles;

  Response({required this.status,required this.totalResults,required this.articles});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(status: json['status'],
        totalResults: json['totalResults'],
        articles: json['articles']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['totalResults'] = totalResults;
    data['articles'] = articles;
    return data;
  }
}