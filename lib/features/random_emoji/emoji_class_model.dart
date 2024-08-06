import '../features.dart';

enum EmojiClass {
  smiley,
  gestureAndBodyParts,
  peopleAndFantasy,
  clothingAndAccessories,
  animalsAndNature,
  foodAndDrink,
  activityAndSports,
  travelAndPlaces,
  objects,
  symbols,
  flag,
  newEmoji,
}

extension EmojiExtension on EmojiClass {
  String get label {
    switch (this) {
      case EmojiClass.smiley:
        return 'Smiley';
      case EmojiClass.gestureAndBodyParts:
        return 'Gesture & Body Parts';
      case EmojiClass.peopleAndFantasy:
        return 'People & Fantasy';
      case EmojiClass.clothingAndAccessories:
        return 'Clothing & Accessories';
      case EmojiClass.animalsAndNature:
        return 'Animals & Nature';
      case EmojiClass.foodAndDrink:
        return 'Food & Drink';
      case EmojiClass.activityAndSports:
        return 'Activity & Sports';
      case EmojiClass.travelAndPlaces:
        return 'Travel & Places';
      case EmojiClass.objects:
        return 'Objects';
      case EmojiClass.symbols:
        return 'Symbols';
      case EmojiClass.flag:
        return 'Flag';
      case EmojiClass.newEmoji:
        return 'New Emoji';
    }
  }

  List<String> get emoji {
    switch (this) {
      case EmojiClass.smiley:
        return smileyEmoji;
      case EmojiClass.gestureAndBodyParts:
        return gestureAndBodyPartsEmoji;
      case EmojiClass.peopleAndFantasy:
        return peopleAndFantasyEmoji;
      case EmojiClass.clothingAndAccessories:
        return clothingAndAccessoriesEmoji;
      case EmojiClass.animalsAndNature:
        return animalsAndNatureEmoji;
      case EmojiClass.foodAndDrink:
        return foodAndDrinkEmoji;
      case EmojiClass.activityAndSports:
        return activityAndSportsEmoji;
      case EmojiClass.travelAndPlaces:
        return travelAndPlacesEmoji;
      case EmojiClass.objects:
        return objectsEmoji;
      case EmojiClass.symbols:
        return symbolsEmoji;
      case EmojiClass.flag:
        return flagEmoji;
      case EmojiClass.newEmoji:
        return newEmoji;
    }
  }
}
