//
//  NUSurveyorIOSTests.m
//  NUSurveyorIOSTests
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NUSurveyorIOSTests.h"
#import "UUID.h"
#import "NUSectionVC.h"
#import "SurveyorDatePickerAnswerCell.h"
#import "SBJson.h"
#import "NUResponseSet.h"

@implementation NUSurveyorIOSTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testUUID{
  NSString *str = [UUID generateUuidString];
  STAssertEquals([str length], (NSUInteger)36, @"UUID length should be 36");
}

- (void)testClassForQuestion{
  NSDictionary *questionOrGroup = [[NSDictionary alloc] init];
  NSDictionary *answer = [[NSDictionary alloc] init];
  STAssertEquals(NSClassFromString(@"SurveyorNoneAnswerCell"), [NUSectionVC classForQuestion:questionOrGroup answer:answer], @"The default case");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"none", @"pick", nil];
  answer = nil;
  STAssertEquals(NSClassFromString(@"SurveyorNoneAnswerCell"), [NUSectionVC classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorNoneAnswerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"none", @"pick", nil];
  answer = [NSDictionary dictionaryWithObjectsAndKeys:@"text", @"type", nil];
  STAssertEquals(NSClassFromString(@"SurveyorNoneTextAnswerCell"), [NUSectionVC classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorNoneTextAnswerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"one", @"pick", nil];
  answer = nil;
  STAssertEquals(NSClassFromString(@"SurveyorOneAnswerCell"), [NUSectionVC classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorOneAnswerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"any", @"pick", nil];
  answer = nil;
  STAssertEquals(NSClassFromString(@"SurveyorAnyAnswerCell"), [NUSectionVC classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorAnyAnswerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"one", @"pick", @"dropdown", @"type", nil];
  answer = nil;
  STAssertEquals(NSClassFromString(@"SurveyorPickerAnswerCell"), [NUSectionVC classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorPickerAnswerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"none", @"pick", nil];
  answer = [NSDictionary dictionaryWithObjectsAndKeys:@"date", @"type", nil];
  STAssertEquals(NSClassFromString(@"SurveyorDatePickerAnswerCell"), [NUSectionVC classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorDatePickerAnswerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"none", @"pick", nil];
  answer = [NSDictionary dictionaryWithObjectsAndKeys:@"datetime", @"type", nil];
  STAssertEquals(NSClassFromString(@"SurveyorDatePickerAnswerCell"), [NUSectionVC classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorDatePickerAnswerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"none", @"pick", nil];
  answer = [NSDictionary dictionaryWithObjectsAndKeys:@"time", @"type", nil];
  STAssertEquals(NSClassFromString(@"SurveyorDatePickerAnswerCell"), [NUSectionVC classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorDatePickerAnswerCell");
}

- (void) testDatePickerModeFromType {
  SurveyorDatePickerAnswerCell *cell = [[SurveyorDatePickerAnswerCell alloc] init];
  STAssertEquals([cell datePickerModeFromType:@"datetime"], UIDatePickerModeDateAndTime, @"date and time");
  STAssertEquals([cell datePickerModeFromType:@"date"], UIDatePickerModeDate, @"date");
  STAssertEquals([cell datePickerModeFromType:@"time"], UIDatePickerModeTime, @"time");
  STAssertEquals([cell datePickerModeFromType:@""], UIDatePickerModeDate, @"empty string");
  STAssertEquals([cell datePickerModeFromType:nil], UIDatePickerModeDate, @"nil case");
}

- (void) testDependencyGraph {
  // JSON data
	NSError *strError;
	NSString *strPath = [[NSBundle mainBundle] pathForResource:@"kitchen-sink-survey" ofType:@"json"];
  NSString *responseString = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&strError];
  SBJsonParser *parser = [[SBJsonParser alloc] init];
  NSDictionary *dict = [[parser objectWithString:responseString] retain];
  
  NUResponseSet *rs = [NUResponseSet newResponseSetForSurvey:[dict objectForKey:@"survey"]];
  
  NSArray *input = [rs.dependencyGraph objectForKey:@"deec7160-e5f8-012e-9f18-00254bc472f4"];
  NSArray *output = [NSArray arrayWithObjects:@"deecf720-e5f8-012e-9f18-00254bc472f4", @"deef2410-e5f8-012e-9f18-00254bc472f4", nil];
  STAssertTrue([output isEqualToArray:input], @"NUResponseSet Dependency on disliked colors");

  input = [rs.dependencyGraph objectForKey:@"deef7b20-e5f8-012e-9f18-00254bc472f4"];
  output = [NSArray arrayWithObjects:@"deefaa40-e5f8-012e-9f18-00254bc472f4", nil];
  STAssertTrue([output isEqualToArray:input], @"NUResponseSet Dependency on Arthur, King of the Britons");

  input = [rs.dependencyGraph objectForKey:@"deefaa40-e5f8-012e-9f18-00254bc472f4"];
  output = [NSArray arrayWithObjects:@"deeff7b0-e5f8-012e-9f18-00254bc472f4", nil];
  STAssertTrue([output isEqualToArray:input], @"NUResponseSet Dependency on quest");
  
  input = [rs.dependencyGraph objectForKey:@"deeff7b0-e5f8-012e-9f18-00254bc472f4"];
  output = [NSArray arrayWithObjects:@"def04360-e5f8-012e-9f18-00254bc472f4", nil];
  STAssertTrue([output isEqualToArray:input], @"NUResponseSet Dependency on airspeed of a swallow");
  
}
- (void) testAnswerDependency {
  // JSON data
	NSError *strError;
	NSString *strPath = [[NSBundle mainBundle] pathForResource:@"kitchen-sink-survey" ofType:@"json"];
  NSString *responseString = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&strError];
  SBJsonParser *parser = [[SBJsonParser alloc] init];
  NSDictionary *dict = [parser objectWithString:responseString];
  
  NUResponseSet *rs = [NUResponseSet newResponseSetForSurvey:[dict objectForKey:@"survey"]];
  [rs newResponseForIndexQuestion:@"deec7160-e5f8-012e-9f18-00254bc472f4" Answer:@"deecb340-e5f8-012e-9f18-00254bc472f4"]; // disliking green
  NSDictionary *input = [rs dependenciesTriggeredBy:@"deec7160-e5f8-012e-9f18-00254bc472f4"];
	NSArray *outputHide = [[[NSArray alloc] initWithObjects:@"deef2410-e5f8-012e-9f18-00254bc472f4", nil] autorelease];
  NSArray *outputShow = [[[NSArray alloc] initWithObjects:@"deecf720-e5f8-012e-9f18-00254bc472f4", nil] autorelease];
  
  STAssertTrue([[input valueForKey:@"hide"] isEqualToArray:outputHide], @"NUResponseSet Dependency on disliking green, why so many hidden");
  NSLog(@"%@", input);
  STAssertTrue([[input valueForKey:@"show"] isEqualToArray:outputShow], @"NUResponseSet Dependency on disliking green shows explanation");
}
- (void) testCountDependency {
  // JSON data
  NSError *strError;
  NSString *strPath = [[NSBundle mainBundle] pathForResource:@"kitchen-sink-survey" ofType:@"json"];
  NSString *responseString = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&strError];
  SBJsonParser *parser = [[SBJsonParser alloc] init];
  NSDictionary *dict = [[parser objectWithString:responseString] retain];
  
  NUResponseSet *rs = [NUResponseSet newResponseSetForSurvey:[dict objectForKey:@"survey"]];
	[rs newResponseForIndexQuestion:@"deec7160-e5f8-012e-9f18-00254bc472f4" Answer:@"deec8930-e5f8-012e-9f18-00254bc472f4"]; // disliking red
	[rs newResponseForIndexQuestion:@"deec7160-e5f8-012e-9f18-00254bc472f4" Answer:@"deec9e70-e5f8-012e-9f18-00254bc472f4"]; // disliking blue
	[rs newResponseForIndexQuestion:@"deec7160-e5f8-012e-9f18-00254bc472f4" Answer:@"deecb340-e5f8-012e-9f18-00254bc472f4"]; // disliking green
  NSDictionary *input = [rs dependenciesTriggeredBy:@"deec7160-e5f8-012e-9f18-00254bc472f4"];
	NSArray *outputHide = [[NSArray alloc] init];
  NSArray *outputShow = [[NSArray alloc] initWithObjects:@"deecf720-e5f8-012e-9f18-00254bc472f4", @"deef2410-e5f8-012e-9f18-00254bc472f4", nil];
  
  STAssertTrue([[input valueForKey:@"hide"] isEqualToArray:outputHide], @"NUResponseSet Dependency on disliking rgb, why so many not hidden");
  NSLog(@"%@", input);
  STAssertTrue([[input valueForKey:@"show"] isEqualToArray:outputShow], @"NUResponseSet Dependency on disliking rgb shows explanation, why so many");
}
                
@end
