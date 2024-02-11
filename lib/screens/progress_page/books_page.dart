import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:outwork/providers/progress_provider.dart';
import 'package:provider/provider.dart';

import '../../models/book.dart';
import '../../providers/user_provider.dart';
import '../../widgets/appBars/main_app_bar.dart';
import '../../widgets/book_container.dart';
import '../../widgets/book_tile.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ProgressProvider progressProvider = Provider.of<ProgressProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MainAppBar(),
      body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.02, horizontal: width * 0.04),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    iconSize: width * 0.07,
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.primary)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.navigate_before),
                  ),
                  Text('Your bookshelf', style: Theme.of(context).textTheme.bodySmall,),
                  IconButton(
                    iconSize: width * 0.07,
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.primary)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.star),
                  ),
                ],
              ),
              SizedBox(height: height*0.015,),
              SearchAnchor(
                  isFullScreen: false,
                  dividerColor: Theme.of(context).colorScheme.secondary,
                  viewHintText: 'Search for a book',
                  headerHintStyle: Theme.of(context).primaryTextTheme.bodySmall,
                  headerTextStyle: Theme.of(context).primaryTextTheme.bodySmall,
                  builder:
                  (BuildContext context, SearchController controller) {
                return SearchBar(
                  backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                  hintText: 'Search for a book',
                  hintStyle: MaterialStateProperty.all<TextStyle>(Theme.of(context).primaryTextTheme.bodySmall!),
                  controller: controller,
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0)),
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (_) {
                    controller.openView();
                  },
                  trailing: [Icon(Icons.search)],
                );
              }, suggestionsBuilder:
                  (BuildContext context, SearchController controller) async {
                Future<List<dynamic>> getBooksByTitle(String title) async {
                  Response response = await get(Uri.parse(
                      'https://www.googleapis.com/books/v1/volumes?q=intitle:$title}'));
                  return jsonDecode(response.body)['items'];
                }

                List<dynamic> books = await getBooksByTitle(controller.text);
                List<dynamic> booksWithThumbnail = books
                    .where((book) =>
                        book['volumeInfo']['imageLinks'] != null &&
                        book['volumeInfo']['imageLinks']['thumbnail'] != null &&
                        book['volumeInfo']['authors'] != null &&
                        book['volumeInfo']['pageCount'] != null)
                    .toList();
                return List<Widget>.generate(booksWithThumbnail.length,
                    (int index) {
                  Book book = Book.fromGoogleAPI(booksWithThumbnail[index]);
                  return Column(
                    children: [
                      BookTile(
                        book: book,
                        onAddClicked: () async {
                          await progressProvider.addBookToDatabase(
                              book, userProvider.user!.email!);
                          FocusScope.of(context).unfocus();
                          controller.closeView('');
                        },
                      ),
                      SizedBox(height: height * 0.015),
                    ],
                  );
                });
              }),
              SizedBox(
                height: height*0.03,
              ),
              Expanded(
                child: GridView.builder(
                    itemCount: progressProvider.books.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: width / (height / 1.76),
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      return BookContainer(
                        book: progressProvider.books[index],
                      );
                    }),
              ),
            ],
          )),
    );
  }
}
