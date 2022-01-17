import 'package:equatable/equatable.dart';

class Room extends Equatable {
  final String name;
  final String bio;
  final String imageUrl;
  final int numofMembers;

  const Room({
    required this.name,
    required this.bio,
    required this.imageUrl,
    this.numofMembers = 0,
  });

  Room copyWith({
    String? name,
    String? bio,
    String? imageUrl,
    int? numofMembers,
  }) {
    return Room(
      name: name ?? this.name,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
      numofMembers: numofMembers ?? this.numofMembers,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
