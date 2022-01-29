import 'package:flutter/material.dart';
import 'package:intercom/application/mixins/error_handling.dart';
import 'package:intercom/infrastructure/repositories/user_repository.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(
      {Key? key,
      required this.webApiServerAddress,
      required this.webSocketServerAddress,
      required this.username,
      required this.password,
      required this.onSave})
      : super(key: key);

  final String webApiServerAddress;
  final String webSocketServerAddress;
  final String username;
  final String password;
  final Function(
      {required String webApiServerAddress,
      required String webSocketServerAddress,
      required String username,
      required String password}) onSave;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with ErrorHandling {
  final _formKey = GlobalKey<FormState>();

  String? webApiServerAddress;
  String? webSocketServerAddress;
  String? username;
  String? password;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuration"),
      ),
      body: Center(
          child: Form(
              key: _formKey,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        autocorrect: false,
                        initialValue: widget.webApiServerAddress,
                        decoration: const InputDecoration(
                            label: Text('WebAPI Server Address'),
                            hintText: 'https://www.example.com'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field is required';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            webApiServerAddress = value;
                          });
                        },
                      ),
                      TextFormField(
                        autocorrect: false,
                        initialValue: widget.webSocketServerAddress,
                        decoration: const InputDecoration(
                            label: Text('WebSocket Server Address'),
                            hintText: 'wss://www.example.com:8000'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field is required';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            webSocketServerAddress = value;
                          });
                        },
                      ),
                      TextFormField(
                        autocorrect: false,
                        initialValue: widget.username,
                        decoration: const InputDecoration(
                            label: Text('Username'),
                            hintText: 'johndoe@example.com'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field is required';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            username = value;
                          });
                        },
                      ),
                      TextFormField(
                        autocorrect: false,
                        initialValue: widget.password,
                        decoration: const InputDecoration(
                            label: Text('Password'), hintText: 'fng1BFnhGo2E'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field is required';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  UserRepository(
                                          address: webApiServerAddress!,
                                          username: username!,
                                          password: password!)
                                      .getProfile()
                                      .then((userProfile) {
                                    widget.onSave(
                                        webApiServerAddress:
                                            webApiServerAddress!,
                                        webSocketServerAddress:
                                            webSocketServerAddress!,
                                        username: username!,
                                        password: password!);
                                  }).catchError((error) {
                                    showError(context, error.toString());
                                  });
                                }
                              },
                              child: const Text('Save'),
                            )
                          ],
                        ),
                      ),
                    ],
                  )))),
    );
  }
}
