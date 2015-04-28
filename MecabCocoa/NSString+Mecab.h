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



-(NSArray*)mecabTokens;
-(NSArray*)mecabTokensForDictionary:(dictionaryType) dictionary;

-(NSArray*)lexicalForms;
-(NSArray*)lexicalFormsForDictionary:(dictionaryType)dictionary;

-(NSArray*)readings;
-(NSArray*)readingsForDictionary:(dictionaryType)dictionary;

-(NSDictionary*)furiganaReplacements;
-(NSDictionary*)furiganaReplacementsForDictionary:(dictionaryType)dictionary;
-(NSDictionary*)furiganaReplacementsForDictionaryatPath:(NSString*)path type:(dictionaryType)type;

-(NSDictionary*)furiganaReplacementsForDictionaryatPath:(NSString*)path type:(dictionaryType)type transliteration:(transliterationType)transliteration;
-(NSDictionary*)furiganaReplacementsForDictionary:(dictionaryType)dictionary transliteration:(transliterationType)transliteration;
-(NSDictionary*)furiganaReplacementsWithTransliteration:(transliterationType)transliteration;


-(NSString*)hiraganaStringWithDictionary:(dictionaryType)dictionary;
-(NSString*)hiraganaStringWithDictionaryatPath:(NSString*)path type:(dictionaryType)type;


-(NSString*)romajiStringWithDictionary:(dictionaryType)dictionary;
-(NSString*)romajiStringWithDictionaryatPath:(NSString*)path type:(dictionaryType)type;


-(japaneseScriptType)scriptType;

-(NSString*)stringByTransliteratingKatakanaToHiragana;
-(NSString*)stringByTransliteratingHiraganaToKatakana;

-(NSString*)stringByTransliteratingRomajiToHiragana;

@end
