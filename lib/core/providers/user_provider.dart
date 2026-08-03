import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../models/avatar_model.dart';
import '../models/progress_model.dart';
import '../services/database_service.dart';

class UserProvider extends ChangeNotifier {
  final DatabaseService _db;

  UserModel? _user;
  AvatarModel? _avatar;
  bool _isLoading = true;
  bool _onboardingComplete = false;

  UserProvider(this._db);

  UserModel? get user => _user;
  AvatarModel? get avatar => _avatar;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  bool get onboardingComplete => _onboardingComplete;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

    if (_onboardingComplete) {
      _user = await _db.getFirstUser();
      if (_user != null) {
        _avatar = await _db.getAvatar(_user!.id);
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createUser({
    required String nickname,
    required String ageBracket,
    String? genderPref,
    required String parentPin,
    required String prayerCity,
    double? latitude,
    double? longitude,
    required String calculationMethod,
    required Map<String, bool> prayerReminders,
    required Map<String, int> reminderDelays,
    required int baseSkin,
    String? headwearId,
    String? outfitId,
    int initialGrade = 1,
  }) async {
    final id = 'user_${DateTime.now().millisecondsSinceEpoch}';
    final pinHash = _hashPin(parentPin);

    final user = UserModel(
      id: id,
      nickname: nickname,
      ageBracket: ageBracket,
      genderPref: genderPref,
      parentPinHash: pinHash,
      prayerCity: prayerCity,
      latitude: latitude,
      longitude: longitude,
      calculationMethod: calculationMethod,
      prayerReminders: prayerReminders,
      reminderDelayMinutes: reminderDelays,
      createdAt: DateTime.now(),
    );

    final avatarModel = AvatarModel.initial(id).copyWith(
      baseSkin: baseSkin,
      headwearId: headwearId ?? 'chechia_white',
      outfitId: outfitId ?? 'outfit_default',
    );

    final progress = ProgressModel.initial(id).copyWith(currentGrade: initialGrade);

    await _db.saveUser(user);
    await _db.saveAvatar(avatarModel);
    await _db.saveProgress(progress);

    _user = user;
    _avatar = avatarModel;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    _onboardingComplete = true;

    notifyListeners();
  }

  Future<void> updateAvatar(AvatarModel updated) async {
    await _db.updateAvatar(updated);
    _avatar = updated;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    if (_user == null) return;
    _user = await _db.getUser(_user!.id);
    _avatar = await _db.getAvatar(_user!.id);
    notifyListeners();
  }

  bool verifyPin(String pin) {
    if (_user == null) return false;
    return _hashPin(pin) == _user!.parentPinHash;
  }

  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    return sha256.convert(bytes).toString();
  }
}
