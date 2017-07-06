//
//  OzHomeVC.m
//  Oz Atlas
//
//  Created by Sathish Babu Sathyamoorthy on 14/10/16.
//  Copyright © 2016 Sathya Moorthy, Sathish (CSIRO IM&T, Clayton). All rights reserved.
//

//
//  MGViewController.m
//  MGSpotyView
//
//  Created by Matteo Gobbi on 25/06/2014.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import "OzHomeVC.h"
#import "MGSpotyViewControllerDelegate.h"
#import "GAAppDelegate.h"
#import "GASettings.h"
#import "OzHomeVCDelegate.h"
#import "OzHomeVCDataSource.h"
#import "RecordViewController.h"

@interface OzHomeVC ()

@end

@implementation OzHomeVC {
    OzHomeVCDelegate *delegate_;
    OzHomeVCDataSource *dataSource_;
}

- (instancetype)initWithMainImage:(UIImage *)image
{
    self = [super initWithMainImage:image tableScrollingType:MGSpotyViewTableScrollingTypeNormal]; //or MGSpotyViewTableScrollingTypeOver
    if (self) {
        dataSource_ = [OzHomeVCDataSource new];
        delegate_ = [OzHomeVCDelegate new];
        
        self.overViewUpFadeOut = YES;
        self.blurRadius = 8.f;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = dataSource_;
    self.delegate = delegate_;
    [self navigationController].delegate = self;
    //[self.navigationController setNavigationBarHidden:TRUE];
    [self setOverView:self.myOverView];
    
   
}

- (UIView *)myOverView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.overView.frame.size.width, 250)];
    [self mg_addElementOnView:view];
    return view;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(viewController == self)
    {
        if( ![self navigationController].navigationBarHidden)
        {
            [[self navigationController] setNavigationBarHidden:YES animated:YES];
        }
    }
    else
    {
        if([self navigationController].navigationBarHidden)
        {
            [[self navigationController] setNavigationBarHidden:NO animated:YES];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Private methods

- (void)mg_addElementOnView:(UIView *)view
{
    NSString *firstname = [GASettings getFirstName];
    NSString *displayName = nil;
    if([firstname length] > 14) {
        displayName = [[NSString alloc]initWithFormat:@"G'Day %@...",[firstname substringToIndex: MIN(14, [firstname length])]];
    } else {
        displayName = [[NSString alloc]initWithFormat:@"G'Day %@",firstname ? firstname : @""];
    }

    //Add an example imageView
    UIView *itemsContainer = [UIView new];
    itemsContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:itemsContainer];
    
    UIImageView *imageView = [UIImageView new];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    [imageView setImage:[UIImage imageNamed:@"OzHome2"]];
    [imageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [imageView.layer setBorderWidth:2.0];
    [imageView.layer setCornerRadius:45.0];
    imageView.userInteractionEnabled = YES;
    [itemsContainer addSubview:imageView];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [imageView addGestureRecognizer:tapRecognizer];
    
    
    //Add an example label
    UILabel *lblTitle = [UILabel new];
    lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [lblTitle setText:displayName];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:25.0]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setTextColor:[UIColor whiteColor]];
    lblTitle.numberOfLines = 0;
    lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [itemsContainer addSubview:lblTitle];
    
    
    //Add an example button
    UIButton *btContact = [UIButton buttonWithType:UIButtonTypeCustom];
    btContact.translatesAutoresizingMaskIntoConstraints = NO;
    [btContact setTitle:@"Logout" forState:UIControlStateNormal];
    [btContact addTarget:self action:@selector(actionContact:) forControlEvents:UIControlEventTouchUpInside];
    btContact.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:77.0/255.0 blue:47.0/255.0 alpha:1];
    btContact.titleLabel.font = [UIFont fontWithName:@"Verdana" size:12.0];
    btContact.layer.cornerRadius = 5.0;
    [itemsContainer addSubview:btContact];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:itemsContainer attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:itemsContainer attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    NSDictionary *items = NSDictionaryOfVariableBindings(imageView, lblTitle, btContact);
    [items enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [itemsContainer addConstraint:[NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:itemsContainer attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    }];
    
    [itemsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView(90)]" options:0 metrics:nil views:items]];
    [itemsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[btContact(70)]" options:0 metrics:nil views:items]];
    [itemsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[lblTitle]-10-|" options:0 metrics:nil views:items]];
    
    [itemsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView(90)]-10-[lblTitle]-10-[btContact(30)]|" options:0 metrics:nil views:items]];
}


#pragma mark - Action

- (void)actionContact:(id)sender
{
    GAAppDelegate *appDelegate = (GAAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.loginViewController logout];
}


#pragma mark - Gesture recognizer

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        RecordViewController *recordViewController = [[RecordViewController alloc] init];
        recordViewController.title = @"Record Species";
        [self.navigationController pushViewController:recordViewController animated:TRUE];
    }
}



@end
