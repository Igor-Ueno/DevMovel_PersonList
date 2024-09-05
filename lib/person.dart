class Person {
  int? id;
  final String name;
  final int age;

  Person({
    this.id,
    required this.name,
    required this.age,
  });

  // Factory method to create an instance from a JSON map
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      age: json['age']
    );
  }

  // Convert a Board instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age
    };
  }
}