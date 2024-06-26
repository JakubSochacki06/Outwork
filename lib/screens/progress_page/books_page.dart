import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:outwork/providers/progress_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../models/book.dart';
import '../../providers/user_provider.dart';
import '../../widgets/appBars/main_app_bar.dart';
import '../../widgets/book_container.dart';
import '../../widgets/book_tile.dart';
import '../upgrade_your_plan_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      appBar: const MainAppBar(),
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
                    icon: const Icon(Icons.navigate_before),
                  ),
                  Text(AppLocalizations.of(context)!.yourBookshelf, style: Theme.of(context).textTheme.bodySmall,),
                  IconButton(
                    iconSize: width * 0.07,
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.primary)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.star),
                  ),
                ],
              ),
              SizedBox(height: height*0.015,),
              SearchAnchor(
                  isFullScreen: false,
                  dividerColor: Theme.of(context).colorScheme.secondary,
                  viewHintText: AppLocalizations.of(context)!.searchForABook,
                  headerHintStyle: Theme.of(context).primaryTextTheme.bodySmall,
                  headerTextStyle: Theme.of(context).primaryTextTheme.bodySmall,
                  builder:
                  (BuildContext context, SearchController controller) {
                return SearchBar(
                  backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                  hintText: AppLocalizations.of(context)!.searchForABook,
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
                  trailing: [const Icon(Icons.search)],
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
                          if(userProvider.user!.isPremiumUser! || progressProvider.books.length < 3){
                            await progressProvider.addBookToDatabase(
                                book, userProvider.user!.email!);
                            FocusScope.of(context).unfocus();
                            controller.closeView('');
                          } else {
                            Offerings? offerings;
                            try {
                              offerings = await Purchases.getOfferings();
                            } catch (e) {
                              print(e);
                            }
                            if (offerings != null) {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: UpgradeYourPlanPage(
                                  offerings: offerings,
                                ),
                                withNavBar: false,
                              );
                            }
                          }
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
