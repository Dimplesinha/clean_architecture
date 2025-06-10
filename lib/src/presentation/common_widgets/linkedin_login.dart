import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:workapp/src/core/core_exports.dart';

class LinkedinLoginView extends StatefulWidget {
  final String? title;

  const LinkedinLoginView({super.key, required this.title});

  @override
  State<LinkedinLoginView> createState() => _LinkedinLoginViewState();
}

class _LinkedinLoginViewState extends State<LinkedinLoginView> {
  String? firstName = '';
  String? lastName = '';

  @override
  Widget build(BuildContext context) {
    return LinkedInUserWidget(
      appBar: AppBar(title: Text(widget.title ?? '')),
      destroySession: true,
      redirectUrl: AppConstants.redirectUrl,
      clientId: AppConstants.clientId,
      clientSecret: AppConstants.clientSecret,
      onError: (final UserFailedAction e) {
        log('Error: ${e.toString()}');
        log('Error: ${e.stackTrace.toString()}');
      },
      onGetUserProfile: (final UserSucceededAction linkedInUser) {
        String? displayName = linkedInUser.user.name;
        String? profilePic = linkedInUser.user.picture;
        // Split display name into first and last names
        if (displayName != null) {
          List<String> nameParts = displayName.split(' ');
          firstName = nameParts.isNotEmpty ? nameParts.first : '';
          lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        }
        AppRouter.pop(res: {
          ModelKeys.email: linkedInUser.user.email,
          ModelKeys.firstName: firstName,
          ModelKeys.lastName: lastName,
          ModelKeys.socialMediaUserId: linkedInUser.user.sub,
          ModelKeys.profilePic: profilePic
        });
      },
    );
  }
}
