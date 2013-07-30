//
//  QuizQuestion.h
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/2/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizQuestion : NSObject

@property (nonatomic) int score;
@property (nonatomic) int questionNumber;
@property (strong, nonatomic) NSString *questionText;
@property (readonly, strong, nonatomic) NSDictionary *jsonDict;


@end
