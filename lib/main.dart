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
              // Since this executes only once, we cannot use `context.watch()` here
              final int dogAge = context.read<Dog>().age;
              final babies = Babies(age: dogAge);
              return babies.getBabies();
            },
            initialData: 0),
        StreamProvider(
            create: (context) {
              final int dogAge = context.read<Dog>().age;
              final babies = Babies(age: dogAge * 2);
              return babies.bark();
            },
            initialData: "Bark 0 times")
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
        body: Selector<Dog, String>(
            selector: (BuildContext context, Dog dog) => dog.name,
            builder: (BuildContext context, String name, Widget? child) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // `!` should be written behind `child` because it can be null
                  child!,
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text("- name: $name", style: const TextStyle(fontSize: 20.0)),
                  const SizedBox(height: 10.0),
                  const BreedAndAge()
                ],
              ));
            },
            // Since this don't need to be rerendered by context change, it should be in `child` props
            child: const Text("I like dogs very much",
                style: TextStyle(fontSize: 20.0))));
  }
}

class BreedAndAge extends StatelessWidget {
  const BreedAndAge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<Dog, String>(
      selector: (BuildContext context, Dog dog) => dog.breed,
      builder: (_, String breed, __) {
        return Column(
          children: [
            Text('- breed: $breed', style: const TextStyle(fontSize: 20.0)),
            const SizedBox(height: 10.0),
            const Age(),
          ],
        );
      },
    );
  }
}

class Age extends StatelessWidget {
  const Age({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<Dog, int>(
      selector: (BuildContext context, Dog dog) => dog.age,
      builder: (_, int age, __) {
        return Column(
          children: [
            Text('- age: $age', style: const TextStyle(fontSize: 20.0)),
            const SizedBox(
              height: 10.0,
            ),
            Text('- number of babies: ${context.read<int>()}',
                style: const TextStyle(fontSize: 20.0)),
            const SizedBox(
              height: 10.0,
            ),
            Text('- number of barks: ${context.watch<String>()}',
                style: const TextStyle(fontSize: 20.0)),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                onPressed: () => context.read<Dog>().grow(),
                child: const Text('Grow', style: TextStyle(fontSize: 20.0)))
          ],
        );
      },
    );
  }
}
