import 'package:flutter/material.dart';
import 'package:trade_buddy/utils/auth.dart';
import 'package:trade_buddy/main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum FormType { login, register, forgot }

class _LoginState extends State<Login> {
  FormType _formType = FormType.login;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPassword2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
          ),
          Image.asset(
            "images/logo_bmtrading.png",
            width: 120.0,
            height: 120.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
          ),
          ExpansionTile(
            leading: Icon(
              Icons.email,
              size: 40.0,
            ),
            title: Text("Login with E-Mail"),
            children: <Widget>[
              _formType == FormType.login
                  ? _getLoginForm()
                  : (_formType == FormType.register
                      ? _getRegisterForm()
                      : _getForgotForm())
            ],
          ),
        ],
      ),
    );
  }

  Widget _getLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
          ),
          TextFormField(
            controller: _controllerEmail,
            autocorrect: false,
            validator: (value) {
              if (!value.contains("@")) return "Please enter your e-mail";
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
              labelText: "E-Mail",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
          ),
          TextFormField(
            controller: _controllerPassword,
            autocorrect: false,
            validator: (value) {
              if (value.isEmpty) return "Please enter your password";
            },
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              labelText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
          ),
          Container(
            height: 60.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: FlatButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Auth
                      .emailSignIn(
                          _controllerEmail.text, _controllerPassword.text)
                      .then((b) {
                    if (b)
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => TradeBuddy()),
                          (_) => false);
                  });
                }
              },
              child: Text("Login"),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  _formKey?.currentState?.reset();
                  setState(() => _formType = FormType.register);
                },
                child: Text("Sign up"),
              ),
              FlatButton(
                onPressed: () {
                  _formKey?.currentState?.reset();
                  setState(() => _formType = FormType.forgot);
                },
                child: Text("Forgot password?"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getRegisterForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
          ),
          TextFormField(
            controller: _controllerEmail,
            autocorrect: false,
            validator: (value) {
              if (!value.contains("@")) return "Please enter your e-mail";
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
              labelText: "E-Mail",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
          ),
          TextFormField(
            controller: _controllerPassword,
            autocorrect: false,
            validator: (value) {
              if (value.length < 6)
                return "Please enter a password with at least 6 characters";
              if (value != _controllerPassword2.text)
                return "Please enter matching passwords";
            },
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              labelText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
          ),
          TextFormField(
            controller: _controllerPassword2,
            autocorrect: false,
            validator: (value) {
              if (value.length < 6)
                return "Please enter a password with at least 6 characters";
              if (value != _controllerPassword.text)
                return "Please enter matching passwords";
            },
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              labelText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
          ),
          Container(
            height: 60.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: FlatButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Auth
                      .createUser(
                          _controllerEmail.text, _controllerPassword.text)
                      .then((b) {
                    if (b)
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => TradeBuddy()),
                          (_) => false);
                  });
                }
              },
              child: Text("Sign up"),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  _formKey?.currentState?.reset();
                  setState(() => _formType = FormType.login);
                },
                child: Text("Login"),
              ),
              FlatButton(
                onPressed: () {
                  _formKey?.currentState?.reset();
                  setState(() => _formType = FormType.forgot);
                },
                child: Text("Forgot password?"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getForgotForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
          ),
          TextFormField(
            controller: _controllerEmail,
            autocorrect: false,
            validator: (value) {
              if (!value.contains("@")) return "Please enter your e-mail";
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
              labelText: "E-Mail",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
          ),
          Container(
            height: 60.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: FlatButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Auth.sendPasswordResetEmail(_controllerEmail.text);
                  Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Reset Password was sent to ${_controllerEmail.text}"),
                        duration: Duration(milliseconds: 3000),
                      ));
                }
              },
              child: Text("Send new Password"),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  _formKey?.currentState?.reset();
                  setState(() => _formType = FormType.register);
                },
                child: Text("Sign up"),
              ),
              FlatButton(
                onPressed: () {
                  _formKey?.currentState?.reset();
                  setState(() => _formType = FormType.login);
                },
                child: Text("Login"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
