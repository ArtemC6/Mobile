class ActivityChatData {
  ActivityChatData({
    required this.operationId,
    required this.title,
    required this.imagePath,
    required this.bannerPath,
    this.adminId = '',
    this.isVoccentAI = false,
    this.isLocalPath = false,
  });
  final String operationId;
  final String title;
  final String imagePath;
  final String bannerPath;
  final String adminId;
  final bool isVoccentAI;
  final bool isLocalPath;
}
