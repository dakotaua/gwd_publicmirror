//
//  UploadQuizViewController.m
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/18/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "EventListViewController.h"
#import "QuizListViewController.h"

@interface EventListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EventListViewController

- (IBAction)editQuiz:(id)sender {
    if ([sender isKindOfClass:[UILongPressGestureRecognizer class]]) {
        UILongPressGestureRecognizer *gesture = (UILongPressGestureRecognizer *)sender;
        EventTableNewEventCell *cell = (EventTableNewEventCell *)gesture.view;
        
        [self performSegueWithIdentifier:@"editEventSegue" sender:cell];
    }
}

- (IBAction)startNewQuiz:(UIButton *)sender {
    EventTableNewEventCell *cell = (EventTableNewEventCell *) sender.superview.superview;
    [self performSegueWithIdentifier:@"editEventSegue" sender:cell];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"editEventSegue"]) {
        QuizListViewController *quizListVC = segue.destinationViewController;
        
        if ([sender isKindOfClass:[EventTableEventCell class]]) {
            EventTableEventCell *eventCell = (EventTableEventCell *)sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:eventCell];
            quizListVC.quizEvent = [self.quizEvents objectAtIndex:indexPath.row];
        }
        
        if ([sender isKindOfClass:[EventTableNewEventCell class]]) {
            QuizEvent *newEvent = [[QuizEvent alloc] initWithTempValues];
            [self.quizEvents addObject:newEvent];
            quizListVC.quizEvent = newEvent;
        }
    }
}

- (void)setup {
    
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
    return [self.quizEvents count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.quizEvents count] > 0 && indexPath.row < [self.quizEvents count]) {
        EventTableEventCell *eventCell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
        
        if (!eventCell)
            eventCell = [[EventTableEventCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"eventCell"];
        
        QuizEvent* currentEvent = [self.quizEvents objectAtIndex:indexPath.row];
        
        eventCell.locationLabel.text = currentEvent.location;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        eventCell.dateLabel.text = [dateFormatter stringFromDate:currentEvent.quizDate];
        
        [eventCell addGestureRecognizer:
            [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(editQuiz:)]
        ];

        return eventCell;
    }
    
    else {
        EventTableNewEventCell *newEventCell = [tableView dequeueReusableCellWithIdentifier:@"newEventCell"];
        
        if (!newEventCell)
            newEventCell = [[EventTableNewEventCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:@"newEventCell"];
        
        return newEventCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: add swipe functionality for uploading

    NSError *error;
    QuizEvent *event = [self.quizEvents objectAtIndex:indexPath.row];
    NSData *jsonData = [
        NSJSONSerialization dataWithJSONObject:event.jsonDict
                                       options:0
                                         error:&error
    ];
    
    if (!jsonData) {
        NSLog(@"Something went wrong with building the Event plist: %@", error);
    }
    
    else {
        NSString *jsonString = [[
            NSString alloc] initWithData:jsonData
                                encoding:NSUTF8StringEncoding
        ];
        
        NSLog(@"%@", jsonString);
    }

}

@end
