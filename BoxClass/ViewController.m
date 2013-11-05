#import <QuartzCore/QuartzCore.h>
#import "Box.h"
#import "ViewController.h"
#import "Utility.h"
//#import "TableViewController.h"

#define SCREEN_WIDTH self.view.frame.size.width
#define SCREEN_HEIGHT self.view.frame.size.height

@interface ViewController (){
    //SCORING
    NSInteger score;
    UILabel *scoreLabel;
    
    //Levels
    int level;
    NSTimer * levelTimer;
    UILabel *levelLabel;
    //float *timeBetweenLevels;
    //float *timeLeftAtCurrentLevel;
    
    //Lives
    int maxLives;
    int livesLost;
    UILabel *livesLabel;

    //Projectiles
    NSMutableArray * destructors;
    NSMutableArray * defenders;
    //Box * hero;

    
    //Spawing Timer
    NSTimer * spawnBox;
    float initialSpawnTimerInterval;
    
    UITableViewController *tableViewController;
    
    float fontSize;
    
    UILabel *myScoreLabel;
    
    UIImage *borgCubeImage;
    
    SystemSoundID weAreBorgSid;
    SystemSoundID torpedoSid;
    SystemSoundID explosionSid;
}

@end






@implementation ViewController
/*
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"touchesMoved");
 
    // Calculate offset
    CGPoint pt = [[touches anyObject] locationInView:self];
    float dx = pt.x - startLocation.x;
    float dy = pt.y - startLocation.y;
    CGPoint newcenter = CGPointMake(
                                    self.center.x + dx,
                                    self.center.y + dy);
    
    // Set new location
    self.center = newcenter;
 
}
*/

 - (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint point=[[touches anyObject] locationInView:_gameView];
    //NSLog(@"touchesBegan at %f,%f",point.x,point.y);
    [self spawnADefender:point];
 // Calculate and store offset, and pop view into front if needed
 //startLocation = [[touches anyObject] locationInView:self];
    //[self.superview bringSubviewToFront:self];
    //NSLog(@"destructors array size=%i",[destructors count]);
    //NSLog(@"defenders array size=%i",[defenders count]);
    //NSLog(@"level=%i",level);
 }





/*
 -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
 {
 
 }
 
 */




-(void)startGame{
    
    _gameView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT)];
    _gameView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile.png"]];
    
    //NSLog(@"Starting Game");
    
    //Initial Spawn Timer
    //GOOD
    initialSpawnTimerInterval=1.3;
    
    //FOR SPEED
    //initialSpawnTimerInterval=.2;
    
    //Lives
    maxLives=10;
    livesLost=0;
    livesLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, SCREEN_HEIGHT-20, 70, 20)];
    livesLabel.text=[NSString stringWithFormat:@"%d/10", (maxLives-livesLost)];
    livesLabel.backgroundColor=[UIColor clearColor];
    livesLabel.textColor=[UIColor whiteColor];
    [_gameView addSubview:livesLabel];
    
    //Scoring
    score=0;
    scoreLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, 0, 70, 20)];
    scoreLabel.text=[NSString stringWithFormat:@"%d", (int)score];
    scoreLabel.backgroundColor=[UIColor clearColor];
    scoreLabel.textColor=[UIColor whiteColor];
    [_gameView addSubview:scoreLabel];
    
    //Levels
    level=1;
    levelLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    levelLabel.text=[NSString stringWithFormat:@"Level %d", (int)level];
    [_gameView addSubview:levelLabel];
    levelLabel.backgroundColor=[UIColor clearColor];
    levelLabel.textColor=[UIColor whiteColor];
    
    //float timeBetweenLevels=15.0;
    
    destructors=[[NSMutableArray alloc] init];
    defenders=[[NSMutableArray alloc] init];
    //[self spawnABox];
    
    /*
     hero=[[Box alloc] initMakeMeABox];
     hero.frame=CGRectMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-20,20,20);
     hero.backgroundColor=[UIColor redColor];
     [self.view addSubview:hero];
     */
    
    /*
     //GETS fired everytime screen refreshes ~60Hz
     CADisplayLink * displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(stepWorld)];
     [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    */
    spawnBox=[NSTimer scheduledTimerWithTimeInterval:initialSpawnTimerInterval target:self selector:@selector(spawnADestructor) userInfo:nil repeats:YES];
    
    levelTimer=[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(incrementLevel) userInfo:nil repeats:YES];
    
    [self.view addSubview:_gameView];
    _titleView.hidden=YES;
    _gameView.hidden=NO;
}


