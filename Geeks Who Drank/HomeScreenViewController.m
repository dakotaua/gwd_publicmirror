//
//  InitialViewController.m
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/4/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "HomeScreenViewController.h"

@interface HomeScreenViewController ()
@property (nonatomic) BOOL showingHostFields;
@property (strong, nonatomic) QuizEvent *currentQuizNight;
@end

@implementation HomeScreenViewController

- (NSMutableArray*)quizEventCollection {
    
    if (!_quizEventCollection) _quizEventCollection = [[NSMutableArray alloc] init];
    return _quizEventCollection;    
}

- (IBAction)backToInitialView:(UIStoryboardSegue*)segue {
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)configureButtons {
    
    NSString *tempS = @"start quizzin'!";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tempS];
    [attributedString addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithFloat:-10.0] range:NSMakeRange(0,tempS.length)];
    [attributedString addAttribute:NSStrokeColorAttributeName value:[UIColor colorWithRed:127.0f/255.0f green:0 blue:0 alpha:1] range:NSMakeRange(0, tempS.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, tempS.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Cupid-Wide-Normal" size:30.0f] range:NSMakeRange(0,tempS.length)];
    [self.quizButton setAttributedTitle:attributedString forState:UIControlStateNormal];
//    [self.quizButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [self.quizButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];


}
- (void)viewDidLoad
{
    [super viewDidLoad];
 
//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"%@", family);
//        
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"  %@", name);
//        }
//    }
    
    [self configureButtons];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"InitialViewBackground.png"]];

  	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"newEventSegue"]) {
        QuizListViewController *newEventVC = segue.destinationViewController;
        newEventVC.quizEvent = self.currentQuizNight;
    }
    
    if ([segue.identifier isEqualToString:@"eventListSegue"]){
        EventListViewController *eventListVC = segue.destinationViewController;
        eventListVC.quizEvents = self.quizEventCollection;
    }
    
    if ([segue.identifier isEqualToString:@"eventDetailSegue"]) {
        QuizListViewController *eventVC = segue.destinationViewController;
        eventVC.quizEvent = self.currentQuizNight;
    }
}

/**
 * This action checks to see if there are existing quizzes in the quiz event collection.
 *
 * If there are no quizzes, a new quiz is created, and this will segue to the quiz list view to start adding teams.
 *
 * If there are quizzes, this will segue to the event list view to choose an event to score or upload.
 */
- (IBAction)startQuizzinPressed:(UIButton *)sender {
    
    if ([self.quizEventCollection count] == 0) {
        QuizEvent *newNight = [[QuizEvent alloc] init];
        newNight.quizMaster = @"Temp Quiz Master string";
        newNight.location = @"Temp Location string";
        [self.quizEventCollection addObject:newNight];
        self.currentQuizNight = newNight;
        
        [self performSegueWithIdentifier:@"newEventSegue" sender:sender];
    }
    
    else {
        [self performSegueWithIdentifier:@"eventListSegue" sender:sender];
    }
}

@end
