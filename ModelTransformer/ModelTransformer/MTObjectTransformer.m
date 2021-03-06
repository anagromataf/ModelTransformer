//
//  MTObjectTransformer.m
//  ModelTransformer
//
//  Created by Tobias Kräntzer on 13.02.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import "ModelTransformer.h"

#import "MTObjectTransformer.h"

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

@interface MTObjectTransformer () {
    id _mt_object;
    NSDictionary *_mt_userInfo;
    NSMapTable *_mt_cache;
}
@end

@implementation MTObjectTransformer

#pragma mark Object From File

+ (instancetype)objectWithContentsOfJSONFile:(NSURL *)fileURL
                            formatVersionKey:(NSString *)formatVersionKey
                               rootObjectKey:(NSString *)rootObjectKey
                                      entity:(NSEntityDescription *)entity
                                    userInfo:(NSDictionary *)userInfo
                                       error:(NSError **)error
{
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    if (data == nil) {
        if (error) {
            *error = [NSError errorWithDomain:MTErrorDomain code:MTNoDataErrorCode userInfo:nil];
        }
        return nil;
    }
    
    NSDictionary *values = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
    if (values) {
        NSString *formatVersion = formatVersionKey ? [values valueForKey:formatVersionKey] : nil;
        NSDictionary *rootObject = rootObjectKey ? [values valueForKey:rootObjectKey] : values;
        if ([rootObject isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *_userInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
            if (formatVersion) {
                [_userInfo setValue:formatVersion forKey:MTFormatVersionKey];
            }
            return [[self alloc] initWithObject:rootObject entity:entity userInfo:_userInfo];
        }
    }
    return nil;
}

#pragma mark Object Value Key Paths

+ (NSDictionary *)objectValueKeyPathByPropertyName
{
    return @{};
}

#pragma mark Life-cycle

- (id)initWithObject:(id)object entity:(NSEntityDescription *)entity
{
    return [self initWithObject:object entity:entity userInfo:nil];
}

- (id)initWithObject:(id)object entity:(NSEntityDescription *)entity userInfo:(NSDictionary *)userInfo
{
    self = [super init];
    if (self) {
        _entity = entity;
        _mt_object = object;
        _mt_userInfo = userInfo;
        _mt_cache = [NSMapTable strongToStrongObjectsMapTable];
    }
    return self;
}

#pragma mark Transform Value

- (id)transformedValueForAttribute:(NSAttributeDescription *)attributeDescription ofObject:(id)object userInfo:(NSDictionary *)userInfo
{
    NSString *keyPath = [[[self class] objectValueKeyPathByPropertyName] objectForKey:attributeDescription.name];
    if (keyPath) {
        return [object valueForKeyPath:keyPath];
    } else {
        return [object valueForKey:attributeDescription.name];
    }
}

- (id)transformedValueForRelationship:(NSRelationshipDescription *)relationshipDescription ofObject:(id)object userInfo:(NSDictionary *)userInfo
{
    return [self transformedValueForRelationship:relationshipDescription ofObject:object userInfo:userInfo class:[MTObjectTransformer class]];
}

- (id)transformedValueForRelationship:(NSRelationshipDescription *)relationshipDescription ofObject:(id)object userInfo:(NSDictionary *)userInfo class:(Class)_class
{
    NSParameterAssert(_class);
    
    id value = [object valueForKey:relationshipDescription.name];
    if (value == nil) {
        return nil;
    }
    if (relationshipDescription.isToMany) {
        return [[MTArrayTransformer alloc] initWithArray:value entity:relationshipDescription.destinationEntity userInfo:userInfo class:_class];
    } else {
        return [[_class alloc] initWithObject:value entity:relationshipDescription.destinationEntity userInfo:userInfo];
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
                proxy = [self transformedValueForRelationship:relationship ofObject:_mt_object userInfo:_mt_userInfo];
            } else {
                NSAttributeDescription *attribute = (NSAttributeDescription *)property;
                proxy = [self transformedValueForAttribute:attribute ofObject:_mt_object userInfo:_mt_userInfo];
            }
            
            if (proxy) {
                [_mt_cache setObject:proxy forKey:key];
            } else {
                [_mt_cache setObject:[MTNull null] forKey:key];
            }
        }
        return (proxy == [MTNull null]) ? nil : proxy;
    } else {
        return [super valueForKey:key];
    }
}

@end
