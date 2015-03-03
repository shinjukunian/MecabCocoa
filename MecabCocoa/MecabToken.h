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


@property (nonatomic, retain) NSString *surface;
@property (nonatomic, retain) NSString *feature;
@property (nonatomic, retain) NSArray *features;
@property dictionaryType dictionary;

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
