import 'package:flutter/material.dart';
import 'package:flutter_loja_online/UI/signup_screen.dart';
import 'package:flutter_loja_online/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Entrar"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Criar conta",
              style: TextStyle(fontSize: 15),
            ),
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
            },
          )
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: "E-mail"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text.isEmpty || !text.contains("@")) {
                        return "E-mail inválido";
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: "Senha"),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: (text) {
                      if (text.isEmpty || text.length < 6) {
                        return "Senha inválida";
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      child: Text(
                        "Esqueci minha senha",
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (_emailController.text.isEmpty) {
                          _showSnackBarMessage(
                              message: "Insira seu e-mail para recuperação",
                              backgroundColor: Theme.of(context).errorColor);
                        } else {
                          model.recoverPassword(_emailController.text);
                          _showSnackBarMessage(
                              message: "Um e-mail foi enviado para seu email!",
                              backgroundColor: Theme.of(context).primaryColor);
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 44,
                    child: RaisedButton(
                      child: Text(
                        "Entrar",
                        style: TextStyle(fontSize: 18),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          model.signIn(
                            email: _emailController.text,
                            password: _passwordController.text,
                            onSuccess: () => _onSuccess(context),
                            onFail: () => _onFail(context),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _onSuccess(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onFail(BuildContext context) {
    _showSnackBarMessage(
        message: "Falha ao entrar!",
        backgroundColor: Theme.of(context).errorColor);
  }

  void _showSnackBarMessage(
      {@required String message, @required Color backgroundColor}) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: 3),
    ));
  }
}
