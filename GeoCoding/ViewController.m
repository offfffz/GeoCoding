//
//  ViewController.m
//  GeoCoding
//
//  Created by offz on 3/24/2557 BE.
//  Copyright (c) 2557 off. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *latField;
@property (weak, nonatomic) IBOutlet UITextField *lonField;
@property (weak, nonatomic) IBOutlet UITextView *resultField;

@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation ViewController

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 500;
    }
    
    return _locationManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reverseGeoCoderClicked:(id)sender {
    
    [self reverseGeoCodingWithLatitude:[self.latField.text floatValue] Longitude:[self.lonField.text floatValue]];
    
}

- (IBAction)useCurrentLocationClicked:(id)sender {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[self locationManager] startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    
    if (location.horizontalAccuracy < 1000) {
        [manager stopUpdatingLocation];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        self.latField.text = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        self.lonField.text = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
        [self reverseGeoCodingWithLatitude:location.coordinate.latitude
                                 Longitude:location.coordinate.longitude];
    }
}

- (void)reverseGeoCodingWithLatitude:(float)latitude Longitude:(float)longitude {
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude
                                                      longitude:longitude];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks lastObject];
        self.resultField.text = [[placemark addressDictionary] description];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

@end
