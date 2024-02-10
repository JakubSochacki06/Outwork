class Book {
  String? title;
  String? description;
  String? thumbnailURL;
  int? totalPages;
  int? readPages;

  Book({required this.title, required this.description, required this.thumbnailURL, required this.totalPages, required this.readPages});
  factory Book.fromMap(Map<String, dynamic> data) {
    Book book = Book(
      title: data['title'],
      description: data['description'],
      thumbnailURL: data['thumbnailURL'],
      totalPages: data['totalPages'],
      readPages: data['readPages'],
    );

    return book;
  }


  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'thumbnailURL':thumbnailURL,
      'totalPages':totalPages,
      'readPages':readPages,
    };
  }
}