extension TextOverflowExtension on String {
  String textOverflowEllipsis(int maxLength) {
    if (length > maxLength) {
      return '${substring(0, maxLength)}...';
    }
    return this;
  }
}
