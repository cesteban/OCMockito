//
//  MKTMockFactory.m
//
//  Created by Rafael López Diez
//

#import "MKTMockFactory.h"

#import "MKTObjectMock.h"
#import "MKTClassObjectMock.h"
#import "MKTProtocolMock.h"
#import "MKTObjectAndProtocolMock.h"

#include <objc/runtime.h>

@implementation MKTMockFactory

- (MKTObjectMock *)mockForClass:(Class)aClass
{
	Class MockClass = [self registeredSubclassOf:[MKTObjectMock class] withIvarsFromClass:aClass];

	return [[MockClass alloc] initWithClass:aClass];
}

- (MKTClassObjectMock *)mockForClassObject:(Class)aClass
{
	Class MockClass = [self registeredSubclassOf:[MKTClassObjectMock class] withIvarsFromClass:aClass];

	return [[MockClass alloc] initWithClass:aClass];
}

- (MKTProtocolMock *)mockForProtocol:(Protocol *)aProtocol
{
	return [MKTProtocolMock mockForProtocol:aProtocol];
}

- (MKTObjectAndProtocolMock *)mockForClass:(Class)aClass protocol:(Protocol *)protocol
{
	Class MockClass = [self registeredSubclassOf:[MKTObjectAndProtocolMock class] withIvarsFromClass:aClass];

	return [[MockClass alloc] initWithClass:aClass protocol:protocol];
}

#pragma mark - Subclass composing

- (Class)registeredSubclassOf:(Class)superclass withIvarsFromClass:(Class)classToTakeIvarsFrom
{
	const char *className = [[self classNameForSubclassOf:superclass withIvarsFromClass:classToTakeIvarsFrom] UTF8String];

	Class MockClass = objc_getClass(className);
	if (!MockClass)
	{
		MockClass = objc_allocateClassPair([superclass class], className, 0);
		[self addIvarsFromClass:classToTakeIvarsFrom toClass:MockClass];
		objc_registerClassPair(MockClass);
	}
	return MockClass;
}

- (NSString *)classNameForSubclassOf:(Class)superclass withIvarsFromClass:(Class)classToTakeIvarsFrom
{
	return [NSString stringWithFormat:@"%@_%@", NSStringFromClass(superclass), NSStringFromClass(classToTakeIvarsFrom)];
}

- (void)addIvarsFromClass:(Class)sourceClass toClass:(Class)targetClass
{
	unsigned int ivarCount;
    Ivar* ivars = class_copyIvarList(sourceClass, &ivarCount);
    for (NSUInteger ivarIndex = 0; ivarIndex < ivarCount; ++ivarIndex)
    {
		Ivar ivar = ivars[ivarIndex];
		[self addIvar:ivar toClass:targetClass];
    }
    free(ivars);
}

- (void)addIvar:(Ivar)ivar toClass:(Class)targetClass
{
	const char *ivarTypeEncoding = ivar_getTypeEncoding(ivar);
	if (strcmp(&ivarTypeEncoding[0], "b")) return;

	const char *ivarName = ivar_getName(ivar);

	NSUInteger ivarSize = 0;
	NSUInteger ivarAlignment = 0;
	NSGetSizeAndAlignment(ivarTypeEncoding, &ivarSize, &ivarAlignment);

	class_addIvar(targetClass, ivarName, ivarSize, (uint8_t)ivarAlignment, ivarTypeEncoding);
}

@end
