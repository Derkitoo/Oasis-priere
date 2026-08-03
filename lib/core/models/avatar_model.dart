class AvatarModel {
  final String id;
  final String userId;
  final int baseSkin; // 1–6
  final String? outfitId;
  final String? headwearId;
  final String expression; // 'happy', 'focused', 'peaceful'
  final String? accessoryId;
  final String? prayerRugId;
  final String? lanternId;
  final List<String> campDecorationIds;
  final List<String> unlockedItems;
  final int treeStage; // 0–10
  final int treeLeavesCount;

  const AvatarModel({
    required this.id,
    required this.userId,
    this.baseSkin = 1,
    this.outfitId,
    this.headwearId,
    this.expression = 'happy',
    this.accessoryId,
    this.prayerRugId,
    this.lanternId,
    this.campDecorationIds = const [],
    this.unlockedItems = const [],
    this.treeStage = 0,
    this.treeLeavesCount = 0,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'base_skin': baseSkin,
        'outfit_id': outfitId,
        'headwear_id': headwearId,
        'expression': expression,
        'accessory_id': accessoryId,
        'prayer_rug_id': prayerRugId,
        'lantern_id': lanternId,
        'camp_decoration_ids': campDecorationIds.join(','),
        'unlocked_items': unlockedItems.join(','),
        'tree_stage': treeStage,
        'tree_leaves_count': treeLeavesCount,
      };

  factory AvatarModel.fromMap(Map<String, dynamic> map) => AvatarModel(
        id: map['id'],
        userId: map['user_id'],
        baseSkin: map['base_skin'] ?? 1,
        outfitId: map['outfit_id'],
        headwearId: map['headwear_id'],
        expression: map['expression'] ?? 'happy',
        accessoryId: map['accessory_id'],
        prayerRugId: map['prayer_rug_id'],
        lanternId: map['lantern_id'],
        campDecorationIds: _splitList(map['camp_decoration_ids']),
        unlockedItems: _splitList(map['unlocked_items']),
        treeStage: map['tree_stage'] ?? 0,
        treeLeavesCount: map['tree_leaves_count'] ?? 0,
      );

  AvatarModel copyWith({
    int? baseSkin,
    String? outfitId,
    String? headwearId,
    String? expression,
    String? accessoryId,
    String? prayerRugId,
    String? lanternId,
    List<String>? campDecorationIds,
    List<String>? unlockedItems,
    int? treeStage,
    int? treeLeavesCount,
  }) =>
      AvatarModel(
        id: id,
        userId: userId,
        baseSkin: baseSkin ?? this.baseSkin,
        outfitId: outfitId ?? this.outfitId,
        headwearId: headwearId ?? this.headwearId,
        expression: expression ?? this.expression,
        accessoryId: accessoryId ?? this.accessoryId,
        prayerRugId: prayerRugId ?? this.prayerRugId,
        lanternId: lanternId ?? this.lanternId,
        campDecorationIds: campDecorationIds ?? this.campDecorationIds,
        unlockedItems: unlockedItems ?? this.unlockedItems,
        treeStage: treeStage ?? this.treeStage,
        treeLeavesCount: treeLeavesCount ?? this.treeLeavesCount,
      );

  AvatarModel addLeaf() {
    final newLeaves = treeLeavesCount + 1;
    // Stage monte tous les 5 feuilles, max 10
    final newStage = (newLeaves ~/ 5).clamp(0, 10);
    return copyWith(treeLeavesCount: newLeaves, treeStage: newStage);
  }

  AvatarModel unlockItem(String itemId) {
    if (unlockedItems.contains(itemId)) return this;
    return copyWith(unlockedItems: [...unlockedItems, itemId]);
  }

  static List<String> _splitList(dynamic raw) {
    if (raw == null || raw.toString().isEmpty) return [];
    return raw.toString().split(',').where((s) => s.isNotEmpty).toList();
  }

  factory AvatarModel.initial(String userId) => AvatarModel(
        id: '${userId}_avatar',
        userId: userId,
        baseSkin: 1,
        outfitId: 'outfit_default',
        headwearId: 'chechia_white',
        expression: 'happy',
        prayerRugId: 'rug_default',
        unlockedItems: ['outfit_default', 'chechia_white', 'rug_default'],
      );
}

class CosmeticItem {
  final String id;
  final String category; // 'outfit' | 'rug' | 'lantern' | 'camp_deco' | 'tasbih' | 'frame'
  final String name;
  final String description;
  final int xpCost;
  final bool isDefault;
  final String? unlocksAtGrade; // Grade requis (null = XP uniquement)
  final String? streakRequired; // Streak requis (nullable)

  const CosmeticItem({
    required this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.xpCost,
    this.isDefault = false,
    this.unlocksAtGrade,
    this.streakRequired,
  });
}
