//
//  ContactManager.h
//  CarControl
//
//  Created by Dan Attali on 1/23/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "Contact.h"

@interface ContactManager : NSObject

@property NSMutableArray *contacts;
@property ABAddressBookRef addressBook;

//-(NSMutableArray *) getContacts;
-(Contact *) getContactAtIndex:(NSInteger)index;
-(NSInteger) getContactsCount;


@end
