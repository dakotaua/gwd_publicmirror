//
//  EventTableViewController.m
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/11/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "EventTableViewController.h"

@interface EventTableViewController ()
@property (strong, nonatomic) NSMutableArray *teamsInFirst;
@property (strong, nonatomic) NSMutableArray *teamsInSecond;
@property (strong, nonatomic) NSMutableArray *teamsInThird;
@property (strong, nonatomic) NSMutableArray *standings;
@end

@implementation EventTableViewController

- (NSMutableArray*)teamsInFirst {

    if (!_teamsInFirst) _teamsInFirst = [[NSMutableArray alloc] init];
    return _teamsInFirst;
}

- (NSMutableArray*)teamsInSecond {
    
    if (!_teamsInSecond) _teamsInSecond = [[NSMutableArray alloc] init];
    return _teamsInSecond;
}

- (NSMutableArray*)teamsInThird {
    
    if (!_teamsInThird) _teamsInThird = [[NSMutableArray alloc] init];
    return _teamsInThird;
}

- (NSMutableArray*)standings {
    
    if (!_standings) _standings = [[NSMutableArray alloc] init];
    return _standings;
    
}

- (IBAction)createTeam:(UIStoryboardSegue*)segue {
    
    if ([[segue identifier] isEqualToString:@"createTeam"]) {
        CreateTeamViewController *createTeamVC = [segue sourceViewController];
        
        if (createTeamVC.teamToCreate) {
            [self.quizCollection addObject:createTeamVC.teamToCreate];
            [[self tableView] reloadData];
        }
    }
}

- (int) getStandingOfPrecedingTeamAtIndex:(int)index {
    
    if (index < 0)
        return 0;
    
    Quiz *team = [self.quizCollection objectAtIndex:index];
    for (Quiz *q in self.teamsInFirst) {
        if ([team.teamName isEqualToString:q.teamName])
            return FIRST_PLACE;
    }
    for (Quiz *q in self.teamsInSecond)
        if ([team.teamName isEqualToString:q.teamName])
            return SECOND_PLACE;
    
    for (Quiz *q in self.teamsInThird)
        if ([team.teamName isEqualToString:q.teamName])
            return THIRD_PLACE;
    
    return 0;
}


- (IBAction)backToEventView:(UIStoryboardSegue*)segue {
    
    //[[self tableView] reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    
    self.teamsInFirst = [[NSMutableArray alloc] init];
    self.teamsInSecond = [[NSMutableArray alloc] init];
    self.teamsInThird = [[NSMutableArray alloc] init];
    self.standings = [[NSMutableArray alloc] init];

    if (self.quizCollection && self.quizCollection.count && self.sortingByScore) {
     
        // sort teams by score
        NSArray *sorted;
        sorted = [self.quizCollection sortedArrayUsingSelector:@selector(reverseCompare:)];
        self.quizCollection = [NSMutableArray arrayWithArray:sorted];
        [[self tableView] reloadData];
    }
    
    //NSLog([NSString stringWithFormat:@"sortingByScore == %d", self.sortingByScore ]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sortingByScore = YES;
    if (!self.quizCollection)
        self.quizCollection = [[NSMutableArray alloc] init];
    
    
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section, which is equal to the number of events in the collection
    // plus one for the create team button
    return self.quizCollection.count + 1;
}

- (void) addTeam:(Quiz*)team toStandings:(int)standings {
    
    if (standings == 1)
        [self.teamsInFirst addObject:team];
    if (standings == 2)
        [self.teamsInSecond addObject:team];
    if (standings == 3)
        [self.teamsInThird addObject:team];
}

- (NSString*) labelForPlacement:(int)placement {

    return [NSString stringWithFormat:@"%d", placement];
//    if (placement == 1)
//        return @"1";
//    if (placement == 2)
//        return @"2";
//    if (placement == 3)
//        return @"3";
//    
//    return @"";
}

-(NSMutableArray*)getStandingArray:(int)standing {
    
    if (standing == 1)
        return self.teamsInFirst;
    if (standing == 2)
        return self.teamsInSecond;
    if (standing == 3)
        return self.teamsInThird;
    
    return nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( self.quizCollection.count > 0 && indexPath.row < self.quizCollection.count ) {
        
        EventTableTeamCell *teamCell = [tableView dequeueReusableCellWithIdentifier:@"teamCell" forIndexPath:indexPath];
        Quiz *team = [self.quizCollection objectAtIndex:indexPath.row];
        teamCell.nameLabel.text = team.teamName;
        NSString *ptStr = ([team quizScore] == 1 ? @" pt" : @"pts");
        teamCell.teamScoreLabel.text = [NSString stringWithFormat:@"%d %@", [team quizScore], ptStr];
        
        // standings
        int myStanding;
        if (indexPath.row == 0)
            myStanding = 1;
        else if ([team quizScore] == [[self.quizCollection objectAtIndex:indexPath.row-1] quizScore])
            myStanding = [[self.standings objectAtIndex:indexPath.row-1] integerValue];
        else
            myStanding = indexPath.row+1;
        
        [self.standings setObject:[NSNumber numberWithInt:myStanding] atIndexedSubscript:indexPath.row];
        
        teamCell.standingLabel.text = [self labelForPlacement:myStanding];
        teamCell.standingLabel.textColor = [UIColor lightGrayColor];
        teamCell.standingLabel.font = [UIFont systemFontOfSize:14];
        if (myStanding < 4) {
            teamCell.standingLabel.textColor = [UIColor blackColor];
            teamCell.standingLabel.font = [UIFont boldSystemFontOfSize:17];
        }
        return teamCell;
    }
    else {
        EventTableNewTeamCell *createTeamCell = [tableView dequeueReusableCellWithIdentifier:@"createTeamCell" forIndexPath:indexPath];
        
        NSString *addStr = (self.quizCollection.count == 0 ? @"   Add a team..." : @"   Add another team...");
        [createTeamCell.createTeamButton setTitle:addStr forState:UIControlStateNormal];
        return createTeamCell;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"eventToTeamSegue"]) {
        TeamDetailViewController *teamDetailVC = [segue destinationViewController];
        UITableViewCell *teamCell = sender;
        int teamIndex = [self.tableView indexPathForCell:teamCell].row;
        
        teamDetailVC.theTeam = [self.quizCollection objectAtIndex:teamIndex];
        teamDetailVC.teamIndex = teamIndex;
        teamDetailVC.theQuizzes = self.quizCollection;
    }
    
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
    // Return NO if you  sdo not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
