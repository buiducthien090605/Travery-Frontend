class BookingListPageData {
  final int totalElements;
  final int totalPages;
  final int size;
  final List<BookingListItem> content;
  final int number;
  final bool first;
  final bool last;
  final bool empty;

  BookingListPageData({
    this.totalElements = 0,
    this.totalPages = 0,
    this.size = 0,
    List<BookingListItem>? content,
    this.number = 0,
    this.first = true,
    this.last = true,
    this.empty = true,
  }) : content = content ?? [];

  factory BookingListPageData.fromJson(Map<String, dynamic> json) {
    return BookingListPageData(
      totalElements: (json['totalElements'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      size: (json['size'] as num?)?.toInt() ?? 0,
      content:
          (json['content'] as List<dynamic>?)
              ?.map((e) => BookingListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      number: (json['number'] as num?)?.toInt() ?? 0,
      first: json['first'] as bool? ?? true,
      last: json['last'] as bool? ?? true,
      empty: json['empty'] as bool? ?? true,
    );
  }
}

class BookingListItem {
  final String id;
  final String name;
  final String thumbnailUrl;
  final String destinationName;
  final double price;
  final int durationDays;
  final double averageRating;
  final String status;
  final String startDate;
  final String endDate;

  BookingListItem({
    required this.id,
    this.name = '',
    this.thumbnailUrl = '',
    this.destinationName = '',
    this.price = 0,
    this.durationDays = 0,
    this.averageRating = 0,
    this.status = '',
    this.startDate = '',
    this.endDate = '',
  });

  factory BookingListItem.fromJson(Map<String, dynamic> json) {
    return BookingListItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      destinationName: json['destinationName'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      durationDays: (json['durationDays'] as num?)?.toInt() ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
    );
  }
}
