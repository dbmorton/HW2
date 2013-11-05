#import <UIKit/UIKit.h>

@interface Box : UIView{
    
}
@property float deltaX;
@property float deltaY;
@property BOOL isDestroyed;

-(id)initMakeMeABox:(UIImage*)borgImage;

-(id)initMakeMeABox;

@end
