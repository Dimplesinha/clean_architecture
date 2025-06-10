class ListingStatistics {
  String title;
  String author;
  int calls;
  int emails;
  int messages;
  int uniqueVisitors;
  int totalViews;
  int clickToWebsite;
  DateTime dateCreated;
  DateTime lastRefreshed;
  Duration totalTimeActive;
  int avgViewsPerMonth;
  int totalLikes;
  int activeUsers;
  Duration totalTimeShared;

  ListingStatistics({
    required this.title,
    required this.author,
    required this.calls,
    required this.emails,
    required this.messages,
    required this.uniqueVisitors,
    required this.totalViews,
    required this.clickToWebsite,
    required this.dateCreated,
    required this.lastRefreshed,
    required this.totalTimeActive,
    required this.avgViewsPerMonth,
    required this.totalLikes,
    required this.activeUsers,
    required this.totalTimeShared,
  });

  factory ListingStatistics.fromJson(Map<String, dynamic> json) {
    return ListingStatistics(
      title: json['title'],
      author: json['author'],
      calls: json['calls'],
      emails: json['emails'],
      messages: json['messages'],
      uniqueVisitors: json['uniqueVisitors'],
      totalViews: json['totalViews'],
      clickToWebsite: json['clickToWebsite'],
      dateCreated: DateTime.parse(json['dateCreated']),
      lastRefreshed: DateTime.parse(json['lastRefreshed']),
      totalTimeActive: Duration(seconds: json['totalTimeActive']),
      avgViewsPerMonth: json['avgViewsPerMonth'],
      totalLikes: json['totalLikes'],
      activeUsers: json['activeUsers'],
      totalTimeShared: Duration(seconds: json['totalTimeShared']),
    );
  }
}