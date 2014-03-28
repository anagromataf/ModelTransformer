# Model Transformer

[![Version](http://cocoapod-badges.herokuapp.com/v/ResourceMapper/badge.png)](http://cocoadocs.org/docsets/ResourceMapper)
[![Platform](http://cocoapod-badges.herokuapp.com/p/ResourceMapper/badge.png)](http://cocoadocs.org/docsets/ResourceMapper)

## Requirements

The aim of ModelTransformer is to transform a model e.g., provided by an API to a CoreData model used by the application. For this the transformer has the knowledge of the managed object model of the application. Thus this transformer can only be used in conjunction with an `NSManagedObjectModel`.

## Installation

ModelTransformer is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "ModelTransformer"

## Usage

`MTObject Transformer` and `MTArrayTransformer` are base classes for custom model transformation. Applications using this transformer must therefore subclass these base classes to provide their own logic. 

The example below transforms all attributes of type NSDateAttributeType using a date formatter to NSDate obejcts and the attribute with the name 'url' to an NSURL object.

	@implementation MyObjectTransformer
	
	- (id)transformedValueForAttribute:(NSAttributeDescription *)attributeDescription
	                          ofObject:(id)object 
	                          userInfo:(NSDictionary *)userInfo
    {
    	if (attributeDescription.attributeType == NSDateAttributeType) {
        	NSString *dateString = [object valueForKey:attributeDescription.name];
        	if (dateString) {
            	return [[[self class] dateFormatter] dateFromString:dateString];
        	}
        	return nil;
    	} else if ([attributeDescription.name isEqualToString:@"url"]) {
        	NSString *urlString = [object valueForKey:@"url"];
        	if (urlString) {
            	return [NSURL URLWithString:urlString];
        	}
        	return nil;
    	} else {
        	return [super transformedValueForAttribute:attributeDescription
                                          	   ofObject:object
                                              userInfo:userInfo];
        }
    }
	
	@end

In general the transformation is done with the following methods, that can be overwritten in subclasses. All this methods have a fallback that _forward_ the call the the underlying object.

### Object Transformer

	@interface MTObjectTransformer : NSObject

	
	- (id)transformedValueForAttribute:(NSAttributeDescription *)attributeDescription
	                          ofObject:(id)object
	                          userInfo:(NSDictionary *)userInfo;
	
	- (id)transformedValueForRelationship:(NSRelationshipDescription *)relationshipDescription  
	                             ofObject:(id)object
	                             userInfo:(NSDictionary *)userInfo
	                                class:(Class)_class;
	
	- (id)transformedValueForRelationship:(NSRelationshipDescription *)relationshipDescription  
	                             ofObject:(id)object
	                             userInfo:(NSDictionary *)userInfo;

	@end

### Array Transformer

	@interface MTArrayTransformer : NSArray
	
	- (id)transformedObjectAtIndex:(NSUInteger)index
	                       ofArray:(NSArray *)array
	                      userInfo:(NSDictionary *)userInfo;
	                      
	- (NSUInteger)transformedCountOfArray:(NSArray *)array
	                             userInfo:(NSDictionary *)userInfo;

	@end



## Author

Tobias Kräntzer, info@tobias-kraentzer.de

## License

Copyright (c) 2014, Tobais Kräntzer
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.