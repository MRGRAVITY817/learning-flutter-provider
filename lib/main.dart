import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_overview_01/babies.dart';
import 'package:provider_overview_01/dog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Dog>(
          create: (context) => Dog(name: 'dog06', breed: 'breed06', age: 5),
        ),
        FutureProvider<int>(
            create: (context) {
              final int dogAge = context.read<Dog>().age;
              final babies = Babies(age: dogAge);
              return babies.getBabies();
            },
            initialData: 0)
      ],
      child: MaterialApp(
        title: 'Provider 06',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dog = Dog(name: 'dog03', breed: 'breed03');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Provider 06'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("- name: ${context.watch<Dog>().name}",
                style: const TextStyle(fontSize: 20.0)),
            const SizedBox(height: 10.0),
            const BreedAndAge()
          ],
        )));
  }
}

class BreedAndAge extends StatelessWidget {
  const BreedAndAge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('- breed: ${context.select<Dog, String>((dog) => dog.breed)}',
            style: const TextStyle(fontSize: 20.0)),
        const SizedBox(height: 10.0),
        const Age(),
      ],
    );
  }
}

class Age extends StatelessWidget {
  const Age({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('- age: ${context.select<Dog, int>((dog) => dog.age)}',
            style: const TextStyle(fontSize: 20.0)),
        const SizedBox(
          height: 10.0,
        ),
        Text('- number of babies: ${context.read<int>()}',
            style: const TextStyle(fontSize: 20.0)),
        const SizedBox(
          height: 20.0,
        ),
        ElevatedButton(
            onPressed: () => context.read<Dog>().grow(),
            child: const Text('Grow', style: TextStyle(fontSize: 20.0)))
      ],
    );
  }
}
