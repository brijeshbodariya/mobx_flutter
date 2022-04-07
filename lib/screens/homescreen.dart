import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_flutter/models/hacker_news.dart';
import 'package:mobx_flutter/serializers/news.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeState createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeScreen> {
  final hackersNews = HackerNews();
  final snackBar = SnackBar(
    content: const Text('News List is updating up.'),
    action: SnackBarAction(
      label: 'Ok',
      onPressed: () {},
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hackersNews.getNewsList();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('MobX Demo'),
        ),
        body: Observer(
          builder: (context) => RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              await hackersNews.increaseNewsLimit();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Observer(
              builder: (_) => hackersNews.news.isNotEmpty
                  ? ListView.builder(
                      itemCount: hackersNews.news.length,
                      itemBuilder: (_, index) {
                        final newsArticle = hackersNews.news[index];
                        return _makeArticleContainer(newsArticle);
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                    ),
            ),
          ),
        ),
      );

  Widget _makeArticleContainer(News newsArticle) {
    return Padding(
      key: Key(newsArticle.title!),
      padding: const EdgeInsets.all(16.0),
      child: ExpansionTile(
        backgroundColor: Colors.grey[200],
        title: Text(
          newsArticle.title!,
          style: const TextStyle(fontSize: 24.0),
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("${newsArticle.by} comments"),
              IconButton(
                onPressed: () async {
                  // TODO : Launch URL
                  if (await canLaunch(newsArticle.url!)) {
                    launch(newsArticle.url!);
                  }
                },
                icon: const Icon(Icons.launch),
              )
            ],
          ),
        ],
      ),
    );
  }
}
