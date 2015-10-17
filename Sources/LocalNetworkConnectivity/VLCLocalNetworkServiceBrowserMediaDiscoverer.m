/*****************************************************************************
 * VLCLocalNetworkServiceBrowserMediaDiscoverer.m
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2015 VideoLAN. All rights reserved.
 * $Id$
 *
 * Authors: Tobias Conradi <videolan # tobias-conradi.de>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/


#import "VLCLocalNetworkServiceBrowserMediaDiscoverer.h"

@interface VLCLocalNetworkServiceBrowserMediaDiscoverer () <VLCMediaListDelegate>

@end
@implementation VLCLocalNetworkServiceBrowserMediaDiscoverer
@synthesize name = _name;

- (instancetype)initWithName:(NSString *)name serviceServiceName:(NSString *)serviceName
{
    self = [super init];
    if (self) {
        _name = name;
        _serviceName = serviceName;
        _mediaDiscoverer = [[VLCMediaDiscoverer alloc] initWithName:serviceName];
        _mediaDiscoverer.discoveredMedia.delegate = self;
    }
    return self;
}

- (void)startDiscovery
{
    [self.mediaDiscoverer startDiscoverer];
}

- (void)stopDiscovery
{
    [self.mediaDiscoverer stopDiscoverer];
}

- (NSUInteger)numberOfItems {
    return self.mediaDiscoverer.discoveredMedia.count;
}
- (id<VLCLocalNetworkService>)networkServiceForIndex:(NSUInteger)index {
    VLCMedia *media = [self.mediaDiscoverer.discoveredMedia mediaAtIndex:index];
    return [[VLCLocalNetworkServiceVLCMedia alloc] initWithMediaItem:media];
}

#pragma mark - VLCMediaListDelegate
- (void)mediaList:(VLCMediaList *)aMediaList mediaAdded:(VLCMedia *)media atIndex:(NSInteger)index
{
    [self.delegate localNetworkServiceBrowserDidUpdateServices:self];
}
- (void)mediaList:(VLCMediaList *)aMediaList mediaRemovedAtIndex:(NSInteger)index
{
    [self.delegate localNetworkServiceBrowserDidUpdateServices:self];
}

@end


#pragma mark - service specific subclasses

@implementation VLCLocalNetworkServiceBrowserSAP

- (instancetype)init {
    return [super initWithName:@"SAP"
     serviceServiceName:@"sap"];
}

- (id<VLCLocalNetworkService>)networkServiceForIndex:(NSUInteger)index {
    VLCMedia *media = [self.mediaDiscoverer.discoveredMedia mediaAtIndex:index];
    return [[VLCLocalNetworkServiceSAP alloc] initWithMediaItem:media];
}

@end

@implementation VLCLocalNetworkServiceBrowserDSM

- (instancetype)init {
    return [super initWithName:NSLocalizedString(@"SMB_CIFS_FILE_SERVERS", nil)
            serviceServiceName:@"dsm"];
}
- (id<VLCLocalNetworkService>)networkServiceForIndex:(NSUInteger)index {
    VLCMedia *media = [self.mediaDiscoverer.discoveredMedia mediaAtIndex:index];
    return [[VLCLocalNetworkServiceDSM alloc] initWithMediaItem:media];
}

@end