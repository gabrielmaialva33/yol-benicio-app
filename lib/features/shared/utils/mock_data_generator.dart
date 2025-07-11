import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

import '../../folders/models/folder.dart';
import '../models/client.dart';
import '../models/user.dart';
import '../../reports/models/area_division_data.dart';

class MockDataGenerator {
  final Faker faker;

  MockDataGenerator() : faker = Faker();

  User generateUser() {
    return User(
      id: faker.randomGenerator.integer(1000),
      fullName: faker.person.name(),
      email: faker.internet.email(),
      avatarUrl: faker.image.image(),
    );
  }

  Client generateClient() {
    return Client(
      id: faker.randomGenerator.integer(1000),
      name: faker.company.name(),
      document: faker.randomGenerator.boolean()
          ? '12.345.678/0001-90'
          : '123.456.789-00',
    );
  }

  Folder generateFolder() {
    return Folder(
      id: faker.randomGenerator.integer(1000),
      code: 'P${faker.randomGenerator.integer(10000)}',
      title: faker.lorem.sentence(),
      status: FolderStatus
          .values[faker.randomGenerator.integer(FolderStatus.values.length)],
      area: FolderArea
          .values[faker.randomGenerator.integer(FolderArea.values.length)],
      client: generateClient(),
      responsibleLawyer: generateUser(),
      createdAt: faker.date.dateTime(minYear: 2023, maxYear: 2024),
      documentsCount: faker.randomGenerator.integer(50),
      isFavorite: faker.randomGenerator.boolean(),
    );
  }

  List<Folder> generateFolders(int count) {
    return List.generate(count, (_) => generateFolder());
  }

  List<AreaDivisionData> generateAreaDivisionData() {
    return [
      AreaDivisionData(name: 'Trabalhista', value: 30.0, color: Colors.blue),
      AreaDivisionData(name: 'Penal', value: 25.0, color: Colors.red),
      AreaDivisionData(name: 'Cível', value: 20.0, color: Colors.green),
      AreaDivisionData(
          name: 'Cível Contencioso', value: 15.0, color: Colors.orange),
      AreaDivisionData(name: 'Tributário', value: 10.0, color: Colors.purple),
    ];
  }
}
