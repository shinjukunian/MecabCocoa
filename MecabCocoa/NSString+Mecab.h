//
//  NSString+Mecab.h
//  Mecab
//
//  Created by Morten Bertz on 3/2/15.
//  Copyright (c) 2015 Morten Bertz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MecabTokenizer.h"
@interface  NSString (NSString_Mecab)

typedef NS_OPTIONS(NSInteger, japaneseScriptType){
    japaneseScriptTypeNoJapaneseScript=0,
    japaneseScriptTypeHiragana = 1 << 0,
    japaneseScriptTypeKatakana = 1 << 1,
    japaneseScriptTypeKanji = 1 << 2,
  
};


typedef NS_ENUM(NSInteger, transliterationType){
    transliterationHiragana,
    transliterationKatakana,
    transliterationRomaji,

};



-(nonnull NSArray<MecabToken*>*)mecabTokensForDictionary:(dictionaryType) dictionary atPath:(nonnull NSString *)path;
-(nonnull NSArray<NSString*>*)lexicalFormsForDictionary:(dictionaryType)dictionary atPath:(nonnull NSString*)path;
-(nonnull NSDictionary<NSValue*,NSString*>*)furiganaReplacementsForDictionaryatPath:(nonnull NSString*)path type:(dictionaryType)type;
-(nonnull NSDictionary<NSValue*,NSString*>*)furiganaReplacementsForDictionaryatPath:(nonnull NSString*)path type:(dictionaryType)type transliteration:(transliterationType)transliteration;
-(nonnull NSString*)hiraganaStringWithDictionaryatPath:(nonnull NSString*)path type:(dictionaryType)type;
-(nonnull NSString*)romajiStringWithDictionaryatPath:(nonnull NSString*)path type:(dictionaryType)type;



@property (nonnull, readonly) NSArray<MecabToken*> *mecabTokens;
@property (nonnull, readonly) NSArray<NSString*> *readings;
@property (nonnull, readonly) NSDictionary<NSValue*,NSString*> *furiganaReplacements;
@property (nonnull, readonly) NSOrderedSet<NSString*>* kanjiCharacters;
@property (nonnull, readonly) NSString* rubyHTML;



-(nonnull NSArray<MecabToken*>*)mecabTokensForDictionary:(dictionaryType) dictionary;
-(nonnull NSArray<NSString*>*)readingsForDictionary:(dictionaryType)dictionary;
-(nonnull NSDictionary<NSValue*,NSString*>*)furiganaReplacementsForDictionary:(dictionaryType)dictionary;


-(nonnull NSDictionary<NSValue*,NSString*>*)furiganaReplacementsForDictionary:(dictionaryType)dictionary transliteration:(transliterationType)transliteration;
-(nonnull NSDictionary<NSValue*,NSString*>*)furiganaReplacementsWithTransliteration:(transliterationType)transliteration;

-(nonnull NSString*)hiraganaStringWithDictionary:(dictionaryType)dictionary;

-(nonnull NSString*)romajiStringWithDictionary:(dictionaryType)dictionary;
-(nonnull NSString*)rubyHTMLWithFurigana:(nonnull NSDictionary<NSValue*,NSString*>*)furigana;


-(japaneseScriptType)scriptType;
-(nonnull NSString*)stringByTransliteratingKatakanaToHiragana;
-(nonnull NSString*)stringByTransliteratingHiraganaToKatakana;
-(nonnull NSString*)stringByTransliteratingRomajiToHiragana;
-(nonnull NSDictionary <NSValue*,NSString*>*)filterFuriganaDictionary:(nonnull NSDictionary <NSValue*,NSString*>*)furiganaDict;

-(void)stripRubyTags:(void (^_Nonnull)(NSString * _Nonnull strippedHTML, NSArray <NSString*> * _Nonnull annotatedCharacters, NSArray <NSString*> * _Nonnull furiganaAnnotations))completion;


@end
