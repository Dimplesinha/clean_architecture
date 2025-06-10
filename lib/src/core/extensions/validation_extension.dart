extension StringValidator on String? {
  bool isValidEmail() {
    return !isNullOrEmpty() &&
        RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(this!);
  }

  bool isValidPhone() {
    return RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$').hasMatch(this!);
  }

  bool isValidName() {
    return RegExp('[a-zA-Z]').hasMatch(this!);
  }

  bool isValidZip() {
    return RegExp(r'^\d{5}(?:[-\s]\d{4})?$').hasMatch(this!);
  }

  bool isNullOrEmpty() {
    return this == null || this!.isEmpty;
  }

  String getValidString() {
    return !isNullOrEmpty() ? this! : '';
  }

  bool equalsIgnoreCase(String compareTo) {
    return this?.toLowerCase() == compareTo.toLowerCase();
  }

  ///for checking password
  bool isValidPassword() {
    return !isNullOrEmpty() && RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$').hasMatch(this!);
  }

  bool isPasswordValid(String password) {
    // Regular expression pattern to check for valid characters
    RegExp validCharacters = RegExp(r'^[a-zA-Z0-9@#*_.]+$');

    // Check if the password has at least 6 characters
    if (password.length < 6 || password.length > 20) {
      return false;
    }

    // Check if the password contains only valid characters
    if (!validCharacters.hasMatch(password)) {
      return false;
    }

    return true;
  }

  bool isNumeric() {
    if (this == null) {
      return false;
    }
    return double.tryParse(this!) != null;
  }

  bool isContainsNumeric() {
    var match = RegExp(r'\d').hasMatch(this!);
    return match;
  }
}
