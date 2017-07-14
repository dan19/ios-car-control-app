//
//  Contact.h
//  CarControl
//
//  Created by Dan Attali on 1/19/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic, readwrite) NSString *firstname;
@property (nonatomic, readwrite) NSString *lastname;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *phoneNumberDescription;

@property (nonatomic, readwrite) NSMutableDictionary *phoneNumbers;
@property (nonatomic, readwrite) UIImage *avatar;

@end
