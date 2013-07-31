//
//  UploadQuizViewController.m
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/18/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "EventListViewController.h"

@interface EventListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EventListViewController


- (void) setup {
    
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    [self.view addSubview:self.tableView];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section, which is equal to the number of events in the collection
    // plus one for the create team button
    return self.quizEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UploadQuizCell *uploadCell = [tableView dequeueReusableCellWithIdentifier:@"uploadQuizCell"];
    
    if (!uploadCell)
        uploadCell = [[UploadQuizCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"uploadQuizCell"];
    QuizEvent* currentEvent = [self.quizEvents objectAtIndex:indexPath.row];
    
    uploadCell.locationLabel.text = currentEvent.location;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    uploadCell.dateLabel.text = [dateFormatter stringFromDate:currentEvent.quizDate];
    
    return uploadCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSError *error;
    QuizEvent *event = [self.quizEvents objectAtIndex:indexPath.row];
    NSData *jsonData = [
        NSJSONSerialization dataWithJSONObject:event.jsonDict
                                       options:0
                                         error:&error
    ];
    
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    }
    
    else {
        NSString *jsonString = [[
            NSString alloc] initWithData:jsonData
                                encoding:NSUTF8StringEncoding
        ];
        
        NSLog(@"%@", jsonString);
    }
    
    // TODO: upload quiz to site API
}

@end
