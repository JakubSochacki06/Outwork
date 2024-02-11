class Book {
  String? title;
  String? thumbnailURL;
  String? author;
  int? totalPages;
  int? readPages;

  Book({required this.title, required this.author, required this.thumbnailURL, required this.totalPages, required this.readPages});

  factory Book.fromMap(Map<String, dynamic> data) {
    Book book = Book(
      title: data['title'],
      thumbnailURL: data['thumbnailURL'],
      author: data['author'],
      totalPages: data['totalPages'],
      readPages: data['readPages'],
    );

    return book;
  }

  factory Book.fromGoogleAPI(Map<String, dynamic> data){
    return Book(
      title: data['volumeInfo']['title'],
      author: data['volumeInfo']['authors'][0],
      totalPages: data['volumeInfo']['pageCount'],
      readPages: 0,
      thumbnailURL: data['volumeInfo']['imageLinks']
      ['thumbnail'],
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'thumbnailURL':thumbnailURL,
      'author':author,
      'totalPages':totalPages,
      'readPages':readPages,
    };
  }
}