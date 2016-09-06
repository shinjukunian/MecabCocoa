//
//  MecabNode.m
//  CabochaTest
//
//  Created by Morten Bertz on 3/2/15.
//  Copyright (c) 2015 Morten Bertz. All rights reserved.
//

#import "MecabToken.h"

@implementation MecabToken


- (void)setFeature:(NSString *)value {
    if (value) {
        self.features = [value componentsSeparatedByString:@","];
    } else {
        self.feature = nil;
        self.features = nil;
    }
}

- (NSString *)partOfSpeech {
    if (!self.features || [self.features count] < 1) {
        return nil;
    }
    return [self.features objectAtIndex:0];
}

- (NSString *)partOfSpeechSubtype1 {
    if (!self.features || [self.features count] < 2) {
        return nil;
    }
    return [self.features objectAtIndex:1];
}

- (NSString *)partOfSpeechSubtype2 {
    if (!self.features || [_features count] < 3) {
        return nil;
    }
    return [_features objectAtIndex:2];
}

- (NSString *)partOfSpeechSubtype3 {
    if (!_features || [_features count] < 4) {
        return nil;
    }
    return [_features objectAtIndex:3];
}

- (NSString *)inflection {
    if (!self.features || [self.features count] < 5) {
        return nil;
    }
    return [self.features objectAtIndex:4];
}

- (NSString *)useOfType {
    if (!self.features || [self.features count] < 6) {
        return nil;
    }
    return [self.features objectAtIndex:5];
}


-(partOfSpeechType)partOfSpeechType{
    switch (self.dictionary) {
            
        case ipadic:{
            NSString *pos=[self partOfSpeech];
            if ([pos containsString:@"代名詞"]) {
                return pronoun;
            }
            else if ([pos containsString:@"副詞"]){
                return adverb;
            }
            else if ([pos containsString:@"助動詞"]){
                return auxillaryVerb;
            }
            else if ([pos containsString:@"助詞"]){
                return particle;
            }
            else if ([pos containsString:@"動詞"]){
                return verb;
            }
            else if ([pos containsString:@"名詞"]){
//                if ([self.partOfSpeechSubtype1 containsString:@"数詞"]) {
//                    return numeral;
//                }
                return noun;
            }
            else if ([pos containsString:@"形容詞"]){
                return adjective;
            }
            else if ([pos containsString:@"感動詞"]){
                return interjection;
            }
            else if ([pos containsString:@"接尾辞"]){
                return suffix;
            }
            else if ([pos containsString:@"接続詞"]){
                return conjunction;
            }
            else if ([pos containsString:@"接頭辞"]){
                return prefix;
            }
            break;
            
            
            break;
        }
            
            
        case unidic:{
            NSString *pos=[self partOfSpeech];
            if ([pos containsString:@"代名詞"]) {
                return pronoun;
            }
            else if ([pos containsString:@"副詞"]){
                return adverb;
            }
            else if ([pos containsString:@"助動詞"]){
                return auxillaryVerb;
            }
            else if ([pos containsString:@"助詞"]){
                return particle;
            }
            else if ([pos containsString:@"動詞"]){
                return verb;
            }
            else if ([pos containsString:@"名詞"]){
                if ([self.partOfSpeechSubtype1 containsString:@"数詞"]) {
                    return numeral;
                }
                return noun;
            }
            else if ([pos containsString:@"形容詞"]){
                return adjective;
            }
            else if ([pos containsString:@"感動詞"]){
                return interjection;
            }
            else if ([pos containsString:@"接尾辞"]){
                return suffix;
            }
            else if ([pos containsString:@"接続詞"]){
                return conjunction;
            }
            else if ([pos containsString:@"接頭辞"]){
                return prefix;
            }
            break;
        }
        default:{
            break;
        }
    }
    return unknown;
}


- (NSString *)originalForm {
    
    switch (self.dictionary) {
        case jumandic:
            if (!self.features || [self.features count] < 5) {
                return nil;
            }
            return [self.features objectAtIndex:4];
            break;
        case ipadic:
        case naist_jdic:
            if (!self.features || [self.features count] < 7) {
                return nil;
            }
            return [self.features objectAtIndex:6];
            break;
            
        case unidic:
            if (!self.features || [self.features count] < 7) {
                return nil;
            }
            return [self.features objectAtIndex:7];
            
            break;
        default:
            break;
    }
    
    return nil;
}

- (NSString *)reading {
    
    
    switch (self.dictionary) {
        case jumandic:
            if (!self.features || [self.features count] < 6) {
                return nil;
            }
            return [self.features objectAtIndex:5];
            break;
        case ipadic:
        case naist_jdic:
            if (!self.features || [self.features count] < 8) {
                return nil;
            }
            return [self.features objectAtIndex:7];
            
            break;
        case unidic:
            if (!self.features || [self.features count] < 18) {
                return nil;
            }
            return [self.features objectAtIndex:17];
            
            break;
        case iOSTokenizer:{
            if (!self.features || [self.features count] ==0) {
                return nil;
            }
            return [self.features objectAtIndex:0];
            break;
        }
        default:
            break;
    }
    
    return nil;
    
    
    
}

- (NSString *)pronunciation {
    if (!self.features || [self.features count] < 9) {
        return nil;
    }
    return [self.features objectAtIndex:8];
}

//- (void)dealloc {
//    self.surface = nil;
//    self.feature = nil;
//    self.features = nil;
//    
//    
//}







@end
