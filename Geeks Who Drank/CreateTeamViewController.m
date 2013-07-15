//
//  CreateTeamViewController.m
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/12/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "CreateTeamViewController.h"

@interface CreateTeamViewController ()

@end

@implementation CreateTeamViewController

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

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender    {
    
    if ( [segue.identifier isEqualToString:@"createTeam"]) {
        if (self.teamNameInput.text.length) {
            Quiz* q = [[Quiz alloc] initWithName:self.teamNameInput.text];
            self.teamToCreate = q;
        }
    }
}

@end
