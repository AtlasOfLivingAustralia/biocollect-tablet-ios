//
//  SpeciesListService.m
//  Oz Atlas

#import <Foundation/Foundation.h>
#import "SpeciesListService.h"
#import "GASettingsConstant.h"
#import "SpeciesJSON.h"
#import "Species.h"
#import "GASettings.h"
#import "GAAppDelegate.h"

@interface SpeciesListService ()
@property (nonatomic, strong) NSURL *speciesFileUrlPath;
@property (nonatomic, retain) NSMutableArray *speciesList;
@property (strong, nonatomic) GAAppDelegate *appDelegate;
@end

@implementation SpeciesListService
#define kSpeciesListKey @"SpeciesListKey"
#define kTracksSpeciesStorageLocation @"TRACKS_SPECIES_LIST_1"

@synthesize speciesList;

-(id) init {
    self.speciesList = [[NSMutableArray alloc]init];
    NSArray<NSURL *> *urls = [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains: NSUserDomainMask];
    if([urls count] > 0){
        self.speciesFileUrlPath = [urls[0] URLByAppendingPathComponent:kTracksSpeciesStorageLocation];
    }
    NSError *error;
    self.appDelegate = (GAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(![[self.appDelegate restCall] notReachable]) {
        [self getSpeciesFromList:&error];
    }
    
    return self;
}

- (void) getSpeciesFromList : (NSError**) error {
    NSString *listUrl = [GASettings appLoadSpeciesListUrl];
    if (listUrl == (id)[NSNull null] || listUrl.length == 0 ) {
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *url = [[NSString alloc] initWithFormat: @"%@%@", LISTS_SERVER, listUrl];
    NSString *escapedUrlString =[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [request setURL:[NSURL URLWithString:escapedUrlString]];
    [request setHTTPMethod:@"GET"];
    NSURLResponse *response;
    
    NSData *nsData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&*error];
    if(*error == nil) {
        self.speciesList = [[NSMutableArray alloc] init];
        SpeciesJSON  *speciesJSON = [[SpeciesJSON alloc] initWithData:nsData];
        while([speciesJSON hasNext]) {
            [speciesJSON nextSpecies];
            Species *speciesObj = [[Species alloc] init];
            speciesObj.speciesListId = speciesJSON.speciesListId;
            speciesObj.name = speciesJSON.name;
            speciesObj.commonName = speciesJSON.commonName;
            speciesObj.scientificName = speciesJSON.scientificName;
            speciesObj.lsid = speciesJSON.lsid;
            speciesObj.kvpValues = speciesJSON.kvpValues;
            [speciesList addObject:speciesObj];
        }
        // No Animal Found
        Species *speciesObj = [[Species alloc] init];
        speciesObj.speciesListId = @"noAnimalFound";
        speciesObj.name = @"No Animal Found";
        speciesObj.commonName = @"";
        speciesObj.scientificName = @"";
        speciesObj.lsid = @"noAnimalFound";
        speciesObj.kvpValues = [[NSArray alloc]init];
        [speciesList addObject:speciesObj];
        
        [self storeSpeciesList];
    }
}

-(BOOL) storeSpeciesList {
    [self updateDisplayName];
    
    //Sort by display name
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayName"
                                                 ascending:YES];
    NSArray *sortedArray = [self.speciesList sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    BOOL archived = [NSKeyedArchiver archiveRootObject: sortedArray toFile: self.speciesFileUrlPath.path];
    if (!archived) {
        NSLog(@"Failed to load species from local storage.");
    }
    return archived;
}

- (NSMutableArray *) loadSpeciesList {
    NSArray<Species*> *speciesObj = [NSKeyedUnarchiver unarchiveObjectWithFile: self.speciesFileUrlPath.path];
    [self.speciesList removeAllObjects];
    [self.speciesList addObjectsFromArray:speciesObj];
    
    if([self.speciesList count] == 0) {
        NSError *error;
        [self getSpeciesFromList:&error];
    }
    
    return [self speciesList];
}

-(void) updateDisplayName {
    NSString *language = [self.appDelegate.locale getLanguage];
    for(int i = 0; i<  [self.speciesList count]; i++) {
        Species *species = self.speciesList[i];
        species.displayName = @"No Animal Found";
        
        for(int j = 0; j < [species.kvpValues count]; j++) {
            NSDictionary *kvp = species.kvpValues[j];
            if([language isEqualToString:@"en"] && [kvp[@"key"] isEqualToString:@"vernacular name"]) {
                species.displayName = kvp[@"value"];
                break;
            } else if([language isEqualToString:@"walpiri"] && [kvp[@"key"] isEqualToString:@"Warlpiri name"]) {
                species.displayName = kvp[@"value"];
                break;
            } else if([language isEqualToString:@"warumungu"] && [kvp[@"key"] isEqualToString:@"Waramungu"]) {
                species.displayName = kvp[@"value"];
                break;
            }
        }
    }
}

@end
