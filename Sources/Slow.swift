//
//  Limit.swift
//  SwiM
//
//  Created by Cory Alder on 2016-04-19.
//  Copyright © 2016 Cory Alder. All rights reserved.
//

import Foundation

public class Slow {
    
    // based on https://github.com/Spaceman-Labs/Dispatch-Cancel/blob/master/dispatch-cancel/SpacemanBlocks.h
    
    public typealias DelayedBlock = (Bool)->(Void)
    
    let queue: dispatch_queue_t // queue ops will run on
    let interval: NSTimeInterval // delay on ops
    var previous: DelayedBlock? // the previously enqueued op
    
    public init(interval: NSTimeInterval, queue: dispatch_queue_t = dispatch_get_main_queue()) {
        self.interval = interval
        self.queue = queue
    }
    
    
    public func run(closure: (Void)->(Void)) {
        
        if let previous = previous {
            previous(true) // kill previous
        }
        
        previous = self.dynamicType.cancellable_perform(delay: self.interval, queue: self.queue, closure: closure)
    }
    
    public static func cancellable_perform(delay: NSTimeInterval, queue: dispatch_queue_t = dispatch_get_main_queue(), closure:(Void)->(Void)) -> DelayedBlock {
        
        var toExecute: ((Void)->(Void))? = closure
        
        let cancellable: DelayedBlock = {
            cancel in
            
            if cancel == false, let toExecute = toExecute  {
                dispatch_async(dispatch_get_main_queue(), toExecute);
            }
            
            toExecute = nil
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            cancellable(false)
        }
        
        return cancellable
    }
    
}

