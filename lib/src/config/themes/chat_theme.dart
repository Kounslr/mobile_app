import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

DefaultChatTheme chatTheme(BuildContext context) {
  return DefaultChatTheme(
    primaryColor: Theme.of(context).primaryColor,
    inputBackgroundColor: Theme.of(context).canvasColor,
    inputTextColor: Theme.of(context).colorScheme.primary,
    inputBorderRadius: BorderRadius.circular(27),
    messageBorderRadius: 27,
    inputTextStyle: Theme.of(context).textTheme.bodyText1!,
    receivedMessageBodyTextStyle:
        Theme.of(context).textTheme.bodyText1!.copyWith(
              height: 1,
              fontSize: 18,
            ),
    sentMessageBodyTextStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
          color: CantonColors.white,
          height: 1,
          fontSize: 18,
        ),
    dateDividerTextStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
          color: Theme.of(context).colorScheme.secondaryVariant,
          fontWeight: FontWeight.w600,
        ),
  );
}
