class webItem {
  final String webID;
  final String title;
  final String subtitle;
  final String imageURL;
  //final bool completed;

  webItem({
    required this.webID,
    required this.title,
    required this.subtitle,
    required this.imageURL,
    //required this.completed,
  });

  factory webItem.fromJson(Map<String, dynamic> json) {
    return webItem(
      webID: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      imageURL: json['image'],
      //completed: json['completed'],
    );
  }
}