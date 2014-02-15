//
//  MTObject.m
//  ModelTransformer
//
//  Created by Tobias Kräntzer on 13.02.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "MTArray.h"

#import "MTObject.h"

@interface MTNull : NSObject
+ (instancetype)null;
@end

@implementation MTNull
+ (instancetype)null
{
    static dispatch_once_t onceToken;
    static  MTNull *null;
    dispatch_once(&onceToken, ^{
        null = [[MTNull alloc] init];
    });
    return null;
}
@end

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

- (id)transformValue:(id)value usingPropertyDescription:(NSPropertyDescription *)property
{
    id proxy = nil;
    if ([property isKindOfClass:[NSRelationshipDescription class]]) {
        NSRelationshipDescription *relationship = (NSRelationshipDescription *)property;
        proxy = [self transformRelationshipValue:value usingRelationshipDescription:relationship];
    } else {
        NSAttributeDescription *attribute = (NSAttributeDescription *)property;
        proxy = [self transformAttributeValue:value usingAttributeDescription:attribute];
    }
    return proxy;
}

- (id)transformAttributeValue:(id)value usingAttributeDescription:(NSAttributeDescription *)attribute
{
    return value;
}

- (id)transformRelationshipValue:(id)value usingRelationshipDescription:(NSRelationshipDescription *)relationship
{
    id proxy = nil;
    if (relationship.isToMany) {
        proxy = [[MTArray alloc] initWithArray:value entity:relationship.destinationEntity];
    } else {
        proxy = [[MTObject alloc] initWithObject:value entity:relationship.destinationEntity];
    }
    return proxy;
}

#pragma mark KVC

- (id)valueForKey:(NSString *)key
{
    NSPropertyDescription *property = [self.entity.propertiesByName objectForKey:key];
    
    if (property) {
        id proxy = [_mt_cache objectForKey:key];
        if (proxy == nil) {
            id value = [_mt_object valueForKey:key];
            if (value) {
                proxy = [self transformValue:value usingPropertyDescription:property];
            } else {
                proxy = [MTNull null];
            }
            [_mt_cache setObject:proxy forKey:key];
        }
        if (proxy == [MTNull null]) {
            return nil;
        } else {
            return proxy;
        }
    } else {
        return [super valueForKey:key];
    }
}

@end
