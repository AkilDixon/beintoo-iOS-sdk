/*******************************************************************************
 * Copyright 2011 Beintoo - author fmessina@beintoo.com
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/

#import <UIKit/UIKit.h>
#import "BeintooDevice.h"

int main(int argc, char *argv[]) {
    
#ifdef BEINTOO_ARC_AVAILABLE
    @autoreleasepool {
#else
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
#endif
    
    int retVal = UIApplicationMain(argc, argv, nil, nil);
        
#ifdef BEINTOO_ARC_AVAILABLE
        return retVal;
    }
#else
    [pool release];
    return retVal;
#endif
    
    
}