- (void)viewDidLoad
{
    /*
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *retrivedArray = [userDefaults arrayForKey:@"highScores"];
    for(int i=0;i<[retrivedArray count];++i){
        NSNumber *myNSNumber=[retrivedArray objectAtIndex:i];
        NSInteger myInteger = [myNSNumber integerValue];
        NSLog(@"Retrieved High Score From viewDidLoad: %i is %i",i,myInteger);
    }
     */
    
    borgCubeImage=[UIImage imageNamed:@"borg_cube.png"];
    
    
    
    
    
    //START AUDIO SETUP
    //NOTE: although apple's documentation at http://developer.apple.com/library/ios/#documentation/AudioToolbox/Reference/SystemSoundServicesReference/Reference/reference.html
    // says "Simultaneous playback is unavailable: You can play only one sound at a time"
    //It seems to not stop previous sound!  You can see by clicking quickly
    
    // Override point for customization after application launch.
    NSBundle *bundle = [NSBundle mainBundle];
    
    NSString *filename = [bundle pathForResource: @"weareborg" ofType: @"wav"];
    NSURL *url = [NSURL fileURLWithPath: filename isDirectory: NO];
    OSStatus audioError = AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &weAreBorgSid);
    if (audioError != kAudioServicesNoError) {
        NSLog(@"AudioServicesCreateSystemSoundID error == %ld", audioError);
    }
    
    filename = [bundle pathForResource: @"torpedo" ofType: @"mp3"];
    url = [NSURL fileURLWithPath: filename isDirectory: NO];
    audioError = AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &torpedoSid);
    if (audioError != kAudioServicesNoError) {
        NSLog(@"AudioServicesCreateSystemSoundID error == %ld", audioError);
    }
    
    filename = [bundle pathForResource: @"explosion" ofType: @"mp3"];
    url = [NSURL fileURLWithPath: filename isDirectory: NO];
    audioError = AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &explosionSid);
    if (audioError != kAudioServicesNoError) {
        NSLog(@"AudioServicesCreateSystemSoundID error == %ld", audioError);
    }
    //END AUDIO SETUP

    
    //GETS fired everytime screen refreshes ~60Hz
    CADisplayLink * displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(stepWorld)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    //NSLog(@"viewDidLoad");
    
    _gameView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT)];
    _titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT)];
    _titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile.png"]];
    
    //  ****** TITLE VIEW ******
    
    //ANIMATION:
    NSMutableArray *myImages=[[NSMutableArray alloc] init];
    for(int i=0;i<75;++i){
        NSString *thisName;
        if(i<10){
            thisName=[NSString stringWithFormat:@"locutus-of-borg-o_000%i_Layer-%i.png", i,75-i];
        }else{
            thisName=[NSString stringWithFormat:@"locutus-of-borg-o_00%i_Layer-%i.png", i,(75-i)];
        }
        //NSLog(@"%@",thisName);
        
        [myImages addObject:[UIImage imageNamed:thisName]];

        
    }
    
    UIImageView *myAnimatedView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, 320, 240)];
    myAnimatedView.animationImages = myImages;
    myAnimatedView.animationDuration = 6.0;
    [_titleView addSubview:myAnimatedView];
    [myAnimatedView startAnimating];
    
    /*
    for(NSString* family in [UIFont familyNames]) {
        NSLog(@"%@", family);
        for(NSString* name in [UIFont fontNamesForFamilyName: family]) {
            NSLog(@"  %@", name);
        }
    }
     */
    
    
    //UITitle
    NSString *fontName=@"BorgNine-Regular";
    fontSize=20.0;
    
    UIFont *importedFont=[UIFont fontWithName:fontName size:fontSize];
    NSString *string=@"Return";
    CGSize size = [string sizeWithFont: importedFont];
    CGRect f = CGRectMake(SCREEN_WIDTH/2-size.width/2, 0,size.width,size.height);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: f];
    titleLabel.text=string;
    titleLabel.font = importedFont;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=[UIColor whiteColor];
    [_titleView addSubview:titleLabel];
    
    UILabel *titleLabel2=[Utility makeTitleLabel:@"of the" withName:@"BorgNine-Regular" fontSize:fontSize y:20 bgColor:[UIColor clearColor] textColor:[UIColor whiteColor] screenWidth:SCREEN_WIDTH];
    [_titleView addSubview:titleLabel2];
    
    
    UILabel *titleLabel3=[Utility makeTitleLabel:@"Borg" withName:@"BorgNine-Regular" fontSize:fontSize y:40 bgColor:[UIColor clearColor] textColor:[UIColor whiteColor] screenWidth:SCREEN_WIDTH];
    [_titleView addSubview:titleLabel3];
    
    
    
    UILabel *tapToPlayLabel=[Utility makeTitleLabel:@"Resist" withName:@"BorgNine-Regular" fontSize:fontSize y:SCREEN_HEIGHT-80 bgColor:[UIColor clearColor] textColor:[UIColor whiteColor] screenWidth:SCREEN_WIDTH];
    [_titleView addSubview:tapToPlayLabel];
    
    
    tapToPlayLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *labelTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startGame)];
    labelTap.numberOfTapsRequired=1;
    [tapToPlayLabel addGestureRecognizer:labelTap];
    
    //  ****** END TITLE VIEW ******
    
    
    

    
    
    //self.view=_titleView;
    [self.view addSubview:_gameView];
    _gameView.hidden=YES;
    

    [self.view addSubview:_titleView];
    
    /*
    //TESTING
    NSMutableArray *highScores=[[NSMutableArray alloc] init];
    [highScores addObject:[NSNumber numberWithInt:0]];
    [highScores addObject:[NSNumber numberWithInt:0]];
    [highScores addObject:[NSNumber numberWithInt:0]];
    [highScores addObject:[NSNumber numberWithInt:0]];
    [highScores addObject:[NSNumber numberWithInt:0]];
    
    
    NSArray *savedArray = highScores;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:savedArray forKey:@"highScores"];
    [userDefaults synchronize];
    */
    
    
	AudioServicesPlaySystemSound(weAreBorgSid);
    
}

