//
//  POIQuery.m
//  CarControl
//
//  Created by Dan Attali on 1/29/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import "POIQuery.h"
#import "POI.h"

@implementation POIQuery

-(id) init
{
    self.status = 0;
    self.data = [NSMutableData data];
    
    return self;
}


-(void) searchWithNSURLRequest:(NSURLRequest *)request
{
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Query failed : %@", error.localizedDescription);
    self.status = 2;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.data != nil) {
        NSMutableArray *POIs = [[NSMutableArray alloc] init];
        NSError *error = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:&error];
        if (error == nil) {
            self.status = 1;
            NSArray *businesses = [jsonDict objectForKey:@"businesses"];
            for (NSDictionary *business in businesses) {
                POI *poi = [[POI alloc]initWithYelpBusiness:business];
                [POIs addObject:poi];
            }
            self.results = POIs;
        } else {
            NSLog(@"Error decoding JSON [%@]", error.description);
            NSLog(@"**********[%@]*********", [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]);
            self.status = 3;
        }
    } else {
        self.status = 3;
    }
}

@end
