#import "GCKeyboardEvents.h"

static void (*keyboardButtonPressedCallback)(long keyCode, bool pressed) = NULL;

@implementation GCKeyboardEvents

+(void) initializeKeyboard {
    GCKeyboard *keyboard = GCKeyboard.coalescedKeyboard;
    if (keyboard) {
        subscribeKeyboardEvents(keyboard);
    } else {
        NSLog(@"No coalesced keyboard available.");
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:[GCKeyboardEvents class]
                                             selector:@selector(handleKeyboardConnected:)
                                                 name:GCKeyboardDidConnectNotification
                                                object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:[GCKeyboardEvents class]
                                             selector:@selector(handleKeyboardDisconnected:)
                                                 name:GCKeyboardDidDisconnectNotification
                                               object:nil];
}

+ (void)handleKeyboardConnected:(NSNotification *)notification {
    GCKeyboard *keyboard = notification.object;
    subscribeKeyboardEvents(keyboard);
}

+ (void)handleKeyboardDisconnected:(NSNotification *)notification {
    GCKeyboard *keyboard = notification.object;
    unsubscribeKeyboardEvents(keyboard);
}

void subscribeKeyboardEvents (GCKeyboard *keyboard){
    keyboard.keyboardInput.keyChangedHandler = ^(GCKeyboardInput *keyboardInput, GCControllerButtonInput *key, GCKeyCode keyCode, BOOL pressed) {
        if(keyboardButtonPressedCallback){
            keyboardButtonPressedCallback((long)keyCode, pressed);
        }
    };
}

void unsubscribeKeyboardEvents (GCKeyboard *keyboard){
    keyboard.keyboardInput.keyChangedHandler = nil;
}

@end


#ifdef __cplusplus
extern "C" {
#endif
    
void initializeKeyboard(void) {
    [GCKeyboardEvents initializeKeyboard];
}
    
void registerKeyboardButtonPressedCallback(void(*callback)(long keyCode, bool pressed)) {        keyboardButtonPressedCallback = callback;
}

#ifdef __cplusplus
}
#endif
