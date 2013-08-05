//
//  EventManagerTests.m
//  Geeks Who Drank
//
//  Created by Colin Scott-Fleming on 8/5/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "EventManagerTests.h"
#import "EventManager.h"

@implementation EventManagerTests

- (void)setUp {
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testEventManagerSingleton {
    EventManager *eventManager = [EventManager sharedManager];
    STAssertTrue([eventManager isKindOfClass:[EventManager class]], @"Failed: eventManager is not an EventManager?");
    
    EventManager *em2 = [EventManager sharedManager];
    STAssertTrue(em2 == eventManager, @"Failed: Something is messed up with the singleton initializer.");
    
    // TODO: Add functionality to cover-test singleton via a setter that resets the dispatch token.
}

- (void)testEventManagerAddEventBasic {
    EventManager *eventManager = [EventManager sharedManager];
    
    [eventManager addDefaultQuizEvent];
    
    int count = [eventManager.eventList count];
    
    STAssertEquals(count, 1, @"An event was not added to the EventManager properly.");
}

- (void)testEventManagerSingletonAdd {
    EventManager *eventManager = [EventManager sharedManager];
    [eventManager.eventList removeAllObjects];
    
    [eventManager addDefaultQuizEvent];
    int count = [eventManager.eventList count];
    
    STAssertEquals(1, count, @"List was not emptied properly before adding a new event.");
    
    EventManager *em = [EventManager sharedManager];
    
    count = [em.eventList count];
    STAssertEquals(1, count, @"Count did not carry over in the singleton share.");
    
    [em addDefaultQuizEvent];
    count = [em.eventList count];
    STAssertEquals(2, count, @"Count did not increment properly when a second event was added.");
    
    [eventManager addDefaultQuizEvent];
    STAssertEquals([em.eventList count], [eventManager.eventList count], @"Counts were not the same.");
}

@end
