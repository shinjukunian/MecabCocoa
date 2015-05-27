//
//  NSCharacterSet+Japanese.m
//
//  Created by Matt Greenfield on 7/12/11.
//  No rights reserved.
//

#import "NSCharacterSet+Japanese.h"

@implementation NSCharacterSet (Japanese)

+ (instancetype)kanjiCharacterSet {
    return [NSCharacterSet characterSetWithRange:
            NSMakeRange(0x4e00, 0x9fbf-0x4e00)];
}

+ (instancetype)hiraganaCharacterSet {
    return [NSCharacterSet characterSetWithRange:
            NSMakeRange(0x3040, 0x309f-0x3040)];
}

+ (instancetype)katakanaCharacterSet {
    return [NSCharacterSet characterSetWithRange:
            NSMakeRange(0x30a0, 0x30ff-0x30a0)];
}

+ (instancetype)youonCharacterSet {
    return [NSCharacterSet characterSetWithCharactersInString:
            @"ゃゅょャュョ"];
}


+(instancetype)okuriganaCharacterSet{
    NSMutableCharacterSet *set=[NSMutableCharacterSet characterSetWithCharactersInString:@"っ"];
    [set formUnionWithCharacterSet:[NSCharacterSet hiraganaCharacterSet]];
    [set formUnionWithCharacterSet:[NSCharacterSet youonCharacterSet]];
    return set.copy;
}

@end
