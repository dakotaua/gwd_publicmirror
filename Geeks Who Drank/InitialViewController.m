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

- (void)configureButtons {
    
    NSString *tempS = @"upload a quiz";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tempS];
    [attributedString addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithFloat:-10.0] range:NSMakeRange(0,tempS.length)];
    [attributedString addAttribute:NSStrokeColorAttributeName value:[UIColor colorWithRed:127.0f/255.0f green:0 blue:0 alpha:1] range:NSMakeRange(0, tempS.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, tempS.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Cupid-Wide-Normal" size:30.0f] range:NSMakeRange(0,tempS.length)];
    [self.uploadButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
//    UIImage *buttonImage = [[UIImage imageNamed:@"orangeButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
//    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"orangeButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
//    [self.uploadButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [self.uploadButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    tempS = @"start quizzin'!";
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempS];
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
