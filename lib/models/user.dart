class User {
  final String? id;
  final String email;
  final String? name;
  final String password;
  // Constructor
  User({
    this.id,
    required this.email,
    this.name,
    required this.password,
  });

  // From JSON method to create a User object from the response
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      password: json[
          'password'], // You can modify this if you are handling password differently
    );
  }

  // To JSON method to convert the User object into a map (useful for sending data to API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password, // Again, be mindful of how you handle passwords
    };
  }
}
