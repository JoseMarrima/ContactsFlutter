import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Contacts'),
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
  int _counter = 0;

  Map jsonData;
  List contacts;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future getContacts() async {
    http.Response response = await http
        .get("https://mock-rest-api-server.herokuapp.com/api/v1/user");

    jsonData = json.decode(response.body);

    setState(() {
      contacts = jsonData["data"];
    });

    debugPrint(contacts.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              var result = await showSearch(
                context: context,
                delegate: ContactSearch(),
              );

            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: contacts == null ? 0 : contacts.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.indigo,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            "${contacts[index]["first_name"]} ${contacts[index]["last_name"]}",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                            )),
                      )
                    ],
                  ),
                ),
              ),
            onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContactDetails(
                        Contact(contacts[index]["id"],
                            contacts[index]["first_name"],
                            contacts[index]["last_name"],
                            contacts[index]["email"],
                            contacts[index]["gender"],
                            contacts[index]["date_of_birth"],
                            contacts[index]["phone_no"])
                    )));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => AddContact()));},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ContactSearch extends SearchDelegate<Contact> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return null;
  }

}

class ContactDetails extends StatelessWidget {
  final Contact contact;

  ContactDetails(this.contact);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("${contact.first_name} ${contact.last_name}")),
    );
  }
}

class AddContact extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AddContactState();
}

class _AddContactState extends State<AddContact> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Add a contact")),
      body: new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            key: this._formKey,
            child: new ListView(
              children: <Widget>[
                new TextFormField(
                    keyboardType: TextInputType.text, // Use email input type for emails.
                    decoration: new InputDecoration(
                        hintText: 'Leo',
                        labelText: 'First Name'
                    )
                ),
                new TextFormField(
                    keyboardType: TextInputType.text, // Use email input type for emails.
                    decoration: new InputDecoration(
                        hintText: 'Messi',
                        labelText: 'Surname'
                    )
                ),
                new TextFormField(
                    keyboardType: TextInputType.emailAddress, // Use email input type for emails.
                    decoration: new InputDecoration(
                        hintText: 'you@example.com',
                        labelText: 'E-mail'
                    )
                ),
                new TextFormField(
                    keyboardType: TextInputType.text, // Use email input type for emails.
                    decoration: new InputDecoration(
                        hintText: 'Female',
                        labelText: 'Gender'
                    )
                ),
                new TextFormField(
                    keyboardType: TextInputType.datetime, // Use email input type for emails.
                    decoration: new InputDecoration(
                        hintText: '22/07/2021',
                        labelText: 'Date Of Birth'
                    )
                ),
                new TextFormField(
                    keyboardType: TextInputType.phone, // Use secure text for passwords.
                    decoration: new InputDecoration(
                        hintText: '123345345',
                        labelText: 'Phone No'
                    )
                ),
                new Container(
                  width: screenSize.width,
                  child: new RaisedButton(
                    child: new Text(
                      'Save',
                      style: new TextStyle(
                          color: Colors.white
                      ),
                    ),
                    onPressed: () => null,
                    color: Colors.blue,
                  ),
                  margin: new EdgeInsets.only(
                      top: 20.0
                  ),
                )
              ],
            ),
          )
      ),

    );
  }

}

class Contact {
  final String id;
  final String first_name;
  final String last_name;
  final String email;
  final String gender;
  final String date_of_birth;
  final String phone_no;

  Contact(this.id, this.first_name, this.last_name, this.email, this.gender,
      this.date_of_birth, this.phone_no);
}
