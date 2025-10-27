class ChatViewModel {
  final String name;
  final String message;
  final String time;
  final String avatarUrl;
  final int unReadMessageCount;
  final bool isOnline;

  ChatViewModel({
    required this.name,
    required this.message,
    required this.time,
    required this.avatarUrl,
    required this.unReadMessageCount,
    required this.isOnline,
  });

  factory ChatViewModel.fromJson(Map<String, dynamic> json) {
    return ChatViewModel(
      name: json['name'],
      message: json['message'],
      time: json['time'],
      avatarUrl: json['avatarUrl'],
      unReadMessageCount: json['unReadMessageCount'],
      isOnline: json['isOnline'],
    );
  }

  toMap() {
    return {
      'name': name,
      'message': message,
      'time': time,
      'avatarUrl': avatarUrl,
      'unReadMessageCount': unReadMessageCount,
      'isOnline': isOnline,
    };
  }
}
