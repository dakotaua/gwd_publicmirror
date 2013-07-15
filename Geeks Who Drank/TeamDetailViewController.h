//
//  TeamDetailViewController.h
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/12/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quiz.h"
#import "RoundDetailViewController.h"

@interface TeamDetailViewController : UIViewController

@property (strong, nonatomic) Quiz *theTeam;
@property (nonatomic) int teamIndex;
@property (strong, nonatomic) NSMutableArray* theQuizzes;

@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamScoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *jokerImageView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *roundButtons;

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender;
- (IBAction)viewRoundDetail:(UIButton *)sender;
- (IBAction)backToTeamDetail:(UIStoryboardSegue*)segue;
@end
