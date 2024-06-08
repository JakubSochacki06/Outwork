import 'package:line_icons/line_icons.dart';
import 'package:outwork/screens/progress_page/bad_habits_page/bad_habits_page.dart';

import '../screens/progress_page/books_page.dart';
import '../screens/progress_page/mental_health_page/mental_health_page.dart';
import '../screens/progress_page/money_page/money_page.dart';
const entitlementRCID = 'premium';

const googleRCApiKey = 'goog_ggEEfTYXPRbHsURTdeKJDXvwUPO';

const appleRCApiKey = 'appl_hKiQmmQATydpshNQCqbKptQcfEh';

const List<Map<String, dynamic>> progressFields = [
  {
    'title': 'Money',
    'icon': LineIcons.wavyMoneyBill,
    'description': 'Track your expenses',
    'route': MoneyPage(),
  },
  {
    'title': 'Journal',
    'icon': LineIcons.pen,
    'description': 'Track your feelings',
    'route': MentalHealthPage(),
  },
  {
    'title': 'Bad habits',
    'icon': LineIcons.timesCircleAlt,
    'description': 'Stay clean',
    'route': BadHabitsPage(),
  },
  // {'title': 'Physique', 'imageName': 'money', 'description': 'Track your physique progress'},
  {
    'title': 'Books',
    'icon': LineIcons.readme,
    'description': 'Read all of them!',
    'route': BooksPage(),
  },
  {
    'title': 'Physique',
    'icon': LineIcons.hourglassHalf,
    'description': 'Track your physique (soon)',
    'route': null,
  },
  {
    'title': 'Challenges',
    'icon': LineIcons.hourglassHalf,
    'description': 'Show you are the best! (soon)',
    'route': null,
  },
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

List<String> badHabits = ['Junk Food', 'Pornography', 'Gambling', 'Gaming','Alcohol', 'Overspending', 'Partying', 'Drugs', 'Smoking', 'Social Media', 'Swearing'];

