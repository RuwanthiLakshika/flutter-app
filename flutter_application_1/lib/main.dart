import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'joke_service.dart';

void main() {
  runApp(const MyJokeApp());
}

class MyJokeApp extends StatelessWidget {
  const MyJokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const JokeHomePage(),
    );
  }
}

class JokeHomePage extends StatefulWidget {
  const JokeHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _JokeHomePageState createState() => _JokeHomePageState();
}

class _JokeHomePageState extends State<JokeHomePage> {
  final JokeService _jokeService = JokeService();
  List<Map<String, dynamic>> _jokes = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _fetchJokes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _jokes.clear();
    });

    try {
      final jokes = await _jokeService.fetchJokesRaw();
      setState(() {
        _jokes = jokes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load jokes. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Joke Generator'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Jokes Display Area
              Expanded(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : _errorMessage.isNotEmpty
                        ? Text(
                            _errorMessage,
                            style: const TextStyle(color: Colors.red),
                          )
                        : _jokes.isEmpty
                            ? const Text(
                                'Press the button to generate jokes!',
                                style: TextStyle(fontSize: 18),
                              )
                            : ListView.builder(
                                itemCount: _jokes.length,
                                itemBuilder: (context, index) {
                                  final joke = _jokes[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    elevation: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Joke ${index + 1}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          joke['type'] == 'single'
                                              ? Text(
                                                  joke['joke'],
                                                  style: const TextStyle(fontSize: 16),
                                                )
                                              : Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Setup: ${joke['setup']}',
                                                      style: const TextStyle(fontSize: 16),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      'Punchline: ${joke['delivery']}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontStyle: FontStyle.italic,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
              ),
              const SizedBox(height: 20),
              // Generate Jokes Button
              ElevatedButton(
                onPressed: _isLoading ? null : _fetchJokes,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  child: Text(
                    'Generate Jokes',
                    style: TextStyle(fontSize: 18),
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