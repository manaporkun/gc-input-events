#import <Foundation/Foundation.h>
#import <GameController/GameController.h>

@interface GCMouseEvents : NSObject
@end

#ifdef __cplusplus
extern "C" {
#endif

void initializeMouse(void);
void registerMouseMovedCallback(void(*callback)(float x, float y));
void registerMouseButtonCallback(void(*callback)(int button, BOOL pressed));
void registerMouseScrollCallback(void(*callback)(float x, float y));

#ifdef __cplusplus
}
#endif
