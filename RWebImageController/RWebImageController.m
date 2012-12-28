//
//  RWebImageController.m
//  VMovier
//
//  Created by Alex Rezit on 19/12/2012.
//  Copyright (c) 2012 Seymour Dev. All rights reserved.
//

#import <sqlite3.h>
#import "RWebImageController.h"

#define kRWebImageDirectory @"RWebImage"
#define kRWebImageDatabaseFilename @"RWebImage.sqlite"
#define kRWebImageDatabaseTableName @"IMAGE"

@interface RWebImageController ()

@property (nonatomic, assign) sqlite3 *database;

- (void)createDirectory;
- (NSString *)pathForDatabaseFile;
- (NSString *)pathForImageWithHash:(NSString *)hash;

- (void)loadDatabase;
- (void)closeDatabase;
- (void)createTable;

- (void)addEntryForImageURL:(NSURL *)url withHash:(NSString *)hash;
- (NSString *)pathForImageWithURL:(NSURL *)url;

- (BOOL)fetchImageFromURL:(NSURL *)url;

@end

@implementation RWebImageController

@synthesize database;

- (UIImage *)getImageFromURL:(NSURL *)url
{
    NSString *path = nil;
    switch (self.mode) {
        case RWebImageControllerModeDefault:
            path = [self pathForImageWithURL:url];
            if (!path) {
                if ([self fetchImageFromURL:url]) {
                    path = [self pathForImageWithURL:url];
                }
            }
            break;
        case RWebImageControllerModeForceRefresh:
            if ([self fetchImageFromURL:url]) {
                path = [self pathForImageWithURL:url];
            }
            break;
        case RWebImageControllerModeOfflineOnly:
            path = [self pathForImageWithURL:url];
            break;
        default:
            break;
    }
    NSData *imageData = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}

- (void)getImageFromURL:(NSURL *)url completion:(void (^)(UIImage *))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self getImageFromURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    });
}

- (UIImage *)getImageFromURL:(NSURL *)url forceRefresh:(BOOL)forceRefresh
{
    NSString *path = nil;
    if (forceRefresh) {
        if ([self fetchImageFromURL:url]) {
            path = [self pathForImageWithURL:url];
        }
    } else {
        path = [self pathForImageWithURL:url];
        if (!path) {
            if ([self fetchImageFromURL:url]) {
                path = [self pathForImageWithURL:url];
            }
        }
    }
    NSData *imageData = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}

- (void)getImageFromURL:(NSURL *)url forceRefresh:(BOOL)forceRefresh completion:(void (^)(UIImage *image))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self getImageFromURL:url forceRefresh:forceRefresh];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    });
}

#pragma mark - Database control

- (void)createDirectory
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = documentPaths[0];
    NSString *imageDirectory = [documentDirectory stringByAppendingPathComponent:kRWebImageDirectory];
    BOOL isDirectory = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:imageDirectory isDirectory:&isDirectory] ||
        !isDirectory) {
        [fileManager removeItemAtPath:imageDirectory error:nil];
        [fileManager createDirectoryAtPath:imageDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    }
}

- (NSString *)pathForDatabaseFile
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = documentPaths[0];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:kRWebImageDatabaseFilename];
    return filePath;
}

- (NSString *)pathForImageWithHash:(NSString *)hash
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = documentPaths[0];
    NSString *filePath = [[documentDirectory stringByAppendingPathComponent:kRWebImageDirectory] stringByAppendingPathComponent:hash];
    return filePath;
}

- (void)loadDatabase
{
    if (sqlite3_open(self.pathForDatabaseFile.UTF8String, &database) != SQLITE_OK) {
        [self closeDatabase];
        NSAssert(0, @"Failed to open database.");
    }
}

- (void)closeDatabase
{
    sqlite3_close(database);
}

- (void)createTable
{
    NSString *create = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (HASH TEXT UNIQUE PRIMARY KEY, URL TEXT);", kRWebImageDatabaseTableName];
    dispatch_async(_operationQueue, ^{
        char *error;
        if (sqlite3_exec(database, create.UTF8String, NULL, NULL, &error) != SQLITE_OK) {
            NSAssert1(0, @"Error creating table: %s", error);
        }
    });
}

- (void)addEntryForImageURL:(NSURL *)url withHash:(NSString *)hash
{
    void (^ __block writeBlock)() = Block_copy(^{
        NSString *update = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (HASH, URL) VALUES (?, ?);", kRWebImageDatabaseTableName];
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(database, update.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
            sqlite3_bind_text(stmt, 1, hash.UTF8String, -1, NULL);
            sqlite3_bind_text(stmt, 2, url.absoluteString.UTF8String, -1, NULL);
        }
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            NSAssert(0, @"Error updating image.");
        }
        sqlite3_finalize(stmt);
    });
    dispatch_async(_operationQueue, writeBlock);
}

- (NSString *)pathForImageWithURL:(NSURL *)url
{
    __block NSString *hash = nil;
    void (^ __block readBlock)() = Block_copy(^{
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE URL = ?", kRWebImageDatabaseTableName];
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(database, query.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
            sqlite3_bind_text(stmt, 1, url.absoluteString.UTF8String, -1, NULL);
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                hash = @((char *)sqlite3_column_text(stmt, 0));
            }
        } else {
            NSAssert(0, @"Error querying image.");
        }
    });
    dispatch_sync(_operationQueue, readBlock);
    NSString *path = nil;
    if (hash) {
        path = [self pathForImageWithHash:hash];
    } else {
        path = nil;
    }
    return path;
}

- (BOOL)fetchImageFromURL:(NSURL *)url
{
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    if (image) {
        NSString *hash = @(url.absoluteString.hash).stringValue;
        [self addEntryForImageURL:url withHash:hash];
        [imageData writeToFile:[self pathForImageWithHash:hash] atomically:NO];
        return YES;
    }
    return NO;
}

#pragma mark - Life cycle

static RWebImageController *_sharedController = nil;
static dispatch_queue_t _operationQueue;

+ (RWebImageController *)sharedController
{
    if (!_sharedController) {
        _sharedController = [[self alloc] init];
    }
    return _sharedController;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.mode = RWebImageControllerModeDefault;
        _operationQueue = dispatch_queue_create("com.seymourdev.rwebimage.sqlite", NULL);
        [self createDirectory];
        [self loadDatabase];
        [self createTable];
    }
    return self;
}

- (void)dealloc
{
    dispatch_release(_operationQueue);
    [self closeDatabase];
    [super dealloc];
}

@end
