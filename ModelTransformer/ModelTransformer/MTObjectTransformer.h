//
//  MTObjectTransformer.h
//  ModelTransformer
//
//  Created by Tobias Kräntzer on 13.02.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MTObjectTransformer : NSObject

#pragma mark Object From JSON-File
+ (instancetype)objectWithContentsOfJSONFile:(NSURL *)fileURL
                            formatVersionKey:(NSString *)formatVersionKey
                               rootObjectKey:(NSString *)rootObjectKey
                                      entity:(NSEntityDescription *)entity
                                    userInfo:(NSDictionary *)userInfo
                                       error:(NSError **)error;

#pragma mark Object Value Key Paths
+ (NSDictionary *)objectValueKeyPathByPropertyName;

#pragma mark Life-cycle
- (id)initWithObject:(id)object entity:(NSEntityDescription *)entity userInfo:(NSDictionary *)userInfo;

#pragma mark Entity Description
@property (nonatomic, readonly) NSEntityDescription *entity;

#pragma mark Transform Value - Overwrite in Subclass
- (id)transformedValueForAttribute:(NSAttributeDescription *)attributeDescription ofObject:(id)object userInfo:(NSDictionary *)userInfo;
- (id)transformedValueForRelationship:(NSRelationshipDescription *)relationshipDescription ofObject:(id)object userInfo:(NSDictionary *)userInfo class:(Class)_class;
- (id)transformedValueForRelationship:(NSRelationshipDescription *)relationshipDescription ofObject:(id)object userInfo:(NSDictionary *)userInfo;

@end
