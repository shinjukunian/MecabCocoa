//
//  NSString+Mecab.m
//  Mecab
//
//  Created by Morten Bertz on 3/2/15.
//  Copyright (c) 2015 Morten Bertz. All rights reserved.
//

#import "NSString+Mecab.h"
#import "MecabToken.h"
#import "NSCharacterSet+Japanese.h"

@implementation NSString (NSString_Mecab)


-(NSArray*)mecabTokens{
    return [self mecabTokensForDictionary:ipadic];
}

-(NSArray*)mecabTokensForDictionary:(dictionaryType) dictionary{
    NSArray* tokens=[[MecabTokenizer alloc]parseToNodeWithString:self withDictionary:dictionary];
    if (tokens.count>0) {
        return tokens;
    }
    return nil;
}


-(NSArray*)lexicalForms{
    return [self lexicalFormsForDictionary:ipadic];
}

-(NSArray*)lexicalFormsForDictionary:(dictionaryType)dictionary{
    
    NSArray *tokens=[self mecabTokensForDictionary:dictionary];
    NSMutableArray *lexicalForms=[NSMutableArray array];
    for (MecabToken *token in tokens) {
        NSString *lexicalForm=[token originalForm];
        if (lexicalForm.length>0) {
            [lexicalForms addObject:lexicalForm];
        }
       
    }
    return lexicalForms.copy;
}


-(NSArray*)readings{
    return [self readingsForDictionary:ipadic];
}

-(NSArray*)readingsForDictionary:(dictionaryType)dictionary{
    NSArray *tokens=[self mecabTokensForDictionary:dictionary];
    NSMutableArray *readings=[NSMutableArray array];
    for (MecabToken *token in tokens) {
        NSString *reading=[token reading];
        if (reading.length>0) {
            [readings addObject:reading];
        }
        
    }
    return readings.copy;
}



-(NSDictionary*)furiganaReplacements{
    return [self furiganaReplacementsForDictionary:ipadic];
}


-(NSDictionary*)furiganaReplacementsForDictionary:(dictionaryType)dictionary{
    
    NSArray *tokens=[[MecabTokenizer alloc]parseToNodeWithString:self withDictionary:dictionary];
    NSMutableDictionary *furiganaReplacements=[NSMutableDictionary dictionary];
    NSRange lastTokenRange=NSMakeRange(0, self.length);
    for (MecabToken *token in tokens) { 
        if ([token.surface scriptType]&japaneseScriptTypeKanji) {
            NSRange range=[self rangeOfString:token.surface options:NSLiteralSearch range:lastTokenRange];
            NSString *furigana=[token reading];
            if (range.location!=NSNotFound && furigana.length>0) {
                
                if ([furigana scriptType]&japaneseScriptTypeKatakana) {
                    furigana=[furigana stringByTransliteratingKatakanaToHiragana];
                }
                else if (!([furigana scriptType]&japaneseScriptTypeHiragana) || !([furigana scriptType]&japaneseScriptTypeKatakana) || !([furigana scriptType]&japaneseScriptTypeKanji)){
                    furigana=[furigana stringByTransliteratingRomajiToHiragana];
                }
                
                [furiganaReplacements addEntriesFromDictionary:@{[NSValue valueWithRange:range]:furigana}];
                lastTokenRange=NSMakeRange(NSMaxRange(range), self.length-NSMaxRange(range));
            }
        }

    }
    
    return furiganaReplacements.copy;
}

-(NSDictionary*)furiganaReplacementsForDictionaryatPath:(NSString*)path type:(dictionaryType)type{
    
    NSArray *tokens=[[MecabTokenizer alloc]parseToNodeWithString:self withDictionaryAtLocation:path type:type];
    NSMutableDictionary *furiganaReplacements=[NSMutableDictionary dictionary];
    NSRange lastTokenRange=NSMakeRange(0, self.length);
    for (MecabToken *token in tokens) {
        if ([token.surface scriptType]&japaneseScriptTypeKanji) {
            NSRange range=[self rangeOfString:token.surface options:NSLiteralSearch range:lastTokenRange];
            NSString *furigana=[token reading];
            if (range.location!=NSNotFound && furigana.length>0) {
                
                if ([furigana scriptType]&japaneseScriptTypeKatakana) {
                    furigana=[furigana stringByTransliteratingKatakanaToHiragana];
                }
                else if (!([furigana scriptType]&japaneseScriptTypeHiragana) || !([furigana scriptType]&japaneseScriptTypeKatakana) || !([furigana scriptType]&japaneseScriptTypeKanji)){
                    furigana=[furigana stringByTransliteratingRomajiToHiragana];
                }
                
                [furiganaReplacements addEntriesFromDictionary:@{[NSValue valueWithRange:range]:furigana}];
                lastTokenRange=NSMakeRange(NSMaxRange(range), self.length-NSMaxRange(range));
            }
        }
        
    }
    
    return furiganaReplacements.copy;
}

