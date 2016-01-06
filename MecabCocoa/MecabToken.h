//
//  MecabNode.h
//  CabochaTest
//
//  Created by Morten Bertz on 3/2/15.
//  Copyright (c) 2015 Morten Bertz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MecabTokenizer.h"

@interface MecabToken : NSObject

typedef NS_ENUM(NSInteger, partOfSpeechType){
    pronoun =0,
    adverb =1,
    auxillaryVerb=2,
    particle=3,
    verb=4,
    noun=5,
    adjective=6,
    interjection=7,
    suffix=8,
    conjunction=9,
    prefix=10,
    numeral=11,
    unknown=100,
};




@property (nonatomic, retain) NSString *surface;
@property (nonatomic, retain) NSString *feature;
@property (nonatomic, retain) NSArray *features;
@property dictionaryType dictionary;
@property (nonatomic) partOfSpeechType partOfSpeechType;

// 品詞
- (NSString *)partOfSpeech;
// 品詞細分類1
- (NSString *)partOfSpeechSubtype1;
// 品詞細分類2
- (NSString *)partOfSpeechSubtype2;
// 品詞細分類3
- (NSString *)partOfSpeechSubtype3;
// 活用形
- (NSString *)inflection;
// 活用型
- (NSString *)useOfType;
// 原形
- (NSString *)originalForm;
// 読み
- (NSString *)reading;
// 発音
- (NSString *)pronunciation;




@end
