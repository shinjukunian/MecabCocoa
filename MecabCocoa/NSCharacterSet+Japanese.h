//
//  NSCharacterSet+Japanese.h
//
//  Created by Matt Greenfield on 7/12/11.
//  No rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCharacterSet (Japanese)

+ (nonnull instancetype)kanjiCharacterSet;
+ (nonnull instancetype)hiraganaCharacterSet;
+ (nonnull instancetype)katakanaCharacterSet;
+ (nonnull instancetype)youonCharacterSet;
+ (nonnull instancetype)okuriganaCharacterSet;
@end
