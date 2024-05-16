#import <Foundation/Foundation.h>
#import <GameController/GameController.h>

@interface GCKeyboardEvents : NSObject
@end

#ifdef __cplusplus
extern "C" {
#endif

void initializeKeyboard(void);
void registerKeyboardButtonPressedCallback(void(*callback)(long keyCode, bool pressed));

#ifdef __cplusplus
}
#endif
