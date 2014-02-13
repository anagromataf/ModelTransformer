//
//  MTObject.m
//  ModelTransformer
//
//  Created by Tobias Kräntzer on 13.02.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "MTObject.h"

@interface MTObject ()
@property (nonatomic, readonly) id underlyingObject;
@end

@implementation MTObject

- (id)initWithObject:(id)object entity:(NSEntityDescription *)entity
{
    self = [super init];
    if (self) {
        _entity = entity;
        _underlyingObject = object;
    }
    return self;
}

@end
