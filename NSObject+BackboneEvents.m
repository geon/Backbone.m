
#import "NSObject+BackboneEvents.h"
#import <objc/runtime.h>


@implementation BackboneEventEmitterProxy

- (void)dealloc {

	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


@implementation NSObject (BackboneEvents)

- (BackboneEventEmitterProxy *)backboneEventEmitterProxy {

	BackboneEventEmitterProxy *proxy =
	objc_getAssociatedObject(self, @selector(backboneEventEmitterProxy));

	if (!proxy) {

		proxy = [BackboneEventEmitterProxy new];
		objc_setAssociatedObject(self,
								 @selector(backboneEventEmitterProxy),
								 proxy,
								 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}

	return proxy;
}


- (void)onEventNamed:(NSString *)eventName
		   inContext:(__weak id)context
	 handleEventWith:(BackboneEventHandler)eventHandler {

	[NSNotificationCenter.defaultCenter
	 addObserverForName:eventName
	 object:self.backboneEventEmitterProxy
	 queue:nil
	 usingBlock:^(NSNotification *note) {

		 id event = note.userInfo[@"event"];
		 eventHandler(context, event);
	 }];
}


- (void)triggerEventNamed:(NSString *)eventName
				withEvent:(id)event {

	[NSNotificationCenter.defaultCenter
	 postNotificationName:eventName
	 object:self.backboneEventEmitterProxy
	 userInfo:(event ? @{@"event": event} : nil)];
}

@end
