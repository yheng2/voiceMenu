//
//  Voice+CoreDataProperties.h
//  
//
//  Created by Wufei Lai on 10/14/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Voice.h"

NS_ASSUME_NONNULL_BEGIN

@interface Voice (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSString *nameNumber;

@end

NS_ASSUME_NONNULL_END
