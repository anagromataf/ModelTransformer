//
//  XMLModelTransformerTests.m
//  ModelTransformer
//
//  Created by Tobias Kräntzer on 01.04.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>
#include <libxml/xmlmemory.h>
#include <libxml/parser.h>

#import "ModelTransformer.h"

@interface XMLModelTransformerTests : XCTestCase
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@end

@implementation XMLModelTransformerTests

- (void)setUp
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:@[bundle]];
}

#pragma mark Tests

- (void)test
{
    NSString *fileName = [[NSBundle bundleForClass:[self class]] pathForResource:@"test" ofType:@"xml"];
    
    xmlDocPtr doc;
	xmlNodePtr cur;
    
	doc = xmlParseFile([fileName UTF8String]);
	cur = xmlDocGetRootElement(doc);
    
    
    if (doc) {
        xmlFreeDoc(doc);
    }
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
