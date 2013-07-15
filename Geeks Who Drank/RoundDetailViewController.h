//
//  RoundDetailViewController.h
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/12/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quiz.h"
#import "QuizRound.h"

@interface RoundDetailViewController : UIViewController

@property (nonatomic) int teamIndex;
@property (nonatomic) int roundIndex;
@property (nonatomic) int questionIndex;

@property (strong,nonatomic) NSMutableArray* theQuizzes;
@property (strong, nonatomic) Quiz* currentTeam;
@property (strong, nonatomic) QuizRound* currentRound;

@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roundLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *scoreLabels;
@property (weak, nonatomic) IBOutlet UILabel *roundScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;

@property (weak, nonatomic) IBOutlet UIButton *jokerButton;

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender;
- (IBAction)jokerButtonPressed:(UIButton *)sender;
- (IBAction)scoreButtonPressed:(UIButton *)sender;
@end
