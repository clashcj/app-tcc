import 'package:app_tcc/screens/authenticate/sign_in.dart';
import 'package:app_tcc/shared/constants.dart';
import 'package:app_tcc/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:app_tcc/services/auth.dart';

class RegisterProfessor extends StatefulWidget {

  @override
  _RegisterProfessorState createState() => _RegisterProfessorState();
}

class _RegisterProfessorState extends State<RegisterProfessor> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String matricula = '';
  String nome = '';
  String password = '';
  String email = '';
  String telefone = '';
  String tipoUsuario='Professor';
  String areaAtuacao='';
  String error = '';
  

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              elevation: 0.0,
              title: Text('Cadastro no App TCC')
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Matrícula'),
                          validator: (val) =>
                              val.isEmpty ? 'Digite uma matrícula.' : null,
                          onChanged: (val) {
                            setState(() => matricula = val);
                          }),
                      SizedBox(height: 20.0),
                      TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Nome'),
                          validator: (val) =>
                              val.isEmpty ? 'Digite um nome.' : null,
                          onChanged: (val) {
                            setState(() => nome = val);
                          }),
                      SizedBox(height: 20.0),
                      TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Senha'),
                          validator: (val) => val.length < 6
                              ? 'Digite uma senha com mais de 6 caracteres.': null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val);
                          }),
                      SizedBox(height: 20.0),
                      TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Email'),
                          validator: (val) =>
                              val.isEmpty ? 'Digite um email.' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          }),
                      SizedBox(height: 20.0),
                      TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Telefone'),
                          validator: (val) =>
                              val.isEmpty ? 'Digite um telefone.' : null,
                          onChanged: (val) {
                            setState(() => telefone = val);
                          }),
                      SizedBox(height: 20.0),
                      TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Área de atuação'),
                          validator: (val) =>
                              val.isEmpty ? 'Digite uma área de atuação.' : null,
                          onChanged: (val) {
                            setState(() => areaAtuacao = val);
                          }),
                      SizedBox(height: 20.0),
                      RaisedButton(
                          color: Colors.blue,
                          child: Text(
                            "Confirmar",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth.registroDeUsuario(
                                  matricula,
                                  password,
                                  nome,
                                  "",
                                  email,
                                  telefone,
                                  tipoUsuario,
                                  areaAtuacao,
                                  false);
                              if (result == null) {
                                setState(() {
                                  error = 'Erro ao registrar';
                                  loading = false;
                                });
                              }
                              else if(result == 1){
                                setState(() {
                                  error = 'Matricula já cadastrada';
                                  loading = false;
                                });
                              }
                              else 
                                Navigator.pushReplacementNamed(context, '/homeProfessor', arguments: result);
                            }
                          }),
                      SizedBox(height: 12.0),
                      Text(error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0))
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
