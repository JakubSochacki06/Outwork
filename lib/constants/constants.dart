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
  {
    'title': 'Journal',
    'imageName': 'meditation',
    'description': 'Track your feelings',
    'route': MentalHealthPage(),
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
    'imageName': 'meditation',
    'description': 'Keep your sleeping schedule'
  },
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

