import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StaticFuture extends StatelessWidget {
  const StaticFuture({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Future Screen'),
      ),
      body: Center(
        child: FutureScreen(),
      ),
    );
  }
}

class FutureScreen extends StatefulWidget {
  const FutureScreen({super.key});

  @override
  State<FutureScreen> createState() => _FutureScreenState();
}

class _FutureScreenState extends State<FutureScreen> {

  final _formKey = GlobalKey<FormState>();
  Map<dynamic, dynamic> _pokemonData = {};
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> fetchData(String pokemon) async {
    try {
      final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemon');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = await json.decode(response.body);
        setState(() {
          _pokemonData = {
            'id' : data['id'],
            'name' : data['name'],
            'sprites' : data['sprites']['front_default'],
          };
        });
      } else {
        throw Exception('Failed to load data');
      }

    } catch (e) {
      throw Exception('Failed to load data: $e');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    labelText: 'Enter a Pokemon Name or Pekedex Id No.',
                    hintText: 'ditto, pikachu, bulbasaur...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter some text';
                    }

                    fetchData(value.trim().toLowerCase());
                    
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data: ${_textController.text}')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
        Text(
          _pokemonData['name'] != null ? 'Pokemon Name: ${_pokemonData['name']}' : '',
        ),
        Image.network(
        _pokemonData['sprites'] ?? 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/0.png',
        width: 300,
        height: 300,
        fit: BoxFit.cover,
        )
      ],
    );
  }
}