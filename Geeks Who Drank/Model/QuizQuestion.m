//
//  QuizQuestion.m
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/2/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "QuizQuestion.h"

@interface QuizQuestion()

@property (readwrite, strong, nonatomic) NSDictionary *jsonDict;

@end

@implementation QuizQuestion

-(NSDictionary *)jsonDict {
    _jsonDict = @{
        @"question_number": [NSNumber numberWithInt:self.questionNumber],
                  @"score": [NSNumber numberWithInt:self.score]
    };
    
    return _jsonDict;
}

@end
