//
//  MTObject.h
//  ModelTransformer
//
//  Created by Tobias Kräntzer on 13.02.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MTObject : NSObject

#pragma mark Life-cycle
- (id)initWithObject:(id)object entity:(NSEntityDescription *)entity;

#pragma mark Entity Description
@property (nonatomic, readonly) NSEntityDescription *entity;

#pragma mark Transform Value - Overwrite in Subclass
- (id)transformedValueForAttribute:(NSAttributeDescription *)attributeDescription ofObject:(id)object;
- (id)transformedValueForRelationship:(NSRelationshipDescription *)relationshipDescription ofObject:(id)object;

@end
