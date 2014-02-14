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
}

@end

@implementation MTArray

- (instancetype)initWithArray:(NSArray *)array entity:(NSEntityDescription *)entity
{
    self = [super init];
    if (self) {
        _entity = entity;
        _mt_array = [array copy];
        _mt_cache = [NSPointerArray strongObjectsPointerArray];
        [_mt_cache setCount:[_mt_array count]];
    }
    return self;
}

#pragma mark NSArray

- (NSUInteger)count
{
    return [_mt_array count];
}

- (id)objectAtIndex:(NSUInteger)index
{
    id proxy = [_mt_cache pointerAtIndex:index];
    if (proxy == nil) {
        id value = [_mt_array objectAtIndex:index];
        proxy = [[MTObject alloc] initWithObject:value entity:self.entity];
        [_mt_cache insertPointer:(void *)proxy atIndex:index];
    }
    return proxy;
}

@end
