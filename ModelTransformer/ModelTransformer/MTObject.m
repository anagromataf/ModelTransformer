//
//  MTObject.m
//  ModelTransformer
//
//  Created by Tobias Kräntzer on 13.02.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "MTArray.h"

#import "MTObject.h"

@interface MTObject () {
    id _mt_object;
    NSMapTable *_mt_cache;
}
@end

@implementation MTObject

#pragma mark Life-cycle

- (id)initWithObject:(id)object entity:(NSEntityDescription *)entity
{
    self = [super init];
    if (self) {
        _entity = entity;
        _mt_object = object;
        _mt_cache = [NSMapTable strongToStrongObjectsMapTable];
    }
    return self;
}

#pragma mark Transform Value

- (id)transformValue:(id)value forProperty:(NSPropertyDescription *)property
{
    id proxy = nil;
    if ([property isKindOfClass:[NSRelationshipDescription class]]) {
        NSRelationshipDescription *relationship = (NSRelationshipDescription *)property;
        if (relationship.isToMany) {
            proxy = [[MTArray alloc] initWithArray:value entity:relationship.destinationEntity];
        } else {
            proxy = [[MTObject alloc] initWithObject:value entity:relationship.destinationEntity];
        }
    } else {
        proxy = value;
    }
    return proxy;
}

#pragma mark KVC

- (id)valueForKey:(NSString *)key
{
    NSPropertyDescription *property = [self.entity.propertiesByName objectForKey:key];
    
    if (property) {
        id proxy = [_mt_cache objectForKey:key];
        if ([proxy isKindOfClass:[NSNull class]]) {
            return nil;
        }
        if (proxy == nil) {
            id value = [_mt_object valueForKey:key];
            if (value) {
                proxy = [self transformValue:value forProperty:property];
            } else {
                proxy = [NSNull null];
            }
            [_mt_cache setObject:proxy forKey:key];
        }
        return proxy;
    } else {
        return [super valueForKey:key];
    }
}

@end
