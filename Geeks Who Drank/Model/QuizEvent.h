//
//  QuizEvent.h
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/2/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizEvent : NSObject

@property (strong, nonatomic) NSString *quizMaster;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSArray *quizzes;
@property (strong, nonatomic) NSOrderedSet *standings;

-(void)uploadEvent;

@end
