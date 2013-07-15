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
    
    int workingScore = [self.currentRound roundScore];
    if (self.currentTeam.jokerRound == self.roundIndex)
        workingScore *= 2;
    if (workingScore == 1)
        self.roundScoreLabel.text = [NSString stringWithFormat:@"%d Point", workingScore];

    else
        self.roundScoreLabel.text = [NSString stringWithFormat:@"%d Points", workingScore];
    
    for (UILabel* l in self.scoreLabels) {
        QuizQuestion* q = [self.currentRound.questions objectAtIndex:l.tag];
        if (q.score == 1)
            l.text = [NSString stringWithFormat:@"%d) %d pt", q.questionNumber, q.score];
        else
            l.text = [NSString stringWithFormat:@"%d) %d pts", q.questionNumber, q.score];
    }
    
    self.jokerButton.alpha = (self.currentTeam.jokerRound == self.roundIndex ? 1.0 : 0.4);
    
    if ([self.currentTeam quizScore] != 1)
        self.totalScoreLabel.text = [NSString stringWithFormat:@"%d points",[self.currentTeam quizScore]];
    else
        self.totalScoreLabel.text = [NSString stringWithFormat:@"%d point",[self.currentTeam quizScore]];
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
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        self.teamIndex = (self.teamIndex + 1) % numTeams;
        self.currentTeam = [self.theQuizzes objectAtIndex:self.teamIndex];
        [self refreshUI];
        
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        
        self.teamIndex = (self.teamIndex + (numTeams-1)) % numTeams;
        self.currentTeam = [self.theQuizzes objectAtIndex:self.teamIndex];
        [self refreshUI];
        
    }

    if (sender.direction == UISwipeGestureRecognizerDirectionUp)
        self.roundIndex = (self.roundIndex + 1) % 8;
    
    if (sender.direction == UISwipeGestureRecognizerDirectionDown)
        self.roundIndex = (self.roundIndex + 7) % 8;
    
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