-(NSString*)hiraganaStringWithDictionary:(dictionaryType)dictionary{
    
    NSArray *tokens=[[MecabTokenizer alloc]parseToNodeWithString:self withDictionary:dictionary];
    NSMutableString *hiraganaString=[self mutableCopy];
    NSRange lastTokenRange=NSMakeRange(0, self.length);
    for (MecabToken *token in tokens) {
        if ([token.surface scriptType]&japaneseScriptTypeKanji) {
            NSRange range=[hiraganaString rangeOfString:token.surface options:NSLiteralSearch range:lastTokenRange];
            NSString *furigana=[token reading];
            if (range.location!=NSNotFound && furigana.length>0) {
                
                if ([furigana scriptType]&japaneseScriptTypeKatakana) {
                    furigana=[furigana stringByTransliteratingKatakanaToHiragana];
                }
                else if (!([furigana scriptType]&japaneseScriptTypeHiragana) || !([furigana scriptType]&japaneseScriptTypeKatakana) || !([furigana scriptType]&japaneseScriptTypeKanji)){
                    furigana=[furigana stringByTransliteratingRomajiToHiragana];
                }
                
                [hiraganaString replaceCharactersInRange:range withString:furigana];
                lastTokenRange=NSMakeRange(NSMaxRange(range), hiraganaString.length-NSMaxRange(range));
            }
        }
        
    }
    
    return hiraganaString.copy;
}


-(NSString*)hiraganaStringWithDictionaryatPath:(NSString*)path type:(dictionaryType)type{
    
    NSArray *tokens=[[MecabTokenizer alloc]parseToNodeWithString:self withDictionaryAtLocation:path type:type];
    NSMutableString *hiraganaString=[self mutableCopy];
    NSRange lastTokenRange=NSMakeRange(0, self.length);
    for (MecabToken *token in tokens) {
        if ([token.surface scriptType]&japaneseScriptTypeKanji) {
            NSRange range=[hiraganaString rangeOfString:token.surface options:NSLiteralSearch range:lastTokenRange];
            NSString *furigana=[token reading];
            if (range.location!=NSNotFound && furigana.length>0) {
                
                if ([furigana scriptType]&japaneseScriptTypeKatakana) {
                    furigana=[furigana stringByTransliteratingKatakanaToHiragana];
                }
                else if (!([furigana scriptType]&japaneseScriptTypeHiragana) || !([furigana scriptType]&japaneseScriptTypeKatakana) || !([furigana scriptType]&japaneseScriptTypeKanji)){
                    furigana=[furigana stringByTransliteratingRomajiToHiragana];
                }
                
                [hiraganaString replaceCharactersInRange:range withString:furigana];
                lastTokenRange=NSMakeRange(NSMaxRange(range), hiraganaString.length-NSMaxRange(range));
            }
        }
        
    }
    
    return hiraganaString.copy;
}

-(japaneseScriptType)scriptType{
    
    japaneseScriptType type=0;
    
    for(int i = 0; i<[self length];i++){
        unichar aChar = [self characterAtIndex:i];
        if ([[NSCharacterSet hiraganaCharacterSet] characterIsMember:aChar]) {
            type|=japaneseScriptTypeHiragana;
        }
        if ([[NSCharacterSet katakanaCharacterSet] characterIsMember:aChar]) {
            type|=japaneseScriptTypeKatakana;
        }
        if ([[NSCharacterSet kanjiCharacterSet] characterIsMember:aChar]) {
            type|=japaneseScriptTypeKanji;
        }

    }
    return type;
}




-(NSString*)stringByTransliteratingKatakanaToHiragana{
    
    NSMutableString *katakana=self.mutableCopy;
    CFMutableStringRef katakanaRef=(__bridge CFMutableStringRef)(katakana);
    CFRange range=CFRangeMake(0, katakana.length);
    BOOL success=CFStringTransform(katakanaRef, &range, kCFStringTransformHiraganaKatakana, YES);
    
    if (success) {
        NSString *hiragana=[(__bridge NSString *)(katakanaRef) copy];
        return hiragana;
    }
    
    return nil;
    
}


-(NSString*)stringByTransliteratingHiraganaToKatakana{
    NSMutableString *hiragana=self.mutableCopy;
    CFMutableStringRef hiraganaRef=(__bridge CFMutableStringRef)(hiragana);
    CFRange range=CFRangeMake(0, hiragana.length);
    BOOL success=CFStringTransform(hiraganaRef, &range, kCFStringTransformHiraganaKatakana, NO);
    
    if (success) {
        NSString *katakana=[(__bridge NSString *)(hiraganaRef) copy];
        return katakana;
    }
    
    return nil;
}


-(NSString*)stringByTransliteratingRomajiToHiragana{
    
    NSMutableString *romaji=self.mutableCopy;
    CFMutableStringRef romajiRef=(__bridge CFMutableStringRef)(romaji);
    CFRange range=CFRangeMake(0, romaji.length);
    BOOL success=CFStringTransform(romajiRef, &range, kCFStringTransformLatinHiragana, NO);    
    if (success) {
        NSString *hiragana=[(__bridge NSString *)(romajiRef) copy];
        return hiragana;
    }
    
    return nil;
}




@end
