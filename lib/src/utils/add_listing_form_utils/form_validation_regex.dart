class FormValidationRegex {
  static RegExp businessEmailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  static RegExp imagePatternRegex = RegExp(r'.*\.(jpg|jpeg|png|gif|bmp|tiff|svg|webp)$', caseSensitive: false);
  static RegExp videoPatternRegex = RegExp(r'.*\.(mp4|mkv|avi|mov|wmv|flv|webm|m4v)$', caseSensitive: false);
  static RegExp networkUrlRegex = RegExp(r'^https?:\/\/', caseSensitive: false);
  static RegExp dateRegex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
  static RegExp urlRegex = RegExp(r'^(https?:\/\/)?(www\.)?([a-zA-Z0-9]+)(\.[a-zA-Z]{2,})(\/\S*)?$');
  static RegExp mobileRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
  static RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  static RegExp businessRegex = RegExp('[a-zA-Z]');
  static RegExp websiteRegex = RegExp(
    r'^(https?:\/\/)'
    r'((([a-z\d]([a-z\d-]*[a-z\d])*)\.)+[a-z]{2,}|'
    r'((\d{1,3}\.){3}\d{1,3}))'
    r'(:(\d+))?'
    r'(\/[-a-z\d%_.~+]*)*'
    r'(\?[;&a-z\d%_.~+=-]*)?'
    r'(\#[-a-z\d_]*)?$',
    caseSensitive: false, // case-insensitive matching
  );

  static RegExp nameRegex = RegExp(r'^(?:[0-9]+|[^a-zA-Z0-9]+|[^a-zA-Z]+)$');
}
