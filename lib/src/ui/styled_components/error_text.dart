import 'package:canton_design_system/canton_design_system.dart';

class ErrorText extends StatelessWidget {
  const ErrorText(this.error, {Key? key}) : super(key: key);
  final String error;

  @override
  Widget build(BuildContext context) {
    return Text(
      error,
      style: Theme.of(context).textTheme.bodyText1?.copyWith(
            color: Theme.of(context).errorColor,
          ),
    );
  }
}
