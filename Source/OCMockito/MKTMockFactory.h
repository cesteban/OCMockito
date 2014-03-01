//
//  MKTMockFactory.h
//
//  Created by Rafael López Diez
//

#import <Foundation/Foundation.h>

@class MKTObjectMock;
@class MKTClassObjectMock;
@class MKTProtocolMock;
@class MKTObjectAndProtocolMock;

@interface MKTMockFactory : NSObject

- (MKTObjectMock *)mockForClass:(Class)aClass;
- (MKTClassObjectMock *)mockForClassObject:(Class)aClass;
- (MKTProtocolMock *)mockForProtocol:(Protocol *)aProtocol;
- (MKTObjectAndProtocolMock *)mockForClass:(Class)aClass protocol:(Protocol *)protocol;

@end
