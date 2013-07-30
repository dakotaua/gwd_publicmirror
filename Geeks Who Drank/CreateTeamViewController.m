//
//  CreateTeamViewController.m
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/12/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "CreateTeamViewController.h"

@interface CreateTeamViewController () <UITextFieldDelegate>

@end

@implementation CreateTeamViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.teamNameInput) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void) setup {
    
    self.teamNameInput.delegate = self;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender    {
    
    if ( [segue.identifier isEqualToString:@"createTeam"]) {
        if (self.teamNameInput.text.length) {
            Quiz* q = [[Quiz alloc] initWithName:self.teamNameInput.text];
            self.teamToCreate = q;
        }
    }
}

@end
