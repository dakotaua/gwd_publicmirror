//
//  QuizTableViewController.m
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/17/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "QuizListViewController.h"

@interface QuizListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *standings;
@end

@implementation QuizListViewController

- (NSMutableArray*)standings {
    
    if (!_standings) _standings = [[NSMutableArray alloc] init];
    return _standings;
    
}

- (void) setup {
    
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    [self.view addSubview:self.tableView];
    
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


- (IBAction)createTeam:(UIStoryboardSegue*)segue {
    
    if ([[segue identifier] isEqualToString:@"createTeam"]) {
        CreateTeamViewController *createTeamVC = [segue sourceViewController];
        
        if (createTeamVC.teamToCreate) {
            [self.quizEvent.quizzes addObject:createTeamVC.teamToCreate];
            [self.tableView reloadData];
        }
    }
}

- (IBAction)backToEventView:(UIStoryboardSegue*)segue {
    
    //[[self tableView] reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"quizTableToTeamDetailSegue"]) {
        QuizDetailViewController *teamDetailVC = [segue destinationViewController];
        UITableViewCell *teamCell = sender;
        int teamIndex = [self.tableView indexPathForCell:teamCell].row;
        
        teamDetailVC.theTeam = [self.quizEvent.quizzes objectAtIndex:teamIndex];
        teamDetailVC.teamIndex = teamIndex;
        teamDetailVC.theQuizzes = self.quizEvent.quizzes;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.standings = [[NSMutableArray alloc] init];
    
    if (self.quizEvent.quizzes && self.quizEvent.quizzes.count && self.sortingByScore) {
        
        // sort teams by score
        NSArray *sorted;
        sorted = [self.quizEvent.quizzes sortedArrayUsingSelector:@selector(reverseCompare:)];
        self.quizEvent.quizzes = [NSMutableArray arrayWithArray:sorted];
        [self.tableView reloadData];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
  	  // Do any additional setup after loading the view.
    self.sortingByScore = YES;
    if (!self.quizEvent.quizzes)
        self.quizEvent.quizzes = [[NSMutableArray alloc] init];
    

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
    return self.quizEvent.quizzes.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( self.quizEvent.quizzes.count > 0 && indexPath.row < self.quizEvent.quizzes.count ) {
        
        QuizTableTeamCell *teamCell = [tableView dequeueReusableCellWithIdentifier:@"teamCell"];
        
        if (!teamCell)
            teamCell = [[QuizTableTeamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"teamCell"];
        
        Quiz *team = [self.quizEvent.quizzes objectAtIndex:indexPath.row];
        teamCell.nameLabel.text = team.teamName;
        NSString *ptStr = ([team quizScore] == 1 ? @" pt" : @"pts");
        teamCell.teamScoreLabel.text = [NSString stringWithFormat:@"%d %@", [team quizScore], ptStr];
        
        // standings
        int myStanding;
        if (indexPath.row == 0)
            myStanding = 1;
        else if ([team quizScore] == [[self.quizEvent.quizzes objectAtIndex:indexPath.row-1] quizScore])
            myStanding = [[self.standings objectAtIndex:indexPath.row-1] integerValue];
        else
            myStanding = indexPath.row+1;
        
        [self.standings setObject:[NSNumber numberWithInt:myStanding] atIndexedSubscript:indexPath.row];
        
        teamCell.standingLabel.text = [self labelForPlacement:myStanding];
        teamCell.standingLabel.textColor = [UIColor lightGrayColor];
        teamCell.standingLabel.font = [UIFont systemFontOfSize:14];
        teamCell.standingLabel.hidden = NO;
        
        if (myStanding < 4) {
            teamCell.standingLabel.textColor = [UIColor blackColor];
            teamCell.standingLabel.font = [UIFont boldSystemFontOfSize:17];
        }
        
        if ([team quizScore] == 0)
            teamCell.standingLabel.hidden = YES;
        
        return teamCell;
    }
    else {
        QuizTableNewTeamCell *createTeamCell = [tableView dequeueReusableCellWithIdentifier:@"createTeamCell"];
        
        if (!createTeamCell)
            createTeamCell = [[QuizTableNewTeamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"createaTeamCell"];
        
        NSString *addStr = (self.quizEvent.quizzes.count == 0 ? @"   Add a team..." : @"   Add another team...");
        [createTeamCell.createTeamButton setTitle:addStr forState:UIControlStateNormal];
        return createTeamCell;
    }
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[QuizTableTeamCell class]]){
    
        QuizTableTeamCell *teamCell = (QuizTableTeamCell *) cell;
        teamCell.nameLabel.backgroundColor = [UIColor clearColor];
        teamCell.teamScoreLabel.backgroundColor = [UIColor clearColor];
        teamCell.standingLabel.backgroundColor = [UIColor clearColor];
    }
    
    if ([cell isKindOfClass:[QuizTableNewTeamCell class]]){
        // Pre-process QuizTableNewTeamCell here
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
