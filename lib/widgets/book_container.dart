import 'package:flutter/material.dart';
import 'package:outwork/providers/progress_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/theme_provider.dart';

class BookContainer extends StatefulWidget {
  final Book book;

  BookContainer({required this.book});

  @override
  State<BookContainer> createState() => _BookContainerState();
}

class _BookContainerState extends State<BookContainer> {
  late TextEditingController _amountController;

  @override
  void initState() {
    _amountController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    ProgressProvider progressProvider = Provider.of<ProgressProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    Future<void> _showAddPagesDialog() {
      return showDialog(
          context: context,
          builder: (context) {
            String? amountError;
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  'How many paged did you read?',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: amountError != null
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(context).colorScheme.primary,
                              width: 2),
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(15)),
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: _amountController,
                        decoration: InputDecoration(
                            hintStyle:
                                Theme.of(context).primaryTextTheme.labelLarge!,
                            hintText: 'Insert amount of pages'),
                      ),
                    ),
                    amountError != null
                        ? Text(
                            amountError!,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .labelLarge!
                                .copyWith(
                                    color: Theme.of(context).colorScheme.error),
                          )
                        : Container(),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel',
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        if (int.parse(_amountController.text) + widget.book.readPages! > widget.book.totalPages!) {
                          print('error');
                          setState(() {
                            amountError = 'Make sure the amount is correct!';
                          });
                        } else {
                          await progressProvider.addReadPagesToDatabase(
                              widget.book,
                              int.parse(_amountController.text),
                              userProvider.user!.email!);
                          _amountController.clear();
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        print(e);
                        setState(() {
                          amountError = 'Make sure this is valid number';
                        });
                      }
                    },
                    child: Text(
                      'Add',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  )
                ],
              );
            });
          });
    }

    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(color: widget.book.readPages==widget.book.totalPages?Theme.of(context).colorScheme.secondary:Theme.of(context).colorScheme.primary, width: 2),
        boxShadow: themeProvider.isLightTheme()
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(3, 3),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.network(
            widget.book.thumbnailURL!,
            scale: 1.7,
          ),
          Text(
            widget.book.title!,
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
          Row(
            children: [
              InkWell(
                onTap: _showAddPagesDialog,
                child: Icon(Icons.add),
              ),
              Spacer(),
              Text('${widget.book.readPages}/',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(
                      color: widget.book.readPages==widget.book.totalPages?Theme.of(context).colorScheme.secondary:Theme.of(context).colorScheme.onPrimaryContainer),),
              Text(widget.book.totalPages.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(
                          color: Theme.of(context).colorScheme.secondary)),
              Spacer(),
              InkWell(
                onTap: () async {
                  await progressProvider.removeBookFromDatabase(
                      widget.book, userProvider.user!.email!);
                },
                child: Icon(Icons.delete),
              ),
            ],
          )
        ],
      ),
    );
  }
}
