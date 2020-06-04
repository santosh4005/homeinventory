import 'package:flutter/material.dart';
import 'dart:io';
import './userimagepicker.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    File userimagefile,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final username = FocusNode();
  final password = FocusNode();

  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = "";
  String _username = "";
  String _userPassword = "";
  File _userImageFile;

  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _slideAnimation = Tween(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(curve: Curves.easeIn, parent: _controller));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.linear,
              height: !_isLogin ? 520 : 260,
              constraints: BoxConstraints(
                minHeight: !_isLogin ? 520 : 260,
              ),
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      constraints: BoxConstraints(
                        maxHeight: !_isLogin ? 160 : 0,
                        minHeight: !_isLogin ? 80 : 0,
                      ),
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: UserImagePicker(_pickImage),
                        ),
                      ),
                    ),
                    TextFormField(
                      key: ValueKey("email"),
                      onSaved: (newValue) => _userEmail = newValue,
                      validator: (value) {
                        if (value.isEmpty || !value.contains("@")) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) => _isLogin
                          ? FocusScope.of(context).requestFocus(password)
                          : FocusScope.of(context).requestFocus(username),
                      decoration: InputDecoration(
                        labelText: "Email",
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      constraints: BoxConstraints(
                        maxHeight: !_isLogin ? 120 : 0,
                        minHeight: !_isLogin ? 60 : 0,
                      ),
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: TextFormField(
                            key: ValueKey("username"),
                            onSaved: (newValue) => _username = newValue,
                            validator: (value) {
                              if (!_isLogin &&
                                  (value.isEmpty || value.length < 8)) {
                                return "username must be at least 8 characters";
                              }
                              return null;
                            },
                            focusNode: username,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) =>
                                FocusScope.of(context).requestFocus(password),
                            decoration: InputDecoration(labelText: "Username"),
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      key: ValueKey("password"),
                      onSaved: (newValue) => _userPassword = newValue,
                      validator: (value) {
                        if (value.isEmpty || value.length < 8) {
                          return "Password must be at least 8 characters";
                        }
                        return null;
                      },
                      focusNode: password,
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Password"),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    if (widget.isLoading)
                      CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    if (!widget.isLoading)
                      RaisedButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: _submitForm,
                          child: Text(_isLogin ? "Login" : "Sign Up")),
                    if (!widget.isLoading)
                      FlatButton(
                        child: Text(_isLogin
                            ? "Create new account"
                            : "Already have an account"),
                        textColor: Theme.of(context).primaryColor,
                        onPressed: _switchAuthMode,
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _switchAuthMode() {
    if (_isLogin) {
      setState(() {
        _isLogin = false;
      });
      _controller.forward();
    } else {
      setState(() {
        _isLogin = true;
      });
      _controller.reverse();
    }
  }

  void _pickImage(File pickedImage) {
    _userImageFile = pickedImage;
  }

  void _submitForm() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please pick an image"),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _username.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }
}