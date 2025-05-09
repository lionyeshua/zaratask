import 'package:flutter/material.dart';
import 'package:zaratask/models/topic_model.dart';
import 'package:zaratask/services/supabae_database_service.dart';

class TopicsProvider extends ChangeNotifier {
  TopicsProvider(this._db, this._ownerId) {
    //_init();
  }

  late SupabaseDatabaseService _db;
  late String _ownerId;

  List<Topic> _topics = [];
  List<Topic> get topics => _topics;
  /*
  void _init() {
    streamLists();
  }

 
  void streamLists() {
    _repository.stream('SELECT * FROM lists').listen((response) {
      if (response.successful) {
        ServiceLocator.logger.i('streamLists receieved data');
        _lists = response.data?.map(MyList.fromJson).toList() ?? [];
        notifyListeners();
      } else {
        MessengerService.showError(response.message ?? 'Could not get lists');
      }
    });
  }

  Future<void> createList(String name) async {
    final response = await _repository.insertOne(
      'INSERT INTO lists (id, name, owner_id, created_at) VALUES (?, ?, ?, ?)',
      [ServiceLocator.uuid.v4, name, _ownerId, ServiceLocator.dt.nowUtcEpoch],
    );

    if (response.successful) {
      ServiceLocator.logger.i('Inserted ${response.rowsInserted} rows');
    } else {
      MessengerService.showError(response.message ?? 'Could not create list');
    }
  }

  Future<void> deleteList(String id) async {
    final response = await _repository.delete(
      'DELETE FROM lists WHERE id = ?',
      [id],
    );

    if (response.successful) {
      ServiceLocator.logger.i('Deleted rows');
    } else {
      MessengerService.showError(response.message ?? 'Could not delete list');
    }
  }

  Future<void> renameList(String id, String newName) async {
    final response = await _repository.update(
      'UPDATE lists SET name = ? WHERE id = ?',
      [newName, id],
    );

    if (response.successful) {
      ServiceLocator.logger.i('Updated ${response.rowsUpdated} rows');
    } else {
      MessengerService.showError(response.message ?? 'Could not rename list');
    }
  }
  */
}
