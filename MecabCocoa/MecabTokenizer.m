//
//  MecabTokenizer.m
//  CabochaTest
//
//  Created by Morten Bertz on 3/2/15.
//  Copyright (c) 2015 Morten Bertz. All rights reserved.
//

#import "MecabTokenizer.h"
#import "mecab.h"
#import "MecabToken.h"
#import "NSString+Mecab.h"

@implementation MecabTokenizer{
    mecab_t *mecab;
}



- (NSArray *)parseToNodeWithString:(NSString *)string {
    
    if (mecab == NULL) {

        NSString *path = [[NSBundle bundleForClass:[self class]]resourcePath];;
        path=[path stringByAppendingPathComponent:@"ipadic"];
        mecab = mecab_new2([[@"-d " stringByAppendingString:path] UTF8String]);
        
        if (mecab == NULL) {
            fprintf(stderr, "error in mecab_new2: %s\n", mecab_strerror(NULL));
            
            return @[];
        }
    }
    
    const mecab_node_t *node;
    const char *buf= [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSUInteger l= [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    node = mecab_sparse_tonode2(mecab, buf, l);
    if (node == NULL) {
        fprintf(stderr, "error\n");
        
        return @[];
    }
    
    NSMutableArray *newNodes = [NSMutableArray array];
    node = node->next;
    for (; node->next != NULL; node = node->next) {
        
        MecabToken *newNode = [MecabToken new];
        newNode.surface = [[NSString alloc] initWithBytes:node->surface length:node->length encoding:NSUTF8StringEncoding] ;
        newNode.feature = [NSString stringWithCString:node->feature encoding:NSUTF8StringEncoding];
        [newNodes addObject:newNode];
        
    }
    
    return [NSArray arrayWithArray:newNodes];
}


- (NSArray *)parseToNodeWithString:(NSString *)string withDictionary:(dictionaryType)dictionary{
    
    NSString *path = [[NSBundle bundleForClass:[self class]]resourcePath];
    
    if (mecab == NULL) {
        switch (dictionary) {
            case jumandic:
                path=[path stringByAppendingPathComponent:@"jumandic"];
                break;
            case ipadic:
                path=[path stringByAppendingPathComponent:@"ipadic"];
                break;
            case naist_jdic:
                path=[path stringByAppendingPathComponent:@"naist-jdic"];
                break;
            case unidic:
                path=[path stringByAppendingPathComponent:@"unidic"];
                break;
            default:
                break;
        }
    }
    
    if (dictionary!=iOSTokenizer) {
        
        mecab = mecab_new2([[@"-d " stringByAppendingString:path] UTF8String]);
        
        if (mecab == NULL) {
            fprintf(stderr, "error in mecab_new2: %s\n", mecab_strerror(NULL));
            
            return [self iOSTokenizerTokensForString:string];
        }
        const mecab_node_t *node;
        const char *buf= [string cStringUsingEncoding:NSUTF8StringEncoding];
        NSUInteger l= [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        
        node = mecab_sparse_tonode2(mecab, buf, l);
        if (node == NULL) {
            fprintf(stderr, "error\n");
            
            return @[];
        }
        
        NSMutableArray *newNodes = [NSMutableArray array];
        node = node->next;
        for (; node->next != NULL; node = node->next) {
            
            MecabToken *newNode = [MecabToken new];
            newNode.surface = [[NSString alloc] initWithBytes:node->surface length:node->length encoding:NSUTF8StringEncoding] ;
            newNode.feature = [NSString stringWithCString:node->feature encoding:NSUTF8StringEncoding];
            newNode.dictionary=dictionary;
            [newNodes addObject:newNode];
            
        }
        
        return [NSArray arrayWithArray:newNodes];
    }
    
    else{
        return [self iOSTokenizerTokensForString:string];
    }

    
}



- (NSArray *)parseToNodeWithString:(NSString *)string withDictionaryAtLocation:(NSString*)path type:(dictionaryType)type{
        
    if (type == iOSTokenizer) {
        return [self iOSTokenizerTokensForString:string];
    }
    
    mecab = mecab_new2([[@"-d " stringByAppendingString:path] UTF8String]);
    
    if (mecab == NULL) {
        fprintf(stderr, "error in mecab_new2: %s\n", mecab_strerror(NULL));
        
        return [self iOSTokenizerTokensForString:string];
    }
    const mecab_node_t *node;
    const char *buf= [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSUInteger l= [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    node = mecab_sparse_tonode2(mecab, buf, l);
    if (node == NULL) {
        fprintf(stderr, "error\n");
        
        return @[];
    }
    
    NSMutableArray *newNodes = [NSMutableArray array];
    node = node->next;
    for (; node->next != NULL; node = node->next) {
        
        MecabToken *newNode = [MecabToken new];
        newNode.surface = [[NSString alloc] initWithBytes:node->surface length:node->length encoding:NSUTF8StringEncoding] ;
        newNode.feature = [NSString stringWithCString:node->feature encoding:NSUTF8StringEncoding];
        newNode.dictionary=type;
        [newNodes addObject:newNode];
        
    }
   
    return [NSArray arrayWithArray:newNodes];
    
}


-(NSArray*)iOSTokenizerTokensForString:(NSString*)string{
    
    NSMutableArray *tokens=[NSMutableArray array];
    
    NSLocale *locale= [[NSLocale alloc]initWithLocaleIdentifier:@"ja_JP"];
    CFLocaleRef loc=(__bridge CFLocaleRef)(locale);
    CFStringRef stringref=(__bridge CFStringRef)(string);
    CFStringTokenizerRef tok = CFStringTokenizerCreate(NULL,
                                                       stringref,
                                                       CFRangeMake(0,string.length),
                                                       kCFStringTokenizerUnitWordBoundary,
                                                       loc);
    // goto the first token in the string
    CFStringTokenizerTokenType result  =CFStringTokenizerAdvanceToNextToken(tok);
    
    // enumerate the string
    while(result !=kCFStringTokenizerTokenNone){
        CFRange currentRange = CFStringTokenizerGetCurrentTokenRange(tok);
        NSString* subString = [string substringWithRange:NSMakeRange(currentRange.location, currentRange.length)];
        MecabToken *token=[MecabToken new];
        token.surface=subString;
        token.dictionary=iOSTokenizer;
        if (subString.scriptType&japaneseScriptTypeKanji) {
            if (@available(iOS 11.0, *)) { // workaround for a bug in iOS 11 where the locale of the tokenizer is overwritten or ignored
                CFStringTokenizerRef subTokenizer = CFStringTokenizerCreate(NULL,
                                                                      (__bridge CFStringRef) subString,
                                                                      CFRangeMake(0,subString.length),
                                                                      kCFStringTokenizerUnitWordBoundary,
                                                                      loc);
                CFStringTokenizerTokenType subStringResult=CFStringTokenizerAdvanceToNextToken(subTokenizer);
                NSMutableArray *subTokens=[NSMutableArray new];
                while(subStringResult != kCFStringTokenizerTokenNone){
                    CFTypeRef cTypeRef =  CFStringTokenizerCopyCurrentTokenAttribute(subTokenizer,kCFStringTokenizerAttributeLatinTranscription);
                    NSString *latin=[NSString stringWithFormat:@"%@",cTypeRef];
                    [subTokens addObject:latin];
                    CFRelease(cTypeRef);
                    subStringResult=CFStringTokenizerAdvanceToNextToken(subTokenizer);
                }

                CFRelease(subTokenizer);
                NSString *subToken=[subTokens componentsJoinedByString:@""];
                [token setFeature:subToken];

            }
            else{
                CFTypeRef cTypeRef =  CFStringTokenizerCopyCurrentTokenAttribute(tok,kCFStringTokenizerAttributeLatinTranscription);
                NSString *latin=[NSString stringWithFormat:@"%@",cTypeRef];
                [token setFeature:latin];
                CFRelease(cTypeRef);
            }
           
        }
       
        [tokens addObject:token];
        result =CFStringTokenizerAdvanceToNextToken(tok);
    }
    CFRelease(tok);

    return tokens.copy;
}








- (void)dealloc {
    if (mecab != NULL) {
        mecab_destroy(mecab);
    }
    
}



@end
