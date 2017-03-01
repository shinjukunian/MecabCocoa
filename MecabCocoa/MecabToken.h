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




@property (nonatomic,nonnull) NSString *surface;
@property (nonatomic,nullable) NSString *feature;
@property (nonatomic,nullable) NSArray *features;
@property dictionaryType dictionary;
@property (nonatomic) partOfSpeechType partOfSpeechType;





// 品詞
- (nullable NSString *)partOfSpeech;
// 品詞細分類1
- (nullable NSString *)partOfSpeechSubtype1;
// 品詞細分類2
- (nullable NSString *)partOfSpeechSubtype2;
// 品詞細分類3
- (nullable NSString *)partOfSpeechSubtype3;
// 活用形
- (nullable NSString *)inflection;
// 活用型
- (nullable NSString *)useOfType;
// 原形
- (nullable NSString *)originalForm;
// 読み
- (nullable NSString *)reading;
// 発音
- (nullable NSString *)pronunciation;




@end
