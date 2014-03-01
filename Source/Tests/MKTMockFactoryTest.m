//
//  MKTMockFactoryTest.m
//
//  Created by Rafael López Diez
//

// System under test
#import "MKTMockFactory.h"

// Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#if TARGET_OS_MAC
#import <OCHamcrest/OCHamcrest.h>
#else
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#endif

// Collaborators
#pragma mark - IvarHolder class

@class IvarSetter;

@interface IvarHolder : NSObject
@end

@implementation IvarHolder
{
	@package
	IvarSetter *_ivarSetter;
}

@end

#pragma mark - IvarSetter class

@interface IvarSetter : NSObject

- (void)setIvarOfObject:(IvarHolder *)ivarHolderObject;

@end

@implementation IvarSetter

- (void)setIvarOfObject:(IvarHolder *)ivarHolderObject
{
	ivarHolderObject->_ivarSetter = self;
}

@end

#pragma mark - MKTMockFactoryTest class

@interface MKTMockFactoryTest : SenTestCase
@end

@implementation MKTMockFactoryTest
{
    MKTMockFactory *sut;
}

- (void)setUp
{
	sut = [[MKTMockFactory alloc] init];
}

- (void)testMockFactory_copiesIvarsFromMockedClass
{
	// given
	IvarSetter *ivarSetter = [[IvarSetter alloc] init];
	IvarHolder *mockIvarHolderObject = (IvarHolder *)[sut mockForClass:[IvarHolder class]];

	// when
	[ivarSetter setIvarOfObject:mockIvarHolderObject];

	// then
	assertThat(mockIvarHolderObject->_ivarSetter, equalTo(ivarSetter));
}

@end
