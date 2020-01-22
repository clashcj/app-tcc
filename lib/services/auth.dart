import 'package:app_tcc/models/user.dart';
import 'package:app_tcc/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

final FirebaseAuth _auth = FirebaseAuth.instance;
String nome = '';
String matricula = '';
String curso = '';

User _userFromFireBase(FirebaseUser user){
  return user != null ? User(uid: user.uid, nome: nome, matricula: matricula, curso: curso) : null;
}
  //auth change user stream

  Stream<User> get user{
    return _auth.onAuthStateChanged
      .map(_userFromFireBase);
  }

  //sign in with email and password
  Future logInComMatriculaESenha(String uid, String senha) async{
    try{
      final snapShot = await Firestore.instance.collection('usuario').document(uid).get();
      String email = snapShot.data['email'];
      nome = snapShot.data['nome'];
      matricula = snapShot.data['matricula'];
      curso = snapShot.data['curso'];
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: senha);
      FirebaseUser user = result.user;
      return _userFromFireBase(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }


  //register with email and password
  Future registroDeUsuario(String matricula, String senha, String nome, String curso, String email, String telefone, String tipoUsuario, String areaAtuacao, bool pedidoPendente) async{
    try{
      //verifica se matricula ja está cadastrada
      final snapShot = await Firestore.instance.collection('usuario').where('matricula', isEqualTo: matricula).limit(1).getDocuments();
      if(!(snapShot.documents.length == 1)){
        this.nome = nome;
        this.matricula = matricula;
        this.curso = curso;
        AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: senha);
        FirebaseUser user = result.user;
        await DatabaseService(uid: user.uid).updateUserData(matricula, senha, nome, email, curso, telefone,tipoUsuario, areaAtuacao, pedidoPendente);
        return _userFromFireBase(user);
      }
      else{
        return 1;
      }
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  
  //sign out

   Future signOut() async{
     try{
       return await _auth.signOut();
     }
     catch(e){
       print(e.toString());
     }
   }

   Future getTipoUsuario(String uid) async{
     try{
       final snapShot = await Firestore.instance.collection('usuario').document(uid).get();
       return snapShot.data['tipo'];
     }
     catch(e){
       print(e.toString());
     }
   }
}