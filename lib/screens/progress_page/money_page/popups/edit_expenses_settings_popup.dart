import 'package:flutter/material.dart';
import 'package:outwork/providers/progress_provider.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditExpensesPopup extends StatefulWidget {
  const EditExpensesPopup({super.key});

  @override
  State<EditExpensesPopup> createState() => _AddMorningRoutinePopupState();
}

class _AddMorningRoutinePopupState extends State<EditExpensesPopup> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    ProgressProvider progressProvider = Provider.of<ProgressProvider>(context, listen: false);

    return Container(
      color: Colors.transparent,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border.all(color: Colors.transparent),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FractionallySizedBox(
              widthFactor: 0.15,
              alignment: Alignment.center,
              child: Container(
                height: height * 0.005,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context)!.changeSubscriptionLimit,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            // TODO: ADD PLACEHOLDER THAT SHOWS CURRENT AMOUNT, SO USER KNOWS HOW MUCH WAS HIS PREV LIMIT
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: _amountController,
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    errorStyle: Theme.of(context)
                        .primaryTextTheme
                        .labelLarge!
                        .copyWith(color: Theme.of(context).colorScheme.error),
// alignLabelWithHint: true,
                    labelText: AppLocalizations.of(context)!.subscriptionLimit,
                    labelStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                    hintText: AppLocalizations.of(context)!.howMuchMaximum),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            ElevatedButton(
              onPressed: () async {
                await progressProvider.updateExpensesSettings(int.parse(_amountController.text), userProvider.user!.email!);
                Navigator.pop(context);
              },
              child: Text(
                AppLocalizations.of(context)!.saveSettings,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                minimumSize: Size(width * 0.8, height * 0.05),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
