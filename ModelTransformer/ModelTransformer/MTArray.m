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

#pragma mark Life-cycle

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

#pragma mark Transform Object

- (id)transformObject:(id)object
{
    return [[MTObject alloc] initWithObject:object entity:self.entity];
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
        id object = [_mt_array objectAtIndex:index];
        proxy = [self transformObject:object];
        [_mt_cache insertPointer:(void *)proxy atIndex:index];
    }
    return proxy;
}



@end
