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
    return [self mecabTokensForDictionary:iOSTokenizer];
}

-(NSArray*)mecabTokensForDictionary:(dictionaryType) dictionary{
    NSArray* tokens=[[MecabTokenizer alloc]parseToNodeWithString:self withDictionary:dictionary];
    return tokens;
}

-(NSArray*)mecabTokensForDictionary:(dictionaryType)dictionary atPath:(NSString *)path{
    NSArray *tokens=[[MecabTokenizer alloc]parseToNodeWithString:self withDictionaryAtLocation:path type:dictionary];
    return tokens;
}


-(NSArray*)lexicalFormsForDictionary:(dictionaryType)dictionary atPath:(NSString*)path{
    
    NSArray *tokens=[[MecabTokenizer alloc]parseToNodeWithString:self withDictionaryAtLocation:path type:dictionary];
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




-(NSDictionary*)furiganaReplacementsForDictionaryatPath:(NSString *)path type:(dictionaryType)type transliteration:(transliterationType)transliteration{
    NSDictionary *furigana=[self furiganaReplacementsForDictionaryatPath:path type:type];
    switch (transliteration) {
        case transliterationHiragana:
            return furigana;
            break;
        case transliterationKatakana:{
            
            NSMutableDictionary *temp=[NSMutableDictionary dictionary];
            for (NSValue *range in furigana) {
                NSString *hiraganaString=furigana[range];
                if (hiraganaString.scriptType &japaneseScriptTypeHiragana) {
                    NSString *katakanaString=[hiraganaString stringByTransliteratingHiraganaToKatakana];
                    [temp addEntriesFromDictionary:@{range:katakanaString}];
                }
            }
            return temp.copy;

            break;
        }
        case transliterationRomaji:{
            NSMutableDictionary *temp=[NSMutableDictionary dictionary];
            for (NSValue *range in furigana) {
                NSString *hiraganaString=furigana[range];
                if (hiraganaString.scriptType &japaneseScriptTypeHiragana) {
                    NSString *katakanaString=[hiraganaString stringByTransliteratingHiranagaToRomaji];
                    [temp addEntriesFromDictionary:@{range:katakanaString}];
                }
            }
            return temp.copy;

            break;
        }
        default:
            return nil;
            break;
    }
    return nil;
}


-(NSDictionary*)furiganaReplacementsWithTransliteration:(transliterationType)transliteration{
    return [self furiganaReplacementsForDictionary:iOSTokenizer transliteration:transliteration];
}


-(NSDictionary*)furiganaReplacementsForDictionary:(dictionaryType)dictionary transliteration:(transliterationType)transliteration{
    NSDictionary *furigana=[self furiganaReplacementsForDictionary:dictionary];
    switch (transliteration) {
        case transliterationHiragana:
            return furigana;
            break;
        case transliterationKatakana:{
            
            NSMutableDictionary *temp=[NSMutableDictionary dictionary];
            for (NSValue *range in furigana) {
                NSString *hiraganaString=furigana[range];
                if (hiraganaString.scriptType &japaneseScriptTypeHiragana) {
                    NSString *katakanaString=[hiraganaString stringByTransliteratingHiraganaToKatakana];
                    [temp addEntriesFromDictionary:@{range:katakanaString}];
                }
                
            }
            return temp.copy;
            break;
        }
        case transliterationRomaji:{
            NSMutableDictionary *temp=[NSMutableDictionary dictionary];
            for (NSValue *range in furigana) {
                NSString *hiraganaString=furigana[range];
                if (hiraganaString.scriptType &japaneseScriptTypeHiragana) {
                    NSString *katakanaString=[hiraganaString stringByTransliteratingHiranagaToRomaji];
                    [temp addEntriesFromDictionary:@{range:katakanaString}];
                }
            }
            return temp.copy;
            break;
        }
        default:
            return nil;
            break;
    }
    return nil;
    
}


-(NSString*)romajiStringWithDictionary:(dictionaryType)dictionary{
    
    NSArray *tokens=[[MecabTokenizer alloc]parseToNodeWithString:self withDictionary:dictionary];
    NSMutableString *hiraganaString=[NSMutableString string];
   // NSRange lastTokenRange=NSMakeRange(0, self.length);
    for (MecabToken *token in tokens) {
        
           // NSRange range=[hiraganaString rangeOfString:token.surface options:NSLiteralSearch range:lastTokenRange];
            NSString *furigana=[token reading];
            if (furigana.length>0) {
                
                if ([furigana scriptType]&japaneseScriptTypeKatakana) {
                    furigana=[furigana stringByTransliteratingKatakanaToHiragana];
                    furigana=[furigana stringByTransliteratingHiranagaToRomaji];
                }
                 [hiraganaString appendString:[NSString stringWithFormat:@"%@ ",furigana]];
            }
            else{
                NSString *surface=[token surface];
                if ((surface.scriptType &japaneseScriptTypeHiragana)) {
                    [hiraganaString appendString:[NSString stringWithFormat:@"%@ ",[surface stringByTransliteratingHiranagaToRomaji]]];
                }
                else if (surface.scriptType&japaneseScriptTypeKatakana){
                    [hiraganaString appendString:[NSString stringWithFormat:@"%@ ",[[surface stringByTransliteratingKatakanaToHiragana]stringByTransliteratingHiranagaToRomaji]]];
                }
                else{
                    [hiraganaString appendString:[NSString stringWithFormat:@"%@ ",surface]];
                }
            }
        
    }
    return hiraganaString.copy;
}



-(NSString*)romajiStringWithDictionaryatPath:(NSString*)path type:(dictionaryType)type{
    NSArray *tokens=[[MecabTokenizer alloc]parseToNodeWithString:self withDictionaryAtLocation:path type:type];
    NSMutableString *hiraganaString=[NSMutableString string];

    for (MecabToken *token in tokens) {
        NSString *furigana=[token reading];
        if (furigana.length>0) {
            
            if ([furigana scriptType]&japaneseScriptTypeKatakana) {
                furigana=[furigana stringByTransliteratingKatakanaToHiragana];
                furigana=[furigana stringByTransliteratingHiranagaToRomaji];
            }
            [hiraganaString appendString:[NSString stringWithFormat:@"%@ ",furigana]];
        }
        else{
            NSString *surface=[token surface];
            if ((surface.scriptType &japaneseScriptTypeHiragana)) {
                [hiraganaString appendString:[NSString stringWithFormat:@"%@ ",[surface stringByTransliteratingHiranagaToRomaji]]];
            }
            else if (surface.scriptType&japaneseScriptTypeKatakana){
                [hiraganaString appendString:[NSString stringWithFormat:@"%@ ",[[surface stringByTransliteratingKatakanaToHiragana]stringByTransliteratingHiranagaToRomaji]]];
            }
            else{
                [hiraganaString appendString:[NSString stringWithFormat:@"%@ ",surface]];
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

-(NSString*)stringByTransliteratingHiranagaToRomaji{
    
    NSMutableString *romaji=self.mutableCopy;
    CFMutableStringRef romajiRef=(__bridge CFMutableStringRef)(romaji);
    CFRange range=CFRangeMake(0, romaji.length);
    BOOL success=CFStringTransform(romajiRef, &range, kCFStringTransformLatinHiragana, YES);
    if (success) {
        NSString *hiragana=[(__bridge NSString *)(romajiRef) copy];
        return hiragana;
    }
    
    return nil;
}

-(NSOrderedSet*)kanjiCharacters{
    NSCharacterSet *kanjiCharacterset=[NSCharacterSet characterSetWithRange:NSMakeRange(0x4e00, 0x9fbf-0x4e00)];
    NSMutableOrderedSet *kanji=[[NSMutableOrderedSet alloc]init];
    for (NSUInteger i=0; i<self.length; i++) {
        unichar uni=[self characterAtIndex:i];
        if ([kanjiCharacterset characterIsMember:uni]) {
            NSString *str = [NSString stringWithFormat: @"%C", uni];
            [kanji addObject:str];
        }
    }
    return kanji.copy;
}

-(NSDictionary*)filterFuriganaDictionary:(NSDictionary*)furiganaDict{
    
    NSMutableDictionary *filteredFurigana=[NSMutableDictionary dictionary];
    for (NSValue *rangeValue in furiganaDict) {
        NSRange substringRange=rangeValue.rangeValue;
        NSString *originalSubstring=[self substringWithRange:substringRange];
        
        NSArray *kanjiComponents=[originalSubstring componentsSeparatedByCharactersInSet:[NSCharacterSet okuriganaCharacterSet]];
        
        kanjiComponents=[kanjiComponents filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *object, NSDictionary *bindings){
            if (object.length>0) {
                return YES;
            }
            return NO;
            
        }]];
        
        if (kanjiComponents.count>0){
            
            NSArray *okurigana=[originalSubstring componentsSeparatedByCharactersInSet:[NSCharacterSet kanjiCharacterSet]];
            NSMutableString *newFuriganaString=[furiganaDict[rangeValue]mutableCopy];
            NSRange newFuriganaRange=substringRange;
            
            for (NSString *okuriganaString in okurigana) {
                if (okuriganaString.length>0) {
                    NSRange frontRange=[newFuriganaString rangeOfString:okuriganaString options:NSLiteralSearch | NSAnchoredSearch];
                    if (frontRange.location!=NSNotFound) {
                        [newFuriganaString replaceCharactersInRange:frontRange withString:@""];
                        newFuriganaRange=NSMakeRange(newFuriganaRange.location+frontRange.length, newFuriganaRange.length-frontRange.length);
                    }
                    else{
                        NSRange backRange=[newFuriganaString rangeOfString:okuriganaString options:NSLiteralSearch | NSAnchoredSearch | NSBackwardsSearch];
                        if (backRange.location!=NSNotFound) {
                            [newFuriganaString replaceCharactersInRange:backRange withString:@""];
                            newFuriganaRange=NSMakeRange(newFuriganaRange.location, newFuriganaRange.length-backRange.length);
                            
                        }
                        else{
                            
                            NSRange middleRange=[newFuriganaString rangeOfString:okuriganaString options:NSLiteralSearch];
                            if (middleRange.location!=NSNotFound) {
                                [newFuriganaString replaceCharactersInRange:middleRange withString:@"　"];
                                // a bit hackish, but easier than trying to split the string into subtokens
                            }
                        }
                    }
                }
                
            }
            [filteredFurigana addEntriesFromDictionary:@{[NSValue valueWithRange:newFuriganaRange]:newFuriganaString.copy}];
            
        }
    }
    return filteredFurigana.copy;
}


-(NSString*)rubyHTML{
    
    NSDictionary *ruby=[self furiganaReplacements];
    return [self rubyHTMLWithFurigana:ruby];
}

-(nonnull NSString*)rubyHTMLWithFurigana:(nonnull NSDictionary<NSValue*,NSString*>*)furigana{
    NSMutableString *rubyAnnotated=self.mutableCopy;
    NSUInteger delta=0;
    NSArray *sortedRanges=[furigana.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSValue *r1, NSValue *r2){
    
        NSRange range1=r1.rangeValue;
        NSRange range2=r2.rangeValue;
        
        if (range1.location<range2.location){
            return NSOrderedAscending;
        }
        else if (range1.location>range2.location){
            return NSOrderedDescending;
        }
        else{
            return NSOrderedSame;
        }
    }];
    
    for (NSValue *rValue in sortedRanges) {
        NSString *ruby=furigana[rValue];
        NSRange range=rValue.rangeValue;
        NSRange correctedRange=NSMakeRange(range.location+delta, range.length);
        NSString *original=[rubyAnnotated substringWithRange:correctedRange];
        if(ruby.length>0){
            NSString *htmlRuby=[NSString stringWithFormat:@"<ruby>%@<rt>%@</rt></ruby>",original,ruby];
            NSUInteger d=htmlRuby.length-original.length;
            delta+=d;
            [rubyAnnotated replaceCharactersInRange:correctedRange withString:htmlRuby];
        }
    }
    
    return rubyAnnotated;
}


-(void)stripRubyTags:(void (^)(NSString * _Nonnull, NSArray<NSString *> * _Nonnull, NSArray<NSString *> * _Nonnull))completion{
    
    NSError *error;
    NSString *rubyRegEx=@"(?:<ruby>(\\w+?)(?:<rt>(.+?)</rt>){1}</ruby>)";
    NSRegularExpression *regEx=[NSRegularExpression regularExpressionWithPattern:rubyRegEx options:0 error:&error];
    NSMutableArray *annotatedCharacters=[NSMutableArray new];
    NSMutableArray *furiganaAnnotations=[NSMutableArray new];
    [regEx enumerateMatchesInString:self options:0 range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, __unused BOOL *stop){
        if (result.numberOfRanges>2) {
            NSRange subrange=[result rangeAtIndex:1];
            NSString *kanji=[self substringWithRange:subrange];
            NSString *furigana=[self substringWithRange:[result rangeAtIndex:2]];
            [annotatedCharacters addObject:kanji];
            [furiganaAnnotations addObject:furigana];
        }
    }];
    
    NSString *stripped=[regEx stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@"$1"];
    completion(stripped,annotatedCharacters,furiganaAnnotations);
}


@end
