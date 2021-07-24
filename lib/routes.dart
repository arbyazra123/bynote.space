import 'package:flutter/material.dart';

import 'modules/auth/blocs/authentication/authentication_bloc.dart';
import 'modules/auth/pages/login_page.dart';
import 'modules/main/pages/navigator_page.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [NavigatorPage.page()];
    case AppStatus.unauthenticated:
    default:
      return [LoginPage.page()];
  }
}
