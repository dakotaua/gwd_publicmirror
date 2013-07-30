//
//  InitialViewController.h
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/4/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizEvent.h"
#import "QuizTableViewController.h"
#import "UploadQuizViewController.h"

@interface InitialViewController : UIViewController

@property (strong,nonatomic) NSMutableArray* quizEventCollection;
@property (strong, nonatomic) IBOutlet UIButton *uploadButton;
@property (strong, nonatomic) IBOutlet UIButton *quizButton;

// temp solution
@property (strong,nonatomic) NSString* user;


- (IBAction)hostAQuizPressed:(UIButton *)sender;
- (IBAction)uploadAQuizPressed:(UIButton *)sender;

@end
