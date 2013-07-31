//
//  TeamDetailViewController.m
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/12/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "QuizDetailViewController.h"

@interface QuizDetailViewController ()

@end

@implementation QuizDetailViewController


- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    
    int numTeams = self.theQuizzes.count;
    if (numTeams > 1) {
        if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
            
            
            [UIView transitionWithView:self.view duration:.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:
             ^{
                 self.teamIndex = (self.teamIndex + 1) % numTeams;
                 self.theTeam = [self.theQuizzes objectAtIndex:self.teamIndex];
             } completion:NULL];
            [self refreshUI];
        }
        
        if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
            
            [UIView transitionWithView:self.view duration:.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:
             ^{
                 self.teamIndex = (self.teamIndex + (numTeams-1)) % numTeams;
                 self.theTeam = [self.theQuizzes objectAtIndex:self.teamIndex];
             } completion:NULL];
            [self refreshUI];
            
        }
    }
}

- (IBAction)viewRoundDetail:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"teamToRoundSegue" sender:sender];
}

-(IBAction)backToTeamDetail:(UIStoryboardSegue*)segue{
    
    // implemented via wizardboard
    if ([[segue identifier] isEqualToString:@"roundToTeamSegue"]) {
        RoundDetailViewController* roundVC = [segue sourceViewController];
        self.teamIndex = roundVC.teamIndex;
    }
    [self refreshUI];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) refreshUI {
    
    self.theTeam = [self.theQuizzes objectAtIndex:self.teamIndex];
    
    self.teamNameLabel.text = self.theTeam.teamName;
    self.teamScoreLabel.text = [NSString stringWithFormat:@"%d points",[self.theTeam quizScore]];
    
    for (UIButton* b in self.roundButtons) {
        int roundIndex = b.tag;
        QuizRound* curRound = [self.theTeam.quizRounds objectAtIndex:roundIndex];
        int workingScore = (roundIndex!= self.theTeam.jokerRound ? [curRound roundScore] : [curRound roundScore]*2);
        NSString *ptStr = (workingScore == 1 ? @"pt" : @"pts");
        [b setTitle:[NSString stringWithFormat:@"Round %d - %d %@",roundIndex+1, workingScore, ptStr] forState:UIControlStateNormal];
        if (roundIndex == self.theTeam.jokerRound)
            b.titleLabel.textColor = [UIColor redColor];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshUI];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.teamNameLabel.text = self.theTeam.teamName;
    //self.teamScoreLabel.text = [NSString stringWithFormat:@"%d points",[self.theTeam quizScore]];
    
//    for (UIButton *b in self.roundButtons) 
//        [b setTitle:[NSString stringWithFormat:@"Round %d", b.tag+1] forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ( [segue.identifier isEqualToString:@"teamToRoundSegue"])   {
        
        UIButton* roundButton = sender;
        RoundDetailViewController* roundDetailVC = [segue destinationViewController];
        roundDetailVC.roundIndex = roundButton.tag;
        roundDetailVC.currentTeam = self.theTeam;
        roundDetailVC.teamIndex = self.teamIndex;
        roundDetailVC.theQuizzes = self.theQuizzes;
        
    }
}

@end
