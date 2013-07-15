//
//  CreateTeamViewController.h
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/12/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quiz.h"

@interface CreateTeamViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *teamNameInput;
@property (strong, nonatomic) Quiz *teamToCreate;
@end
