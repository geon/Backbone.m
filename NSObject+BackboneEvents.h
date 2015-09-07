
#import <Foundation/Foundation.h>


@interface BackboneEventEmitterProxy : NSObject

@end


typedef void(^BackboneEventHandler)(id self, id event);


@protocol BackboneEventsProtocol <NSObject>

- (void)onEventNamed:(NSString *)eventName
		   inContext:(__weak id)context
	 handleEventWith:(BackboneEventHandler)eventHandler;


- (void)triggerEventNamed:(NSString *)eventName
				withEvent:(id)event;

@end


@interface NSObject (BackboneEvents) <BackboneEventsProtocol>

@end
