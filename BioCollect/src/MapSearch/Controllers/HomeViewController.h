//
//  HomeViewController.h
//  MapView
//
//  Created by Roman Efimov on 10/4/12.
//  Copyright (c) 2012 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKCircleView.h>
#import <CoreLocation/CoreLocation.h>
#import "SettingsViewController.h"
#import "BookmarksViewController.h"
#import "FXForms.h"

@interface HomeViewController : UIViewController <UISearchBarDelegate, MKMapViewDelegate, UIWebViewDelegate, SettingsViewControllerDelegate, BookmarksViewControllerDelegate, CLLocationManagerDelegate> {
    UINavigationBar *_navBar;
    UISearchBar *_searchBar;
    UIToolbar *_toolBar;
    
    
    UIView *_overlayView;
    UIBarButtonItem *_clearButton;
    UIBarButtonItem *_doneButton;
    
    CLGeocoder *_geocoder;
    NSMutableArray *_annotations;
    NSMutableArray *_droppedAnnotations;
    
    UIWebView *_webView;
    
    NSString *_currentURLString;
    
    BOOL _hasPin;
    
    NSMutableArray *_searches;
    CLLocationManager *_locationManager;
}

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) FXFormField *field;
@property (nonatomic, strong) NSMutableDictionary *locationDetails;
@property (nonatomic, strong) CLLocation *clLocation;
@property (nonatomic, strong) NSString *customView; // allowed "". "explore".
@property (strong, nonatomic) MKCircle *circle;
@property (strong, nonatomic) MKMapView *mapView;


@end
