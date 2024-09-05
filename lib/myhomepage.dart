import 'package:devmovel_personlist/person.dart';
import 'package:devmovel_personlist/personviewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  late PersonViewModel viewModel;

  // @override
  // void initState() {
  //   super.initState();
  //   // listen: false -> avoid to rebuild the screen when there is state changes
  //   viewModel = Provider.of<PersonListViewModel>(context, listen: false);
  // }

  // void _add() {
  //   if (_formKey.currentState!.validate()) {
  //     viewModel.addPerson(_nameController.text, int.parse(_ageController.text));
  //     // Navigator.pop(context);
  //   }
  // }

  // void _clickItem(int index) {
  //   print("clicked in $index");
  //   var person = viewModel.persons[index];
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //       title: Text('Do you want to delete this person?'),
  //       content: Text('Only their register, of course!'),
  //       actions: [
  //         TextButton(
  //             onPressed: () {
  //               viewModel.remove(index);
  //               Navigator.pop(context);
  //             },
  //             child: Text('Yes')
  //         ),
  //         TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text('No')
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void showPersonDialog(int index) {
    print("Clicked in $index");
    Person person = viewModel.persons[index];
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Do you want to delete this person?'),
        content: Text('Only their register, of course!'),
        actions: [
          TextButton(
              onPressed: () {
                viewModel.deletePerson(person.id!);
                Navigator.pop(context);
              },
              child: Text('Yeah')
          ),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Not really')
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<PersonViewModel>(context, listen: false);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20,),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      // validator: (value) => validate(context, value),
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Name'
                      ),
                    ),
                    const SizedBox(height: 16,),
                    TextFormField(
                      controller: _ageController,
                      // validator: (value) => validate(context, value),
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Age'
                      ),
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () => viewModel.getPersons(),
                            child: const Text('Get Person List')
                        ),
                        ElevatedButton(
                            // onPressed: _add,
                            onPressed: () => viewModel.addPerson(_nameController.text, _ageController.text),
                            child: Text('Add New Person')
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ElevatedButton(
            //         onPressed: () => viewModel.getPersons(),
            //         child: const Text('Get People')
            //     ),
            //     ElevatedButton(
            //         onPressed: () {},
            //         child: const Text('Add New Person')
            //     )
            //   ],
            // ),
            const SizedBox(height: 10,),
            Text(
              "Number of people available: ${viewModel.numberOfPersons}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10,),
            Expanded(
                child: ListView.builder(
                    itemCount: viewModel.numberOfPersons,
                    itemBuilder: (context, index) {
                      final person = viewModel.persons[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            person.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(person.age.toString() + 'years old'),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            child: Text(person.id?.toString() ?? '?'),
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.message),
                            onPressed: () => showPersonDialog(index),
                            color: Colors.blue,
                          ),
                        ),
                      );
                    }
                )
            ),
            // FloatingActionButton(onPressed: onPressed)
          ],
        ),
    );
  }
}
