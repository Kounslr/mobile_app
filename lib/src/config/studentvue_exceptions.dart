class StudentVueExceptions implements Exception {
  StudentVueExceptions.errorMessageOne() {
    message = 'Server error. Please try again later.';
  }

  StudentVueExceptions.errorMessageTwo() {
    message = 'Incorrect email or password.';
  }

  StudentVueExceptions.errorMessageThree() {
    message = 'Kounslr doesn\'t support your school yet! 😔';
  }

  StudentVueExceptions.errorMessageFour() {
    message = 'Login failed.';
  }

  String message = '';

  @override
  String toString() => message;
}