-(void)incrementLevel{
    //NSLog(@"Increment Level");
    level=level+1;
    levelLabel.text=[NSString stringWithFormat:@"Level %d", (int)level];
    [spawnBox invalidate];
    spawnBox=nil;
    //double newTimeInterval=1.0/((.25)*((float)level-1.0)+1);
    float newTimeInterval=initialSpawnTimerInterval*pow(.96,level);
    //NSLog(@"newTimeInterval=%f",newTimeInterval);
    spawnBox=[NSTimer scheduledTimerWithTimeInterval:newTimeInterval target:self selector:@selector(spawnADestructor) userInfo:nil repeats:YES];
    
}

-(void)spawnADestructor{
    
    //NEEDS TO USE FLOATS
    
    Box * temp = [[Box alloc] initMakeMeABox:borgCubeImage];
    
    int radX = arc4random()%(int)SCREEN_WIDTH;
    int radY = 0;
    
    temp.center = CGPointMake(radX, radY);
    
    temp.deltaX = ((float)(arc4random()%3))/4.0;
    if(arc4random()%2==0)temp.deltaX*=-1;
    
    //Change range based on speed and distance to edge
    
    
    temp.deltaY =((float)(arc4random()%(int)3)*.33)+(float)level*.075;
    
    //for speed - temp
    //temp.deltaY+=2;
    
    
    
    [_gameView addSubview:temp];
    [destructors addObject:temp];
}


-(void)spawnADefender:(CGPoint)point{
    AudioServicesPlaySystemSound(torpedoSid);
    //NSLog(@"spawnADefender with point %f,%f",point.x,point.y);

    Box * temp = [[Box alloc]initMakeMeABox];
    
    temp.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT);
    
    /*
    temp.deltaX = arc4random()%(int)3;
    if(arc4random()%2==0)temp.deltaX*=-1;
    
    //Change range based on speed and distance to edge
    
    temp.deltaY =arc4random()%(int)2+1;
     */
    temp.deltaX=0;
    temp.deltaY=-1;
    
    
    CGFloat width=SCREEN_WIDTH/2-point.x;
    CGFloat height=SCREEN_HEIGHT-point.y;
    //NSLog(@"height,width of triangle: %f,%f",width,height);
    //NSLog(@"point.x,point.y=%f,%f",point.x,point.y);
    temp.deltaX= (-9)*width/SCREEN_WIDTH;
    temp.deltaY=(-9)*height/SCREEN_WIDTH;
    
    temp.backgroundColor=[UIColor greenColor];
    
    
    [_gameView addSubview:temp];
    [defenders addObject:temp];
    
    //NSLog(@"Spawned Defender with temp.deltaY=%f",temp.deltaY);

}

