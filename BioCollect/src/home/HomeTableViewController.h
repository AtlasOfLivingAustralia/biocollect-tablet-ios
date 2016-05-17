//
//  HomeTableViewController.h
//  BioCollect
//
//  Created by Sathish Babu Sathyamoorthy on 3/03/2016.
//  Copyright © 2016 Sathya Moorthy, Sathish (Atlas of Living Australia). All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GAAppDelegate.h"
#import "BioProjectService.h"
#import "UIImageView+WebCache.h"
#import "RecordsTableViewController.h"

@interface HomeTableViewController :  UITableViewController <UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *homeTableView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

//Pagination info.
@property (nonatomic, strong) NSString * query;
@property (nonatomic, assign) NSInteger totalProjects;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) BOOL loadingFinished;

//Search flag
@property (nonatomic, assign) BOOL isSearching;

@property (nonatomic, strong) GAAppDelegate *appDelegate;
@property (nonatomic, strong) BioProjectService *bioProjectService;
@property (nonatomic, strong) RecordsTableViewController *recordsTableView;
@property (nonatomic, strong) NSMutableArray * bioProjects;
-(void) resetProjects;

@end

