
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PreferenceProvider {

  PreferenceProvider._privateConstructor();

  static final PreferenceProvider _instance = PreferenceProvider._privateConstructor();

  static PreferenceProvider get instance => _instance;

  Future insertIntoList(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedList = prefs.getStringList(key) ?? [];
    if(!savedList.contains(value)) {
      savedList.add(value);
    }
    await prefs.setStringList(key, savedList);
  }
  Future removeFromList(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedList = prefs.getStringList(key) ?? [];
    if(savedList.contains(value)) {
      savedList.remove(value);
    }
    await prefs.setStringList(key, savedList);
  }
  Future<bool> checkExistList(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedList = prefs.getStringList(key) ?? [];
    if(savedList.contains(value)){
      return true;
    }
    return false;
  }
  Future<List<String>> getList(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedList = prefs.getStringList(key) ?? [];
    return savedList;
  }
  Future<bool> setString(String key, String value) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(key, value);
  }

   Future<String> getString(String key) async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getString(key) ?? '';
    return value;
  }

   Future<bool> setDoubleValue(String key, double value) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setDouble(key, value);
  }

   Future<double?> getDoubleValue(String key) async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getDouble(key);
    return value;
  }

   Future<void> saveJsonToPrefs(
      Map<String, dynamic> json, String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(json);
      await prefs.setString(key, jsonString);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
   Future<void> removeJsonToPref(String key) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(key);
  }

   Future<Map<String, dynamic>?> getJsonFromPrefs(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        final json = jsonDecode(jsonString);
        return json;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}