-(void)gameOver{
    NSString *scoreString=[NSString stringWithFormat:@"Your Score: %i",score];
    //NSLog(@"%@",scoreString);
    
    livesLabel.text=[NSString stringWithFormat:@"0/10"];
    [spawnBox invalidate];
    spawnBox=nil;
    [levelTimer invalidate];
    levelTimer=nil;
    [defenders removeAllObjects];
    defenders=nil;
    [destructors removeAllObjects];
    destructors=nil;
    
    
    AudioServicesPlaySystemSound(explosionSid);
    
    /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:highScore1 forKey:@"firstName"];
    [defaults setObject:lastName forKey:@"lastname"];
    [defaults setInteger:age forKey:@"age"];
    [defaults setObject:imageData forKey:@"image"];
    [defaults synchronize];
    NSLog(@"Data saved");
    */
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSArray *retrivedArray = [userDefaults arrayForKey:@"highScores"];
    
        /*
    for(int i=0;i<[retrivedArray count];++i){
        NSNumber *myNSNumber=[retrivedArray objectAtIndex:i];
        NSInteger myInteger = [myNSNumber integerValue];
        //NSLog(@"Retrieved High Score From GameOver: %i is %i",i,myInteger);
    }
     */

    //NSLog(@"Checking if my score is better than existing");
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:retrivedArray];
    for(int i=0;i<[array count];++i){
        NSNumber *myNSNumber=[array objectAtIndex:i];
        NSInteger myInteger = [myNSNumber integerValue];

        if(score>myInteger) {
            //NSLog(@"score>myInteger %i>%i",score,myInteger);
            for(int j=4;j>i;--j){
                //NSLog(@"j=%i",j);
                [array replaceObjectAtIndex:(j) withObject:[array objectAtIndex:j-1]];
            }
            //NSLog(@"Replacing High Score at %i with %i",i,score);
            [array replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:score]];
            score=0;
            break;
        }
        //NSLog(@"High Score %i is %i",i,myInteger);
    }
    
    /*
    NSLog(@"SAVING NEW SCORES");
    for(int i=0;i<[array count];++i){
        NSNumber *myNSNumber=[array objectAtIndex:i];
        NSInteger myInteger = [myNSNumber integerValue];
        NSLog(@"score - %i",myInteger);
    }
     */
    
    [userDefaults setObject:[NSArray arrayWithArray:array] forKey:@"highScores"];
    [userDefaults synchronize];
    
    
    
    tableViewController= [[TableViewController alloc] init];
    
    
    CGRect tableFrame;
    float widthPercent=.7;
    tableFrame.origin.x = SCREEN_WIDTH/2-SCREEN_WIDTH*widthPercent/2;
    tableFrame.origin.y = SCREEN_HEIGHT*.25;
    tableFrame.size.width = SCREEN_WIDTH*widthPercent;
    tableFrame.size.height = SCREEN_HEIGHT*.50;
    tableViewController.view.frame=tableFrame;
    
    
    //[self presentViewController:tableViewController animated:YES completion:nil];
    _gameView.hidden=YES;
    
    // ***** START HIGH SCORE VIEW *****
    _highScoreView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT)];
    _highScoreView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile.png"]];
    
    UILabel *highScoreLabel=[Utility makeTitleLabel:@"High Scores" withName:@"BorgNine-Regular" fontSize:fontSize y:0 bgColor:[UIColor clearColor] textColor:[UIColor whiteColor] screenWidth:SCREEN_WIDTH];
    [_highScoreView addSubview:highScoreLabel];

    
    myScoreLabel=[Utility makeTitleLabel:scoreString withName:@"BorgNine-Regular" fontSize:15 y:30 bgColor:[UIColor clearColor] textColor:[UIColor whiteColor] screenWidth:SCREEN_WIDTH];
    [_highScoreView addSubview:myScoreLabel];
    

    
    UILabel *backToTitlePageLabel=[Utility makeTitleLabel:@"OK" withName:@"BorgNine-Regular" fontSize:fontSize y:SCREEN_HEIGHT-80 bgColor:[UIColor clearColor] textColor:[UIColor whiteColor] screenWidth:SCREEN_WIDTH];
    [_highScoreView addSubview:backToTitlePageLabel];
    backToTitlePageLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *backToTitlePageLabelTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToTitle)];
    backToTitlePageLabelTap.numberOfTapsRequired=1;
    [backToTitlePageLabel addGestureRecognizer:backToTitlePageLabelTap];
    // ***** END HIGH SCORE VIEW ******
    
    [self.view addSubview:_highScoreView];
    _highScoreView.hidden=YES;
    [_highScoreView addSubview:tableViewController.view];
    
    _highScoreView.hidden=NO;
}

