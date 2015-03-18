//
//  MecabTokenizer.h
//  CabochaTest
//
//  Created by Morten Bertz on 3/2/15.
//  Copyright (c) 2015 Morten Bertz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MecabTokenizer : NSObject

typedef NS_ENUM(NSUInteger, dictionaryType){
    iOSTokenizer=0,
    ipadic,
    jumandic,
    unidic,
    naist_jdic,
    
};

- (NSArray *)parseToNodeWithString:(NSString *)string;
- (NSArray *)parseToNodeWithString:(NSString *)string withDictionary:(dictionaryType)dictionary;

- (NSArray *)parseToNodeWithString:(NSString *)string withDictionaryAtLocation:(NSString*)path type:(dictionaryType)type;



@end
