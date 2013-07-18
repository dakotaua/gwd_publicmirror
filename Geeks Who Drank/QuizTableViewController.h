//
//  QuizTableViewController.h
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/17/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizEvent.h"
#import "CreateTeamViewController.h"
#import "EventTableTeamCell.h"
#import "EventTableNewTeamCell.h"
#import "Quiz.h"
#import "TeamDetailViewController.h"
#import "Constants.h"

@interface QuizTableViewController : UIViewController

@property (strong, nonatomic) QuizEvent* quizEvent;
@property (nonatomic) BOOL sortingByScore;

- (IBAction)createTeam:(UIStoryboardSegue*)segue;
- (IBAction)backToEventView:(UIStoryboardSegue*)segue;

@end
