@import Foundation;

#import "BTPaymentMethod.h"

/// A payment method returned by the Client API that represents a Coinbase account associated with
/// a particular Braintree customer.
///
/// @see BTPaymentMethod
/// @see BTMutablePayPalPaymentMethod
@interface BTCoinbasePaymentMethod : BTPaymentMethod

/// The email address associated with the Coinbase account.
@property (nonatomic, readonly, copy) NSString *email;

@end
