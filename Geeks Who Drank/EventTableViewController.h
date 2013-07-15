//
//  EventTableViewController.h
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/11/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizEvent.h"
#import "CreateTeamViewController.h"
#import "EventTableTeamCell.h"
#import "EventTableNewTeamCell.h"
#import "Quiz.h"
#import "TeamDetailViewController.h"


@interface EventTableViewController : UITableViewController

//@property (nonatomic) int teamIndex;
@property (strong, nonatomic) NSMutableArray *quizEventCollection;

- (IBAction)createTeam:(UIStoryboardSegue*)segue;
- (IBAction)backToEventView:(UIStoryboardSegue*)segue;

@end

