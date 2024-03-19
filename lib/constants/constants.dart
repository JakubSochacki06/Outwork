import '../screens/progress_page/books_page.dart';
import '../screens/progress_page/mental_health_page/mental_health_page.dart';
import '../screens/progress_page/money_page/money_page.dart';

const List<Map<String, dynamic>> progressFields = [
  {
    'title': 'Money',
    'imageName': 'money',
    'description': 'Track your expenses',
    'route': MoneyPage(),
  },
  {'title': 'Physique', 'imageName': 'money', 'description': 'Track your physique progress'},
  {
    'title': 'Books',
    'imageName': 'money',
    'description': 'Read all of them!',
    'route': BooksPage(),
  },
  {
    'title': 'Meditation',
    'imageName': 'meditation',
    'description': 'Clear your mind'
  },
  {
    'title': 'Sleep',
    'imageName': 'meditation2',
    'description': 'Keep your sleeping schedule'
  },
  {
    'title': 'Journal',
    'imageName': 'money',
    'description': 'Track your feelings',
    'route': MentalHealthPage(),
  },
];

const List<Map<String, dynamic>> subscriptions = [
  {
    'name':'Spotify',
    'price':5.99,
  },
  {
    'name':'Netflix',
    'price':5.99,
  },
  {
    'name':'Youtube Premium',
    'price':5.99,
  },
  {
    'name':'HBO MAX',
    'price':5.99,
  },
  {
    'name':'Disney+',
    'price':5.99,
  },
  {
    'name':'Hulu',
    'price':5.99,
  },
  {
    'name':'Gym membership',
    'price':5.99,
  },
];

