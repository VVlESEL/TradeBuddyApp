import 'package:flutter/material.dart';
import 'package:trade_buddy/ui/legal/legal_ui.dart';
import 'package:trade_buddy/utils/auth.dart';
import 'package:trade_buddy/main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum FormType { login, register, forgot }

class _LoginState extends State<Login> {
  bool _isPolicyAccepted = false;
  Color _privacyPolicyColor = Colors.black;
  FormType _formType = FormType.login;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPassword2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "images/background_login.png",
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          color: Colors.white.withOpacity(0.5),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
              ),
              Image.asset(
                "images/icon_bmtrading.png",
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: _isPolicyAccepted,
                      onChanged: (b) => setState(() => _isPolicyAccepted = b),
                    ),
                    Flexible(
                      child: Column(
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => Legal())),
                            child: Text(
                              "I have read and accept the Privacy Policy and the EULA (click here to read)",
                              style: TextStyle(color: _privacyPolicyColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  if (!checkPrivacyPolicy()) return;

                  bool isSingedIn;
                  await Auth
                      .emailSignIn(
                          _controllerEmail.text, _controllerPassword.text)
                      .then((b) {
                    isSingedIn = b;
                  });
                  if (isSingedIn) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => TradeBuddy()),
                        (_) => false);
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Request failed! Please check your inputs and make sure you are connected to the internet."),
                          duration: Duration(milliseconds: 3000),
                        ));
                  }
                }
              },
              child: Text("Login", style: TextStyle(fontSize: 20.0)),
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
              onPressed: () async {
                if (!checkPrivacyPolicy()) return;

                if (_formKey.currentState.validate()) {
                  bool isCreated;
                  await Auth
                      .createUser(
                          _controllerEmail.text, _controllerPassword.text)
                      .then((b) {
                    isCreated = b;
                  });
                  if (isCreated) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => TradeBuddy()),
                        (_) => false);
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Request failed! Please check your inputs and make sure you are connected to the internet."),
                          duration: Duration(milliseconds: 3000),
                        ));
                  }
                }
              },
              child: Text("Sign up", style: TextStyle(fontSize: 20.0)),
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
              onPressed: () async {
                if (!checkPrivacyPolicy()) return;

                if (_formKey.currentState.validate()) {
                  bool isSent;
                  await Auth
                      .sendPasswordResetEmail(_controllerEmail.text)
                      .then((b) {
                    isSent = b;
                  });
                  Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                          !isSent
                              ? "Request failed! Please check your inputs and make sure you are connected to the internet."
                              : "Reset Link was sent to ${_controllerEmail
                          .text}.",
                        ),
                        duration: Duration(milliseconds: 3000),
                      ));
                }
              },
              child: Text("Reset Password", style: TextStyle(fontSize: 20.0)),
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

  bool checkPrivacyPolicy() {
    if (!_isPolicyAccepted) {
      setState(() => _privacyPolicyColor = Theme.of(context).errorColor);
      return false;
    } else {
      setState(() => _privacyPolicyColor = Colors.black);
      return true;
    }
  }
}
