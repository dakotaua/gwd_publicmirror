//
//  RoundDetailViewController.m
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/12/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "RoundDetailViewController.h"

@interface RoundDetailViewController ()

@end

@implementation RoundDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) refreshUI {
    
    self.currentTeam = [self.theQuizzes objectAtIndex:self.teamIndex];
    self.currentRound = [self.currentTeam.quizRounds objectAtIndex:self.roundIndex];
    
    self.teamNameLabel.text = self.currentTeam.teamName;
    self.roundLabel.text = [NSString stringWithFormat:@"Round %d", self.roundIndex+1 ];
    
    int workingScore = (self.currentTeam.jokerRound != self.roundIndex ? [self.currentRound roundScore] : [self.currentRound roundScore]*2);
    NSString *pointStr = (workingScore == 1 ? @"Point" : @"Points");
    self.roundScoreLabel.text = [NSString stringWithFormat:@"%d %@", workingScore, pointStr];
    
    for (UILabel* l in self.scoreLabels) {
        QuizQuestion* q = [self.currentRound.questions objectAtIndex:l.tag];
        NSString *ptStr = (q.score == 1 ? @"pt" : @"pts");
        l.text = [NSString stringWithFormat:@"%d) %d %@", q.questionNumber, q.score, ptStr];
    }
    
    self.jokerButton.alpha = (self.currentTeam.jokerRound == self.roundIndex ? 1.0 : 0.4);
    
    NSString *qScore = ([self.currentTeam quizScore] == 1 ? @"point" : @"points");
    self.totalScoreLabel.text = [NSString stringWithFormat:@"%d %@",[self.currentTeam quizScore], qScore];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    
    int numTeams = self.theQuizzes.count;
    
    if (numTeams > 1){
        
        if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
            
            [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:
             ^{
                 self.teamIndex = (self.teamIndex + 1) % numTeams;
                 self.currentTeam = [self.theQuizzes objectAtIndex:self.teamIndex];
             } completion:NULL];
        
        if (sender.direction == UISwipeGestureRecognizerDirectionRight)
            
            [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:
             ^{
                 self.teamIndex = (self.teamIndex + (numTeams-1)) % numTeams;
                 self.currentTeam = [self.theQuizzes objectAtIndex:self.teamIndex];             } completion:NULL];
        
        
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionUp)
        [UIView transitionWithView:self.view duration:.5 options:UIViewAnimationOptionTransitionCurlUp animations:
         ^{
             self.roundIndex = (self.roundIndex + 1) % 8;
         } completion:NULL];
    
    if (sender.direction == UISwipeGestureRecognizerDirectionDown)
        [UIView transitionWithView:self.view duration:.5 options:UIViewAnimationOptionTransitionCurlDown animations:
         ^{
             self.roundIndex = (self.roundIndex + 7) % 8;
         } completion:NULL];
    
    [self refreshUI];

}

- (IBAction)jokerButtonPressed:(UIButton *)sender {
    
    if (self.currentTeam.jokerRound != self.roundIndex)
        self.currentTeam.jokerRound = self.roundIndex;
    else
        self.currentTeam.jokerRound = -1;
    [self refreshUI];
    
}

- (IBAction)scoreButtonPressed:(UIButton *)sender {
    
    self.questionIndex = sender.tag;
    QuizRound* curRound = [self.currentTeam.quizRounds objectAtIndex:self.roundIndex];
    QuizQuestion* q = [curRound.questions objectAtIndex:self.questionIndex];
    
    if ([[sender titleLabel].text isEqualToString:@"-"]) 
        q.score--;
    else 
        q.score++;
    
    
    [self refreshUI];
    
}


@end
