//
//  SVPullToRefreshTests.m
//  SVPullToRefreshTests
//
//  Created by Rodolfo Wilhelmy on 9/12/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface SVPullToRefreshTests : SenTestCase

@end

#import "SVPullToRefresh.h"

@implementation SVPullToRefreshTests

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

- (void)testNavigationPushDoesNotCorruptPullToRefreshView
{
    UITableViewController *controller = [[UITableViewController alloc] init];
    STAssertNotNil(controller.tableView, @"Should set table view correctly");

    [controller.tableView addPullToRefreshWithActionHandler:^{
        NSLog(@"I'm the handler");
    }];
    STAssertNotNil(controller.tableView.pullToRefreshView,
                   @"Should add pull to refresh view to controller's tableview");
    
    UITableViewController *otherController = [[UITableViewController alloc] init];
    [otherController.tableView addPullToRefreshWithActionHandler:^{
        NSLog(@"I'm the other handler");
    }];
    STAssertNotNil(otherController.tableView.pullToRefreshView,
                   @"Should add pull to refresh view to otherController's tableview");
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
    STAssertNotNil(controller.navigationController, @"Should set up navigation controller correctly");
    
    [controller.navigationController pushViewController:otherController animated:NO];
    STAssertTrue([navigation.viewControllers count] == 2, @"Should have 2 controllers");
    
    CGRect pullToRefreshFrame = controller.tableView.pullToRefreshView.frame;
    STAssertTrue(pullToRefreshFrame.size.height != 0, @"Should persist pull to refresh frame");
    
    [otherController.navigationController popViewControllerAnimated:NO];
    STAssertTrue([navigation.viewControllers count] == 1, @"Should have 2 controllers");

    CGRect pullToRefreshAfterFrame = controller.tableView.pullToRefreshView.frame;
    STAssertTrue(CGSizeEqualToSize(pullToRefreshAfterFrame.size, pullToRefreshFrame.size),
                 @"Should keep the frame of the original pull to refresh view in the first controller");
}

@end
