//
//  MTArray.m
//  ModelTransformer
//
//  Created by Tobias Kräntzer on 13.02.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "MTArray.h"

@implementation MTArray

- (instancetype)initWithArray:(NSArray *)array entity:(NSEntityDescription *)entity
{
    self = [super  initWithArray:array];
    if (self) {
        _entity = entity;
    }
    return self;
}

@end
