#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(UIColor *)randomColor;
+(int)randomNumberBetweenZeroAnd:(int)maxNumber;
+(UILabel * )makeLabel:(NSString *)title :(int)size;

+(UILabel *)makeTitleLabel:(NSString *)text withName:(NSString *)name fontSize:(int)size y:(float)y bgColor:(UIColor *)bgColor textColor:(UIColor *)tColor screenWidth:(float)sSize;

double randomFloat();

@end
