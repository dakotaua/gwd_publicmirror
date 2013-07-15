//
//  EventTableViewController.m
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/11/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "EventTableViewController.h"

@interface EventTableViewController ()
@end

@implementation EventTableViewController

- (IBAction)createTeam:(UIStoryboardSegue*)segue {
    
    if ([[segue identifier] isEqualToString:@"createTeam"]) {
        CreateTeamViewController *createTeamVC = [segue sourceViewController];
        
        if (createTeamVC.teamToCreate) {
            [self.quizEventCollection addObject:createTeamVC.teamToCreate];
            [[self tableView] reloadData];
        }
    }
}

- (IBAction)backToEventView:(UIStoryboardSegue*)segue {
    
    [[self tableView] reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.quizEventCollection = [[NSMutableArray alloc] init];
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
    return self.quizEventCollection.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( self.quizEventCollection.count > 0 && indexPath.row < self.quizEventCollection.count ) {
        
        EventTableTeamCell *teamCell = [tableView dequeueReusableCellWithIdentifier:@"teamCell" forIndexPath:indexPath];
        Quiz *team = [self.quizEventCollection objectAtIndex:indexPath.row];
        teamCell.nameLabel.text = team.teamName;
        teamCell.teamScoreLabel.text = [NSString stringWithFormat:@"%d", [team quizScore]];
        return teamCell;
    }
    else {
        EventTableNewTeamCell *createTeamCell = [tableView dequeueReusableCellWithIdentifier:@"createTeamCell" forIndexPath:indexPath];
        
        if (self.quizEventCollection.count == 0)
            [createTeamCell.createTeamButton setTitle:@"   Add a team..." forState:UIControlStateNormal];
        else
            [createTeamCell.createTeamButton setTitle:@"   Add another team..." forState:UIControlStateNormal];
        return createTeamCell;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"eventToTeamSegue"]) {
        TeamDetailViewController *teamDetailVC = [segue destinationViewController];
        UITableViewCell *teamCell = sender;
        int teamIndex = [self.tableView indexPathForCell:teamCell].row;
        
        teamDetailVC.theTeam = [self.quizEventCollection objectAtIndex:teamIndex];
        teamDetailVC.teamIndex = teamIndex;
        teamDetailVC.theQuizzes = self.quizEventCollection;
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
