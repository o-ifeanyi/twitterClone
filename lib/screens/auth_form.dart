import 'package:fc_twitter/bloc/auth_bloc.dart';
import 'package:fc_twitter/widgets/login_form.dart';
import 'package:fc_twitter/widgets/signup_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_twitter/util/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AuthForm extends StatefulWidget {
  static const String pageId = '/authForm';
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLogin = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      setState(() {
        _isLogin = ModalRoute.of(context).settings.arguments;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Icon(
          FontAwesome.twitter,
          color: Theme.of(context).primaryColor,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: _isLogin
            ? [
                FlatButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = false;
                    });
                  },
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: Config.xMargin(context, 4)),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {},
                )
              ]
            : null,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailed) {
            state.showSnackBar(context, _scaffoldKey, state.message);
          }
          if (state is AuthComplete) {
            Navigator.pop(context);
          }
        },

        builder: (context, state) => Form(
          key: _formKey,
          child: Stack(
            children: [
              _isLogin ? LoginForm(_formKey) : SignupForm(_formKey),
              if (state.isLoading) ...[
                Container(
                  alignment: Alignment.center,
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.4),
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
