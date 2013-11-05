//
//  TableViewController.m
//  BoxClass
//
//  Created by david morton on 10/29/13.
//  Copyright (c) 2013 Andrew Garrahan. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController (){
    CGRect frame;
    
}

@end

@implementation TableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self) {
		cellReuseIdentifier = @"reuse identifier";
		
		//Three default values from class UIScrollView.
		self.tableView.bounces = YES;
		self.tableView.scrollsToTop = YES;
		self.tableView.decelerationRate = UIScrollViewDecelerationRateNormal;
        self.tableView.backgroundColor=[UIColor clearColor];
        
        
        /*
         CGRect tableFrame;
        tableFrame.origin.x = 0;
        tableFrame.origin.y = 0;
        tableFrame.size.width = 200;
        tableFrame.size.height = 200;
         */
        //self.tableView.frame = tableFrame;
        
		//[self.tableView sizeThatFits:CGSizeMake(100.0, 100.0)];
		//Start of work on sections
		//self.tableView.
        
		        

	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.tableView registerClass: [UITableViewCell class]
		   forCellReuseIdentifier: cellReuseIdentifier];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 5;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	UITableViewCell *cell =[tableView cellForRowAtIndexPath: indexPath];
	
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellReuseIdentifier] ;
    }else{
		cell =
		[tableView dequeueReusableCellWithIdentifier: cellReuseIdentifier forIndexPath: indexPath];
	}
	
    /*
	// Configure the cell...
	//The .textLabel and .detailTextLabel properties are UILabels.
	//The .imageView property is a UIImage.
	Airport *thisAirport=[_airports objectAtIndex: indexPath.row];
	
	NSMutableString *labelText=[[NSMutableString alloc] init];
	[labelText appendString:thisAirport.city];
	[labelText appendString:@", "];
	[labelText appendString:thisAirport.stateProvince];
	[labelText appendString:@" ("];
	[labelText appendString:thisAirport.code];
	[labelText appendString:@" )"];
     */
    
    NSString *highScoreString;
    if(indexPath.row==0) highScoreString=@"Admiral ";
    else if(indexPath.row==1) highScoreString=@"Captain";
    else if(indexPath.row==2) highScoreString=@"Commander";
    else if(indexPath.row==3) highScoreString=@"Lieutenant";
    else if(indexPath.row==4) highScoreString=@"Ensign";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *retrivedArray = [userDefaults arrayForKey:@"highScores"];
    for(int i=0;i<[retrivedArray count];++i){
        NSNumber *myNSNumber=[retrivedArray objectAtIndex:i];
        NSInteger myInteger = [myNSNumber integerValue];
        //NSLog(@"High Score %i is %i",i,myInteger);
    }
    
	//cell.textLabel.text = [NSString stringWithFormat:@"%i %@", indexPath.row,highScoreString];
	NSNumber *thisNumber=[retrivedArray objectAtIndex:indexPath.row];
    NSInteger thisScore=[thisNumber integerValue];
    cell.textLabel.text = [NSString stringWithFormat:@"%i %@", thisScore,highScoreString];
	
    /*
	NSMutableString *detailText=[[NSMutableString alloc] init];
	[detailText appendString:thisAirport.name];
	cell.detailTextLabel.text=detailText;
     */
	
	//NSString *fileName = [cell.textLabel.text stringByAppendingString: @".jpg"];
	//cell.imageView.image = [UIImage imageNamed: fileName];	//nil if .jpg file doesn't exist
    
    cell.textLabel.font =[UIFont fontWithName:@"BorgNine-Regular" size:18];
    cell.textLabel.textColor = [UIColor whiteColor];
    //cell.textLabel.textColor = [UIColor whiteColor];//this works
    // Configure the cell.
    
    
    
	return cell;
	
	
	
}







/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */





- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
	// Return YES for supported orientations
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"didSelectRowAtIndexPath");
}








@end

















