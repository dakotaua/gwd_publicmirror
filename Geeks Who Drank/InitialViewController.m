//
//  InitialViewController.m
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/4/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "InitialViewController.h"

@interface InitialViewController ()
@property (nonatomic) BOOL showingHostFields;
@property (strong, nonatomic) QuizEvent *currentQuizNight;
@end

@implementation InitialViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"hostAQuizSegue"]) {
        QuizTableViewController *quizTableVC = segue.destinationViewController;
        quizTableVC.quizEvent = self.currentQuizNight;
    }
    
    if ([segue.identifier isEqualToString:@"uploadQuizSegue"]){
        UploadQuizViewController *uploadQuizVC = segue.destinationViewController;
        uploadQuizVC.quizEvents = self.quizEventCollection;
    }
}


- (IBAction)hostAQuizPressed:(UIButton *)sender {
    
    QuizEvent *newNight = [[QuizEvent alloc] init];
    newNight.quizMaster = @"Temp Quiz Master string";
    newNight.location = @"Temp Location string";
    [self.quizEventCollection addObject:newNight];
    self.currentQuizNight = newNight;
    [self performSegueWithIdentifier:@"hostAQuizSegue" sender:sender];
    
}

- (IBAction)uploadAQuizPressed:(UIButton *)sender {
}
@end
