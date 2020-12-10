import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/authentication/data/model/user_model.dart';
import 'package:fc_twitter/features/authentication/representation/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupForm extends StatefulWidget {
  final _formKey;
  SignupForm(this._formKey);
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _signupUsernameController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();
  final _signupDateController = TextEditingController();
  final _signupDateFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create your account',
            style: TextStyle(
              fontSize: Config.xMargin(context, 8),
              fontWeight: FontWeight.w700,
            ),
          ),
          Spacer(),
          TextFormField(
            controller: _signupUsernameController,
            maxLength: 50,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
            validator: (val) {
              if (val.isEmpty) {
                return 'Feild cannot be empty';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _signupEmailController,
            decoration: InputDecoration(
              labelText: 'Phone number or email address',
            ),
            validator: (val) {
              if (val.isEmpty) {
                return 'Feild cannot be empty';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _signupPasswordController,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
            validator: (val) {
              if (val.isEmpty) {
                return 'Feild cannot be empty';
              }
              if (val.length < 6) {
                return 'Password cannot be less than 6 characters';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _signupDateController,
            focusNode: _signupDateFocus,
            decoration: InputDecoration(
              labelText: 'Confirm password',
            ),
            validator: (val) {
              if (val != _signupPasswordController.text) {
                return 'Confirm password failed';
              }
              return null;
            },
          ),
          Spacer(),
          Divider(
            thickness: 1,
            height: 25,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                bool isValid = widget._formKey.currentState.validate();
                if (!isValid) return;
                FocusScope.of(context).unfocus();
                context.read<AuthBloc>().add(
                      SignUp(
                          user: UserModel(
                        email: _signupEmailController.text,
                        userName: _signupUsernameController.text,
                        password: _signupPasswordController.text,
                      )),
                    );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  'Sign up',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Config.xMargin(context, 4),
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
