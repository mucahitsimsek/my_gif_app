import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TenorPage extends StatefulWidget {
  const TenorPage({Key? key}) : super(key: key);

  @override
  State<TenorPage> createState() => _TenorPageState();
}

class _TenorPageState extends State<TenorPage> {
  final TextEditingController _controller = TextEditingController();

  String key = 'YOUR API KEY';

  List<String> gifUris = [];
  void getGifUris(String word) async {
    var data = await http.get(Uri.parse(
        'https://tenor.googleapis.com/v2/search?q=$word&key=$key&client_key=my_test_app&limit=8'));
    var dataParsed = jsonDecode(data.body);
    gifUris.clear();
    setState(() {
      for (int i = 0; i < 8; i++) {
        gifUris.add(dataParsed['results'][i]['media_formats']['tinygif']['url']);
        //mp4 formunda bir URL kullanırsanız hata verecektir. Gif formatında kullanılır.
      }
    });
  }

  @override
  void initState() {
    getGifUris('Batman');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    getGifUris(_controller.text);
                  },
                  child: const Text('Gif ara'),
                ),
              ),
            ],
          ),
          if (gifUris.isEmpty)
            const CircularProgressIndicator()
          else
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView.separated(
                itemCount: 8,
                separatorBuilder: (BuildContext context, int index){
                  return const Divider(
                    color: Colors.blueGrey,
                    thickness: 5,
                    height: 5,
                  );
                },
                itemBuilder: (_,int index) {
                  return GifCard(gifUris[index]);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class GifCard extends StatelessWidget {
  final String gifUrl;

  GifCard(this.gifUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(
        fit: BoxFit.cover,
        image: NetworkImage(gifUrl),
      ),
    );
  }
}