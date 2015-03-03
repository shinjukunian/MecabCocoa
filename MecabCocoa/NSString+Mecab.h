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
    japaneseScriptTypeHiragana = 1 << 0,
    japaneseScriptTypeKatakana = 1 << 1,
    japaneseScriptTypeKanji = 1 << 2,
  
};

-(NSArray*)mecabTokens;
-(NSArray*)mecabTokensForDictionary:(dictionaryType) dictionary;

-(NSArray*)lexicalForms;
-(NSArray*)lexicalFormsForDictionary:(dictionaryType)dictionary;

-(NSArray*)readings;
-(NSArray*)readingsForDictionary:(dictionaryType)dictionary;

-(NSDictionary*)furiganaReplacements;
-(NSDictionary*)furiganaReplacementsForDictionary:(dictionaryType)dictionary;

-(japaneseScriptType)scriptType;



-(NSString*)stringByTransliteratingKatakanaToHiragana;
-(NSString*)stringByTransliteratingHiraganaToKatakana;

-(NSString*)stringByTransliteratingRomajiToHiragana;

@end
