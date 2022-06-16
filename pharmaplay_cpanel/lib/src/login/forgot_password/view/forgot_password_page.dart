import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmaplay_cpanel/generated/l10n.dart';
import 'package:pharmaplay_cpanel/src/login/forgot_password/forgot_password.dart';

//import '../forgot_password.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const ForgotPasswordPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(SLang.of(context).resetPassword)),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (context) {
            return ForgotPasswordBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context),
            );
          },
          child: ForgotPasswordForm(), // LoginForm(),
        ),
      ),
    );
  }
}
