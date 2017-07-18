//
//  BNHTTPResponseSerializer.h
//  Copyright (c) 2016 Bambora ( http://bambora.com/ )
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

@import Foundation;

extern NSString * const BNResponseSerializationErrorDataString;

@interface BNHTTPResponseSerializer : NSObject

/**
 *  Creates a response object from a `NSURLResponse`.
 *  `BNHTTPResponseSerializer` only supports JSON serialization at the moment.
 *
 *  @param response `NSURLResponse` to be serialized.
 *  @param data     `NSData` to be decoded to a responseObject.
 *  @param error    `NSError` representing an eventual error during the serialization.
 *
 *  @return A response object decoded from the data.
 */
- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError **)error;

/**
 *  Extract the 'Detail' property from the backend response
 *
 *  @param error 'NSError' returned after calling the backend
 *
 *  @return Human readbale error message from the backend.
 */
+(NSString*) extractErrorDetail:(NSError*) error;


@end
