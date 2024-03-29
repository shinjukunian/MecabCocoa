//
//  MecabTokenizer.h
//  CabochaTest
//
//  Created by Morten Bertz on 3/2/15.
//  Copyright (c) 2015 Morten Bertz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MecabToken;

@interface MecabTokenizer : NSObject

typedef NS_ENUM(NSInteger, dictionaryType){
    iOSTokenizer=0,
    ipadic,
    jumandic,
    unidic,
    naist_jdic,
    
};

- (nonnull NSArray<MecabToken*>*)parseToNodeWithString:(nonnull NSString *)string withDictionaryAtLocation:(nonnull NSString*)path type:(dictionaryType)type;
- (nonnull NSArray<MecabToken*>*)parseToNodeWithString:(nonnull NSString *)string;
- (nonnull NSArray<MecabToken*>*)parseToNodeWithString:(nonnull NSString *)string withDictionary:(dictionaryType)dictionary;


@end
