import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<User>> getUsers()async{
    var data= await http.get("http://www.json-generator.com/api/json/get/cvDbOkrwvC?indent=2");
    var jsonData=json.decode(data.body);
    List<User> users=[];
    for(var u in jsonData){
      User user=User(u["index"],u["number"],u["district"],u["email"],u["name"],u["state"]);
      users.add(user);
    }
    return users;

  }
  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Helpline"),
        backgroundColor: Colors.orange,

      ),
      body:Container(
        child: FutureBuilder(
          future: getUsers(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Container(
                child: Center(
                  child: Text("Loading"),
                ),
              );
            }
            else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context,int index){

                return ListTile(
                  leading:CircleAvatar(
                    backgroundColor: Colors.orange,
                  ),
                  title: Text(snapshot.data[index].name),
                  subtitle:Text(snapshot.data[index].email),
                  onTap: (){
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context)=> MyDetailspage(snapshot.data[index])));
                  },
                );
              }
              );
            }
          },
        ),
      ),
    );
  }
}




class MyDetailspage extends StatelessWidget {
final User user;
MyDetailspage(this.user);

Future<void> _launched;
String phoneNumber;

Future<void> _makePhoneCall(String url) async{
  if(await canLaunch(url)){
    await launch(url);
  }
  else{
    return "Could not Launch";
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        backgroundColor: Colors.orange,
      ),
      body:Center(
        child: Container(
          height: 150.0,
          width: 500.0,
          child: Center(
            child: Card(
              color: Colors.orange[100],
              elevation: 50.0,
              child: Column(children: <Widget>[
                Text(user.name),
                Text(user.email),
                Text(user.district),
                Text(user.state),
                RaisedButton(
                  onPressed: (){
                    _makePhoneCall("tel: ${user.number}");
                  },
                  child: Text(user.number),
                  ),

              ],),
            ),
            ),
        ),
      ),
    );
  }
}
class User{
  final int index;
  final String name;
  final String district;
  final String email;
  final String number;
  final String state;
  User(this.index,this.number,this.district,this.email,this.name,this.state);
}
