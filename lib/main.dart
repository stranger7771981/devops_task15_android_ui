import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Request Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _endpoint = "";
  String _name = "";
  String _response = "";

  final TextEditingController _endpointController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      // Construct the request URL
      final url = Uri.parse("$_endpoint?name=$_name");

      // Send the request and wait for the response
      final response = await http.get(url);

      // Decode the response JSON and update the UI
      final data = (response.body);
      setState(() {
        _response = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API Request Demo"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _endpointController,
                decoration: const InputDecoration(
                  labelText: "API Endpoint",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an API endpoint";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _endpoint = value;
                  });
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Your Name",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitRequest,
                child: const Text("Submit"),
              ),
              const SizedBox(
                height: 20,
                width: 20,
              ),
              const Text("Server Response:"),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber),
                  ),
                  child: SingleChildScrollView(
                    child: Text(_response),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
