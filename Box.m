#import "Box.h"

@implementation Box


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initMakeMeABox:(UIImage*)borgImage{
    
    CGRect frame = CGRectMake(0.0, 0.0, 20.0, 20.0);
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _isDestroyed=NO;
        
        _deltaX = 0.2;
        _deltaY = 0.5;
    }
    
    
    UIImageView *_borgCubeImageView = [[UIImageView alloc]initWithImage:borgImage];
    _borgCubeImageView.frame = CGRectMake(0, 0, 20,20);
    _borgCubeImageView.center = CGPointMake(10,10);
    _borgCubeImageView.backgroundColor = [UIColor clearColor];
    // setting content mode will keep the aspect ratio of you image
    //_borgCubeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_borgCubeImageView];
    
    return self;
}


-(id)initMakeMeABox{
    
    CGRect frame = CGRectMake(0.0, 0.0, 10.0, 10.0);
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blueColor];
        _isDestroyed=NO;
        
        _deltaX = 0.2;
        _deltaY = 0.5;
    }
    
    return self;
}


-(void)markForDestruction{
    _isDestroyed=YES;
}

@end
