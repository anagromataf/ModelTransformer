//
//  MTArray.m
//  ModelTransformer
//
//  Created by Tobias Kräntzer on 13.02.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "MTObject.h"

#import "MTArray.h"

@interface MTArray () {
    NSArray *_mt_array;
    NSPointerArray *_mt_cache;
    Class _mt_class;
    NSDictionary *_mt_userInfo;
}

@end

@implementation MTArray

#pragma mark Life-cycle

- (instancetype)initWithArray:(NSArray *)array
                       entity:(NSEntityDescription *)entity
                     userInfo:(NSDictionary *)userInfo
{
    return [self initWithArray:array entity:entity userInfo:userInfo class:[MTObject class]];
}

- (instancetype)initWithArray:(NSArray *)array entity:(NSEntityDescription *)entity userInfo:(NSDictionary *)userInfo class:(Class)_class
{
    self = [super init];
    if (self) {
        _entity = entity;
        _mt_class = _class;
        _mt_userInfo = userInfo;
        _mt_array = [array copy];
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
    return [self transformedCountOfArray:_mt_array userInfo:_mt_userInfo];
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
