import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:outwork/providers/progress_provider.dart';
import 'package:provider/provider.dart';

import '../../widgets/appBars/main_app_bar.dart';
import '../../widgets/book_tile.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ProgressProvider progressProvider = Provider.of<ProgressProvider>(context);
    return Scaffold(
      appBar: MainAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: height * 0.02, horizontal: width * 0.04),
        child: Column(
          children: [
            SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    controller: controller,
                    padding: const MaterialStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0)),
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (_) {
                      controller.openView();
                    },
                  );
                },
                suggestionsBuilder: (BuildContext context, SearchController controller) async{
                  Future<List<dynamic>> getBooksByTitle(String title) async {
                    Response response = await get(Uri.parse('https://www.googleapis.com/books/v1/volumes?q=intitle:$title}'));
                    return jsonDecode(response.body)['items'];
                  }

                  List<dynamic> books = await getBooksByTitle(controller.text);
                  List<dynamic> booksWithThumbnail = books.where((book) =>
                  book['volumeInfo']['imageLinks'] != null &&
                      book['volumeInfo']['imageLinks']['thumbnail'] != null && book['volumeInfo']['authors'] != null).toList();
                  return List<Widget>.generate(booksWithThumbnail.length, (int index) {
                    Map<String, dynamic> book = booksWithThumbnail[index];
                    return Column(
                      children: [
                        BookTile(
                          title: book['volumeInfo']['title'],
                          author: book['volumeInfo']['authors'][0],
                          pages: book['volumeInfo']['pageCount'],
                          thumbnailURL: book['volumeInfo']['imageLinks']['thumbnail'],
                        ),
                        SizedBox(height: height*0.015),
                      ],
                    );
                  });

                }),
            Expanded(
              child: GridView.builder(
              itemCount: progressProvider.books.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: width / (height / 1.76),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10),
                  itemBuilder: (context, index) {}),
            ),
          ],
        )
      ),
    );
  }
}
