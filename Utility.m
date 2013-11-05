

#import "Utility.h"

@implementation Utility

// Gives you a random color
+(UIColor *)randomColor{
    
    float red = [self randomNumberBetweenZeroAnd:100] * 0.01;
    float green = [self randomNumberBetweenZeroAnd:100] * 0.01;
    float blue = [self randomNumberBetweenZeroAnd:100] * 0.01;
    float alpha = [self randomNumberBetweenZeroAnd:100] * 0.01;
    
    UIColor * tempColor =  [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    return tempColor;
}

// Gives you a number from 0 to maxnumber and returns an int
+(int)randomNumberBetweenZeroAnd:(int)maxNumber{
    int randomNum = arc4random() % maxNumber;
    return randomNum;
}

// Makes a label with your title
+(UILabel * )makeLabel:(NSString *)title :(int)size{
    
    UILabel * temp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 50)];
    temp.text = title;
    temp.font =  [UIFont fontWithName:@"HoeflerText-Black" size:size];
    temp.textColor = [UIColor blueColor];
    
    return temp;
}

// C function
double randomFloat()
{
    return (double)rand() / (double)RAND_MAX ;
}

+(UILabel *)makeTitleLabel:(NSString *)text withName:(NSString *)name fontSize:(int)size y:(float)y bgColor:(UIColor *)bgColor textColor:(UIColor *)tColor screenWidth:(float)sSize{
    
    //UITitle
    UIFont *importedFont=[UIFont fontWithName:name size:size];
    NSString *string=text;
    CGSize stringSize = [string sizeWithFont: importedFont];
    CGRect f = CGRectMake(sSize/2-stringSize.width/2, y,stringSize.width,stringSize.height);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: f];
    titleLabel.text=text;
    titleLabel.font = importedFont;
    titleLabel.backgroundColor=bgColor;
    titleLabel.textColor=tColor;

    return titleLabel;
}


@end
