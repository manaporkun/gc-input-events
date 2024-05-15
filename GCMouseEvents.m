#import "GCMouseEvents.h"

static void (*mouseMovedCallback)(float x, float y) = NULL;
static void (*mouseButtonCallback)(int button, BOOL pressed) = NULL;
static void (*mouseScrollCallback)(float x, float y) = NULL;

@implementation GCMouseEvents

+(void) initializeMouse {
    NSArray *connectedControllers = GCMouse.mice;
    
    NSLog(@"Total connected controllers: %lu", (unsigned long)connectedControllers.count);

    for (GCController *controller in connectedControllers) {
        NSLog(@"Detected controller: %@", controller.vendorName);
        if ([controller isKindOfClass:[GCMouse class]]) {
            GCMouse *mouse = (GCMouse *)controller;
            subscribeMouseEvents(mouse);
            NSLog(@"Mouse connected: %@", mouse.vendorName);
        }
    }

    [[NSNotificationCenter defaultCenter] addObserver:[GCMouseEvents class]
                                             selector:@selector(mouseDidConnect:)
                                                 name:GCMouseDidConnectNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:[GCMouseEvents class]
                                             selector:@selector(mouseDidDisconnect:)
                                                 name:GCMouseDidDisconnectNotification
                                               object:nil];
}

+ (void)mouseDidConnect:(NSNotification *)notification {
    GCMouse *mouse = notification.object;
    subscribeMouseEvents(mouse);
}

+ (void)mouseDidDisconnect:(NSNotification *)notification {
    GCMouse *mouse = notification.object;
    unsubscribeMouseEvents(mouse);
}

void subscribeMouseEvents(GCMouse *mouse) {
    NSLog(@"Subscribe");
    
    mouse.mouseInput.leftButton.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
        if (mouseButtonCallback) {
            mouseButtonCallback(0, pressed);
        }
    };
    
    mouse.mouseInput.rightButton.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
        if (mouseButtonCallback) {
            mouseButtonCallback(1, pressed);
        }
    };

    mouse.mouseInput.middleButton.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
        if (mouseButtonCallback) {
            mouseButtonCallback(2, pressed);
        }
    };
    
    mouse.mouseInput.mouseMovedHandler = ^(GCMouseInput *mouseInput, float deltaX, float deltaY) {
        if (mouseMovedCallback) {
            mouseMovedCallback(deltaX, deltaY);
        }
    };
    
    mouse.mouseInput.scroll.valueChangedHandler = ^(GCControllerDirectionPad * _Nonnull dpad, float xValue, float yValue){
        if(mouseScrollCallback){
            mouseScrollCallback(xValue, yValue);
        }
    };
}

void unsubscribeMouseEvents(GCMouse *mouse){
    mouse.mouseInput.leftButton.valueChangedHandler = nil;
    mouse.mouseInput.rightButton.valueChangedHandler = nil;
    mouse.mouseInput.middleButton.valueChangedHandler = nil;
    mouse.mouseInput.mouseMovedHandler = nil;
    mouse.mouseInput.scroll.valueChangedHandler = nil;
}

@end

#ifdef __cplusplus
extern "C" {
#endif

void initializeMouse(void) {
    [GCMouseEvents initializeMouse];
}

void mouseDidConnect(NSNotification *notification) {
    [GCMouseEvents mouseDidConnect:notification];
}

void mouseDidDisconnect(NSNotification *notification) {
    [GCMouseEvents mouseDidDisconnect:notification];
}

void registerMouseMovedCallback(void(*callback)(float x, float y)) {
    mouseMovedCallback = callback;
}

void registerMouseButtonCallback(void(*callback)(int button, BOOL pressed)) {
    mouseButtonCallback = callback;
}

void registerMouseScrollCallback(void(*callback)(float x, float y)) {
    mouseScrollCallback = callback;
}

#ifdef __cplusplus
}
#endif
