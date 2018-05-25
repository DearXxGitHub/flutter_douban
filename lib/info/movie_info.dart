import 'package:flutter/material.dart';
import 'package:flutter_douban/entity/movie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_douban/entity/movie_info.dart';

class MovieInfoPage extends StatefulWidget {
  MovieInfoPage({this.movie});

  final Movie movie;

  @override
  _MovieInfoPageState createState() => new _MovieInfoPageState();
}

class _MovieInfoPageState extends State<MovieInfoPage> {
  MovieInfo info = null;

  @override
  void initState() {
    // TODO: implement initState
    _initData();
    super.initState();
  }

  _showProgress() {
    return new Center(child: new CircularProgressIndicator());
  }

  _initData() async {
    String infoUrl = '$movie_page${widget.movie.id}';
    print(infoUrl);
    http.Response response = await http.get(infoUrl);

    setState(() {
      info = new MovieInfo.forJson(json.decode(response.body));
    });
  }

  String _formatString(List<String> strings) {
    String sb = '';
    for (String item in strings) {
      sb = sb + '${item},';
    }
    return sb.length > 1 ? sb.substring(0, sb.length - 1) : sb;
  }

  _getCastList(){
    return new  List<Widget>.generate(info.casts.length, (index){
      CastsBean castsBean=info.casts[index];
      return new Expanded(child: new Column(
        children: <Widget>[
          new Image.network(
            castsBean.avatars==null?"":castsBean.avatars.medium,
            width: 100.0,
            height: 100.0,
          ),
          new Text(castsBean.name),
        ],
      ));
    });
  }

  _getDirectors(){
    return new  List<Widget>.generate(info.directors.length, (index){
      DirectorsBean directorsBean=info.directors[index];
      return new Expanded(child: new Column(
        children: <Widget>[
          new Image.network(
            directorsBean.avatars.medium==null?directorsBean.avatars.large==null?directorsBean.avatars.small:directorsBean.avatars.large:directorsBean.avatars.medium,
            width: 100.0,
            height: 100.0,
          ),
          new Text(directorsBean.name),
        ],
      ));
    });
  }
  _getBody() {
    return new ListView(
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.all(8.0),
          child: new Row(
            children: <Widget>[
              new Image.network(
                info.images.medium,
                width: 150.0,
                height: 200.0,
              ),
              new Expanded(
                  child: new Container(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text('原名:${info.original_title}',style: Theme.of(context).textTheme.title,),
                    new Text('年代:${info.year}'),
                    new Text('影评数:${info.reviews_count}'),
                    new Text('评分人数:${info.ratings_count}'),
                    new Text('类型:${_formatString(info.genres)}'),
                    new Text('制片国家/地区:${_formatString(info.countries)}'),
                    new Text('${info.wish_count}人想看',style: Theme.of(context).textTheme.body1.copyWith(color: Colors.red),),
                    new Text('${info.collect_count}人看过',style: Theme.of(context).textTheme.body1.copyWith(color: Colors.red),),
                  ],
                ),
              ))
            ],
          ),
        ),
        new Align(
          alignment: Alignment.topLeft,
          child: new Container(
              padding: const EdgeInsets.all(4.0),
              child: new Text('导演:',style: Theme.of(context).textTheme.title.copyWith(color: Colors.blue),)),
        ),
        new Row(
          children:_getDirectors(),
        ),
        new Align(
          alignment: Alignment.topLeft,
          child: new Container(
              padding: const EdgeInsets.all(4.0),
              child: new Text('主演:',style: Theme.of(context).textTheme.title.copyWith(color: Colors.blue),)),
        ),
        new Row(
          children:_getCastList(),
        ),
        new Align(
          alignment: Alignment.topLeft,
          child: new Container(
              padding: const EdgeInsets.all(4.0),
              child: new Text('介绍:',style: Theme.of(context).textTheme.title.copyWith(color: Colors.blue),)),
        ),
        new Container(
            padding: const EdgeInsets.all(4.0),
            child: new Text(info.summary))
      ],
    );
  }

  _share(){
    print('分享');
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.movie.title),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.share), onPressed: _share)
        ],
      ),
      body: info == null ? _showProgress() : _getBody(),
    );
  }
}
const String movie_page = 'https://api.douban.com/v2/movie/subject/';