-(void)backToTitle{
    _highScoreView.hidden=YES;
    _titleView.hidden=NO;
    
	AudioServicesPlaySystemSound(weAreBorgSid);
}

-(void)stepWorld{
    
    for(int i=0;i<[destructors count];++i){
        Box * destructor=[destructors objectAtIndex:i];
        
        /*
        if(temp.center.x>SCREEN_WIDTH){
            temp.deltaX*=-1;
        }else if(temp.center.x<0){
            temp.deltaX*=-1;
            
        }
         */
        
        /*
        if(temp.center.y>SCREEN_HEIGHT){
            temp.deltaY*=-1;
        }else if(temp.center.y<0){
            temp.deltaY*=-1;
            
        }
         */
        
        //didrectanglesintersect is one option?
        
        
        destructor.center=CGPointMake(destructor.center.x+destructor.deltaX, destructor.center.y+destructor.deltaY);
        
        for(int i=0;i<[defenders count];++i){
            Box * defender=[defenders objectAtIndex:i];
            
            if(CGRectIntersectsRect(destructor.frame,defender.frame)){
                //temp.backgroundColor=[UIColor greenColor];
                //NSLog(@"Adding 10");
                
                //NSLog(@"Current Score=%i",(int)score);
                //Without Casting Breaks!
                score=(int)score+10*level;
                //NSLog(@"New Score=%i",(int)score);
                scoreLabel.text=[NSString stringWithFormat:@"%d", (int)score];
                destructor.isDestroyed=YES;
                defender.isDestroyed=YES;
                
                AudioServicesPlaySystemSound(explosionSid);
            }else if(defender.center.y<0){
                defender.isDestroyed=YES;
            }
            
        }
                
        //DESTRUCTOR OFF SCREEN
        if(destructor.center.y>SCREEN_HEIGHT){
            //NSLog(@"Life Lost");
            destructor.isDestroyed=YES;
            livesLost++;
            if(livesLost==maxLives){
                [self gameOver];
                return;
            }
            livesLabel.text=[NSString stringWithFormat:@"%d/10", (maxLives-livesLost)];
        }else if(destructor.center.x<0){
            destructor.isDestroyed=YES;
        }else if(destructor.center.x>SCREEN_WIDTH){
            destructor.isDestroyed=YES;
        }
    }
    
    //REMOVING OBJECTS
    
    for(int i=0;i<[destructors count];++i){
        Box * destructor=[destructors objectAtIndex:i];
        if([destructor isDestroyed]){
            //NSLog(@"Removing Destructor");
            [destructor removeFromSuperview];
            [destructors removeObject:destructor];
        }

    }
    for(int i=0;i<[defenders count];++i){
        Box * defender=[defenders objectAtIndex:i];
        if([defender isDestroyed]){
            //NSLog(@"Removing Defender");
            [defender removeFromSuperview];
            [defenders removeObject:defender];
        }

    }
    

    //Move Defenders
    for(int i=0;i<[defenders count];++i){
        Box * defender=[defenders objectAtIndex:i];
        defender.center=CGPointMake(defender.center.x+defender.deltaX, defender.center.y+defender.deltaY);
    }
    
    
    
    
}


































@end
