//
//  FKFlickrTagsGetHotList.h
//  FlickrKit
//
//  Generated by FKAPIBuilder on 19 Sep, 2014 at 10:49.
//  Copyright (c) 2013 DevedUp Ltd. All rights reserved. http://www.devedup.com
//
//  DO NOT MODIFY THIS FILE - IT IS MACHINE GENERATED


#import "FKFlickrAPIMethod.h"

typedef enum {
	FKFlickrTagsGetHotListError_InvalidPeriod = 1,		 /* The specified period was not understood. */
	FKFlickrTagsGetHotListError_InvalidAPIKey = 100,		 /* The API key passed was not valid or has expired. */
	FKFlickrTagsGetHotListError_ServiceCurrentlyUnavailable = 105,		 /* The requested service is temporarily unavailable. */
	FKFlickrTagsGetHotListError_WriteOperationFailed = 106,		 /* The requested operation failed due to a temporary issue. */
	FKFlickrTagsGetHotListError_FormatXXXNotFound = 111,		 /* The requested response format was not found. */
	FKFlickrTagsGetHotListError_MethodXXXNotFound = 112,		 /* The requested method was not found. */
	FKFlickrTagsGetHotListError_InvalidSOAPEnvelope = 114,		 /* The SOAP envelope send in the request could not be parsed. */
	FKFlickrTagsGetHotListError_InvalidXMLRPCMethodCall = 115,		 /* The XML-RPC request document could not be parsed. */
	FKFlickrTagsGetHotListError_BadURLFound = 116,		 /* One or more arguments contained a URL that has been used for abuse on Flickr. */

} FKFlickrTagsGetHotListError;

/*

Returns a list of hot tags for the given period.


Response:

<hottags period="day" count="6">
	<tag score="20">northerncalifornia</tag>
	<tag score="18">top20</tag>
	<tag score="15">keychain</tag>
	<tag score="10">zb</tag>
	<tag score="9">selfportraittuesday</tag>
	<tag score="4">jan06</tag>
</hottags>

*/
@interface FKFlickrTagsGetHotList : NSObject <FKFlickrAPIMethod>

/* The period for which to fetch hot tags. Valid values are <code>day</code> and <code>week</code> (defaults to <code>day</code>). */
@property (nonatomic, copy) NSString *period;

/* The number of tags to return. Defaults to 20. Maximum allowed value is 200. */
@property (nonatomic, copy) NSString *count;


@end
