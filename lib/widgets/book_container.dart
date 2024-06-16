import 'package:flutter/material.dart';
import 'package:outwork/providers/progress_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
                  AppLocalizations.of(context)!.howManyPages,
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
                            hintText: AppLocalizations.of(context)!.insertAmountOfPages),
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
                    child: Text(AppLocalizations.of(context)!.cancel,
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        if (int.parse(_amountController.text) + widget.book.readPages! > widget.book.totalPages!) {
                          setState(() {
                            amountError = AppLocalizations.of(context)!.amountError;
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
                          amountError = AppLocalizations.of(context)!.makeSureValidNumber;
                        });
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.addButtonText,
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
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        border: Border.all(color: widget.book.readPages==widget.book.totalPages?Theme.of(context).colorScheme.secondary:Theme.of(context).colorScheme.primary, width: 2),
        boxShadow: themeProvider.isLightTheme()
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: const Offset(3, 3),
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
                child: const Icon(Icons.add),
              ),
              const Spacer(),
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
              const Spacer(),
              InkWell(
                onTap: () async {
                  await progressProvider.removeBookFromDatabase(
                      widget.book, userProvider.user!.email!);
                },
                child: const Icon(Icons.delete),
              ),
            ],
          )
        ],
      ),
    );
  }
}
