//
//  ContactManager.m
//  CarControl
//
//  Created by Dan Attali on 1/23/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import "ContactManager.h"

@implementation ContactManager

-(id) init {
    
    self = [super init];
    [self isGranted];
    
    return self;
}

//-(void) fillContactListWith:(ABAddressBookRef)addressBook
//{
//    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
//    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
//    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
//    self.contacts = [NSMutableArray arrayWithCapacity:nPeople];
//    for (int i = 0; i < nPeople; i++) {
//        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
//        Contact *contact = [[Contact alloc] init];
//        contact.firstname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
//        contact.lastname =  (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
        
//        contact.firstname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
//        contact.lastname =  (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
//        
//        NSMutableDictionary *phoneNumbers = [[NSMutableDictionary alloc] init];
//        
//        ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
//        if (ABMultiValueGetCount(multiPhones) > 0) {
//            for(CFIndex i=0;i<ABMultiValueGetCount(multiPhones);i++) {
//                CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(multiPhones, i);
//                NSString *phoneLabel = (__bridge NSString *) ABAddressBookCopyLocalizedLabel(locLabel);
//                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
//                NSString *phoneNumber = (__bridge NSString *) phoneNumberRef;
//                [phoneNumbers setObject:phoneNumber forKey:phoneLabel];
//            }
//            contact.phoneNumbers = phoneNumbers;
//            NSLog(@"Contact : %@ %@", contact.firstname, contact.lastname);
//            NSData *contactImageData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
//            contact.avatar = [UIImage imageWithData:contactImageData];
//            [self.contacts addObject:contact];
//        }
//    }
//}

-(Contact *) getContactAtIndex:(NSInteger)index
{
    if (![self isGranted]) {
        return nil;
    }
    ABRecordRef source = ABAddressBookCopyDefaultSource(self.addressBook);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(self.addressBook, source, kABPersonSortByLastName);
    CFIndex nPeople = ABAddressBookGetPersonCount(self.addressBook);
    if (index < nPeople) {
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, index);
        ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        if (ABMultiValueGetCount(multiPhones) > 0) {
            Contact *contact = [[Contact alloc] init];
            contact.firstname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            contact.lastname =  (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
            
            NSMutableDictionary *phoneNumbers = [[NSMutableDictionary alloc] init];
            for(CFIndex i=0;i<ABMultiValueGetCount(multiPhones);i++) {
                CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(multiPhones, i);
                NSString *phoneLabel = (__bridge NSString *) ABAddressBookCopyLocalizedLabel(locLabel);
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                NSString *phoneNumber = (__bridge NSString *) phoneNumberRef;
                if (i == 0) {
                    contact.phoneNumber = phoneNumber;
                    contact.phoneNumberDescription = phoneLabel;
                }
                [phoneNumbers setObject:phoneNumber forKey:phoneLabel];
            }
            contact.phoneNumbers = phoneNumbers;
            NSData *contactImageData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
            contact.avatar = [UIImage imageWithData:contactImageData];
            
            return contact;
        }
    }
    
    if (self.contacts != nil) {
        [self.contacts objectAtIndex:index];
    }
    
    return nil;
}

-(NSInteger) getContactsCount
{
    CFIndex nPeople = ABAddressBookGetPersonCount(self.addressBook);
    
    return nPeople;
}

-(BOOL) isGranted
{
    CFErrorRef *error = nil;
    self.addressBook = ABAddressBookCreateWithOptions(NULL, error);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        return true;
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {});
    }
    
    return false;
}

//-(NSMutableArray *) getContacts
//{
//    if (self.contacts == nil) {
//        CFErrorRef *error = nil;
//        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
//        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
//            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
//                if (granted) {
//                    [self fillContactListWith:(ABAddressBookRef)addressBook];
//                }
//            });
//        } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
//            [self fillContactListWith:(ABAddressBookRef)addressBook];
//        }
//    }
//    
//    return self.contacts;
//}

@end
