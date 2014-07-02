//
//  MTArrayTransformer.m
//  ModelTransformer
//
//  Created by Tobias Kräntzer on 13.02.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "ModelTransformer.h"

#import "MTArrayTransformer.h"

@interface MTArrayTransformer () {
    NSArray *_mt_array;
    NSPointerArray *_mt_cache;
    NSUInteger _mt_count;
    Class _mt_class;
    NSDictionary *_mt_userInfo;
}

@end

@implementation MTArrayTransformer

#pragma mark Array From JSON-File

+ (instancetype)arrayWithContentsOfJSONFile:(NSURL *)fileURL
                           formatVersionKey:(NSString *)formatVersionKey
                              rootObjectKey:(NSString *)rootObjectKey
                                     entity:(NSEntityDescription *)entity
                                   userInfo:(NSDictionary *)userInfo
                                      error:(NSError **)error
{
    return [self arrayWithContentsOfJSONFile:fileURL
                            formatVersionKey:formatVersionKey
                               rootObjectKey:rootObjectKey
                                      entity:entity
                                    userInfo:userInfo
                                       class:[MTObjectTransformer class]
                                       error:error];
}

+ (instancetype)arrayWithContentsOfJSONFile:(NSURL *)fileURL
                           formatVersionKey:(NSString *)formatVersionKey
                              rootObjectKey:(NSString *)rootObjectKey
                                     entity:(NSEntityDescription *)entity
                                   userInfo:(NSDictionary *)userInfo
                                      class:(__unsafe_unretained Class)_class
                                      error:(NSError *__autoreleasing *)error
{
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    NSDictionary *values = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
    if (values) {
        NSString *formatVersion = [values valueForKey:formatVersionKey];
        NSArray *rootArray = [values valueForKey:rootObjectKey];
        if ([rootArray isKindOfClass:[NSArray class]]) {
            NSMutableDictionary *_userInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
            if (formatVersion) {
                [_userInfo setValue:formatVersion forKey:MTFormatVersionKey];
            }
            return [[self alloc] initWithArray:rootArray entity:entity userInfo:userInfo class:_class];
        }
    }
    return nil;
}

#pragma mark Life-cycle

- (instancetype)initWithArray:(NSArray *)array
                       entity:(NSEntityDescription *)entity
                     userInfo:(NSDictionary *)userInfo
{
    return [self initWithArray:array entity:entity userInfo:userInfo class:[MTObjectTransformer class]];
}

- (instancetype)initWithArray:(NSArray *)array entity:(NSEntityDescription *)entity userInfo:(NSDictionary *)userInfo class:(Class)_class
{
    self = [super init];
    if (self) {
        _entity = entity;
        _mt_class = _class;
        _mt_userInfo = userInfo;
        _mt_array = [array copy];
        _mt_count = NSUIntegerMax;
        _mt_cache = [NSPointerArray strongObjectsPointerArray];
        [_mt_cache setCount:[_mt_array count]];
    }
    return self;
}

#pragma mark Transform Object

- (id)transformedObjectAtIndex:(NSUInteger)index ofArray:(NSArray *)array userInfo:(NSDictionary *)userInfo
{
    id object = [array objectAtIndex:index];
    return [[_mt_class alloc] initWithObject:object entity:self.entity userInfo:userInfo];
}

- (NSUInteger)transformedCountOfArray:(NSArray *)array userInfo:(NSDictionary *)userInfo
{
    return [array count];
}

#pragma mark NSArray

- (NSUInteger)count
{
    if (_mt_count == NSUIntegerMax) {
        _mt_count = [self transformedCountOfArray:_mt_array userInfo:_mt_userInfo];
    }
    return _mt_count;
}

- (id)objectAtIndex:(NSUInteger)index
{
    id proxy = [_mt_cache pointerAtIndex:index];
    if (proxy == nil) {
        proxy = [self transformedObjectAtIndex:index ofArray:_mt_array userInfo:_mt_userInfo];
        [_mt_cache insertPointer:(void *)proxy atIndex:index];
    }
    return proxy;
}

@end
