//
//  YelpManager.m
//  CarControl
//
//  Created by Dan Attali on 1/28/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import "YelpManager.h"
#import "POI.h"

@implementation YelpManager

#define API_BASE_URL @"api.yelp.com"
#define OAUTH_CONSUMER_KEY @"x0WQ_5H8U0SzvHe5b25hbA"
#define OAUTH_CONSUMER_SECRET @"hlCx1FBPVATWtrEmYbH_T0Qf7Lk"
#define OAUTH_TOKEN @"pimswoMMiNLq4V7ePNp41rXqBQJeYfDp"
#define OAUTH_TOKEN_SECRET @"p2gxZob0xIJ4Wd4bBCUuOGWR0K0"
#define OAUTH_SIGNATURE_METHOD @"hmac-sha1"
#define OAUTH_SIGNATURE @"8RX8Wg79YV8yWyStnkShNLK0ryc="

//servicestations
//parking

-(NSURLRequest *) getRequestForSearchInCategory:(NSString *)category location:(NSString *)location
{
    NSDictionary *dict = @{@"category_filter": category, @"location": location};
    NSURLRequest *request = [GCOAuth URLRequestForPath:@"/v2/search" GETParameters:dict host:API_BASE_URL consumerKey:OAUTH_CONSUMER_KEY consumerSecret:OAUTH_CONSUMER_SECRET accessToken:OAUTH_TOKEN tokenSecret:OAUTH_TOKEN_SECRET];
    
    return request;
}


@end
