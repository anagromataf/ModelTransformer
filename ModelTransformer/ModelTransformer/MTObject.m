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

- (id)transformedValueForAttribute:(NSAttributeDescription *)attributeDescription ofObject:(id)object
{
    return [object valueForKey:attributeDescription.name];
}

- (id)transformedValueForRelationship:(NSRelationshipDescription *)relationshipDescription ofObject:(id)object
{
    id value = [object valueForKey:relationshipDescription.name];
    if (value == nil) {
        return nil;
    }
    if (relationshipDescription.isToMany) {
        return [[MTArray alloc] initWithArray:value entity:relationshipDescription.destinationEntity];
    } else {
        return [[MTObject alloc] initWithObject:value entity:relationshipDescription.destinationEntity];
    }
}

#pragma mark KVC

- (id)valueForKey:(NSString *)key
{
    NSPropertyDescription *property = [self.entity.propertiesByName objectForKey:key];
    
    if (property) {
        id proxy = [_mt_cache objectForKey:key];
        if (proxy == nil) {
            
            if ([property isKindOfClass:[NSRelationshipDescription class]]) {
                NSRelationshipDescription *relationship = (NSRelationshipDescription *)property;
                proxy = [self transformedValueForRelationship:relationship ofObject:_mt_object];
            } else {
                NSAttributeDescription *attribute = (NSAttributeDescription *)property;
                proxy = [self transformedValueForAttribute:attribute ofObject:_mt_object];
            }
            
            if (proxy) {
                [_mt_cache setObject:proxy forKey:key];
            } else {
                [_mt_cache setObject:[MTNull null] forKey:key];
            }
        }
        return proxy;
    } else {
        return [super valueForKey:key];
    }
}

@end
