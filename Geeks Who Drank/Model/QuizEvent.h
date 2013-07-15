//
//  QuizEvent.h
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/2/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//
// QuizEvent models the concept of a night of quizzing, to be maintained by the QuizMaster
//
#import <Foundation/Foundation.h>

@interface QuizEvent : NSObject

@property (strong, nonatomic) NSString *quizMaster;
//@property (strong, nonatomic) NSString *location;
@property (readonly, nonatomic) NSDate *quizDate;
@property (strong, nonatomic) NSMutableArray *quizzes;
@property (strong, nonatomic) NSOrderedSet *standings;

-(void)uploadEvent;

@end