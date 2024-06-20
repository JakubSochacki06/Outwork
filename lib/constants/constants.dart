import 'package:line_icons/line_icons.dart';
import 'package:outwork/screens/progress_page/bad_habits_page/bad_habits_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../screens/progress_page/books_page.dart';
import '../screens/progress_page/mental_health_page/mental_health_page.dart';
import '../screens/progress_page/money_page/money_page.dart';
const entitlementRCID = 'premium';

const googleRCApiKey = 'goog_ggEEfTYXPRbHsURTdeKJDXvwUPO';

const appleRCApiKey = 'appl_hKiQmmQATydpshNQCqbKptQcfEh';

List<Map<String, dynamic>> getProgressFields(context) => [
  {
    'title': AppLocalizations.of(context)!.titleMoney,
    'icon': LineIcons.wavyMoneyBill,
    'description': AppLocalizations.of(context)!.descriptionMoney,
    'route': const MoneyPage(),
  },
  {
    'title': AppLocalizations.of(context)!.titleJournal,
    'icon': LineIcons.pen,
    'description': AppLocalizations.of(context)!.descriptionJournal,
    'route': const MentalHealthPage(),
  },
  {
    'title': AppLocalizations.of(context)!.titleBadHabits,
    'icon': LineIcons.timesCircleAlt,
    'description': AppLocalizations.of(context)!.descriptionBadHabits,
    'route': const BadHabitsPage(),
  },
  // {'title': 'Physique', 'imageName': 'money', 'description': 'Track your physique progress'},
  {
    'title': AppLocalizations.of(context)!.titleBooks,
    'icon': LineIcons.readme,
    'description': AppLocalizations.of(context)!.descriptionBooks,
    'route': const BooksPage(),
  },
  // {
  //   'title': 'Physique',
  //   'icon': LineIcons.hourglassHalf,
  //   'description': 'Track your physique (soon)',
  //   'route': null,
  // },
  // {
  //   'title': 'Challenges',
  //   'icon': LineIcons.hourglassHalf,
  //   'description': 'Show you are the best! (soon)',
  //   'route': null,
  // },
  // {
  //   'title': 'Meditation',
  //   'imageName': 'meditation',
  //   'description': 'Clear your mind'
  // },
  // {
  //   'title': 'Sleep',
  //   'imageName': 'meditation',
  //   'description': 'Keep your sleeping schedule'
  // },
];

const List<Map<String, dynamic>> subscriptions = [
  {
    'name':'Spotify',
    'price':5.99,
  },
  {
    'name':'Netflix',
    'price':6.99,
  },
  {
    'name':'Youtube Premium',
    'price':13.99,
  },
  {
    'name':'HBO MAX',
    'price':9.99,
  },
  {
    'name':'Disney+',
    'price':9.99,
  },
  {
    'name':'Hulu',
    'price':7.99,
  },
  {
    'name':'Gym membership',
    'price':29.99,
  },
];

List<String> getBadHabits(context) => [AppLocalizations.of(context)!.junkFood, AppLocalizations.of(context)!.pornography, AppLocalizations.of(context)!.gambling, AppLocalizations.of(context)!.gaming,AppLocalizations.of(context)!.alcohol, AppLocalizations.of(context)!.overspending, AppLocalizations.of(context)!.partying, AppLocalizations.of(context)!.drugs, AppLocalizations.of(context)!.smoking, AppLocalizations.of(context)!.socialMedia];

