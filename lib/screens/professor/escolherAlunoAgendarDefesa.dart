import 'package:app_tcc/models/settingsFormOrientacao.dart';
import 'package:app_tcc/models/user.dart';
import 'package:app_tcc/services/auth.dart';
import 'package:app_tcc/services/database.dart';
import 'package:app_tcc/shared/constants.dart';
import 'package:app_tcc/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AgendarDefesa extends StatefulWidget {
  final User user;
  AgendarDefesa({Key key, @required this.user}):super(key:key);
  @override
  _AgendarDefesaState createState() => _AgendarDefesaState();
}

class _AgendarDefesaState extends State<AgendarDefesa> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DatabaseService banco = new DatabaseService();
  String _alunoUid = '';

  void agendarDefesa( )async{
    if(_alunoUid != ''){
      User aluno = await banco.getUser(_alunoUid);
      Navigator.pushNamed(context, '/formularioDeDefesa', arguments: ScreenArguments(professor: widget.user, aluno:aluno));
      _alunoUid = '';
    }
  }

   @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    ScrollController _controller = new ScrollController(keepScrollOffset: true);

    return  Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Escolha um aluno'),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sair', style: textStyle2.copyWith()),
            onPressed: () async {
              print(widget.user.uid);
              await _auth.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: StreamBuilder(
      stream: Firestore.instance.collection('usuario')
                                .where('orientador' ,isEqualTo: widget.user.uid)
                                .where('defesaPendente', isEqualTo: "")
                                .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Loading();
        
        return snapshot.data.documents.length == 0
              ? Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    Center(
                        child: Text(
                      "Não há orientandos para agendar defesa.",
                      style: textStyle,
                    ))]) :Column(
          children: <Widget>[
            Expanded(
                child: new ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _controller,
                  children: snapshot.data.documents.map((document) {
                    return new RadioListTile(
                      groupValue: _alunoUid,
                      value: document.documentID,
                      title: new Text(document['nome']),
                      onChanged: (val){
                        setState((){ 
                          _alunoUid = val.toString();
                        });
                        print(val);
                      },
                    );
                    }).toList(),
                  ),
              ),
              
              Expanded(
                                          child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(width: 10,),
                            Expanded(
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0),),
                                color: Colors.blue,
                                child: Text("Agendar",
                                    style: TextStyle(color: Colors.white)),
                                onPressed: agendarDefesa,
                              ),
                            ),
                            SizedBox(width: 10,),
                          ],
                        ),
                      ),
                    ),
            ],
          );
        },
        ),
      );
  }
}