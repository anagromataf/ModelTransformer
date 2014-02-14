//
//  ModelTransformerTests.m
//  ModelTransformerTests
//
//  Created by Tobias Kräntzer on 13.02.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>

#import "ModelTransformer.h"

@interface ModelTransformerTests : XCTestCase
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@end

@implementation ModelTransformerTests

- (void)setUp
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:@[bundle]];
}

#pragma mark Tests

- (void)testAttributeProperties
{
    NSDictionary *note = @{@"text": @"FOO BAR"};
    NSEntityDescription *entity =[self entityWithName:@"Note"];
    
    MTObject *object = [[MTObject alloc] initWithObject:note entity:entity];
    XCTAssertNotNil(object);
    
    XCTAssertEqualObjects(object.entity, entity);
    XCTAssertNotEqual(note, object);
    
    id text = [object valueForKey:@"text"];
    XCTAssertTrue([text isKindOfClass:[NSString class]]);
}

- (void)testToOneRelationshipProperties
{
    NSDictionary *values = @{@"owner": @{@"name":@"Paul"}};
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    
    MTObject *object = [[MTObject alloc] initWithObject:values entity:entity];
    XCTAssertNotNil(object);
    
    XCTAssertEqualObjects(object.entity, entity);
    XCTAssertNotEqual(values, object);
    
    MTObject *person = [object valueForKey:@"owner"];
    XCTAssertNotNil(person);
    XCTAssertTrue([person isKindOfClass:[MTObject class]]);
    
    XCTAssertEqualObjects(person.entity, [self entityWithName:@"Person"]);
    XCTAssertEqualObjects([person valueForKey:@"name"], @"Paul");
}

- (void)testToManyRelationshipProperties
{
    NSDictionary *values = @{@"tags": @[@{@"name":@"A"}, @{@"name":@"B"}, @{@"name":@"C"}]};
    NSEntityDescription *entity = [self entityWithName:@"Entity"];
    
    MTObject *object = [[MTObject alloc] initWithObject:values entity:entity];
    XCTAssertNotNil(object);
    
    XCTAssertEqualObjects(object.entity, entity);
    XCTAssertNotEqual(values, object);
    
    MTArray *tags = [object valueForKey:@"tags"];
    XCTAssertNotNil(tags);
    XCTAssertTrue([tags isKindOfClass:[MTArray class]]);
    
    XCTAssertEqualObjects(tags.entity, [self entityWithName:@"Tag"]);
    
    XCTAssertEqual([tags count], (NSUInteger)3);
    
    MTObject *tag = [tags objectAtIndex:0];
    XCTAssertNotNil(tag);
    XCTAssertEqualObjects(tag.entity, [self entityWithName:@"Tag"]);
    XCTAssertTrue([tag isKindOfClass:[MTObject class]]);
}

#pragma mark Helpers

- (NSEntityDescription *)entityWithName:(NSString *)name
{
    return [[self.managedObjectModel entitiesByName] valueForKey:name];
}

- (NSPropertyDescription *)propertyWithName:(NSString *)propertyName ofEntity:(id)entity
{
    if ([entity isKindOfClass:[NSString class]]) {
        entity = [self entityWithName:entity];
    }
    return [[(NSEntityDescription *)entity propertiesByName] valueForKey:propertyName];
}

@end
