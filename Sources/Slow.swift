//
//  Slow.swift
//  SwiM
//
//  Created by Cory Alder on 2016-04-19.
//  Copyright © 2016 Cory Alder. All rights reserved.
//

import Foundation

public class Slow {
    
    // based on https://github.com/Spaceman-Labs/Dispatch-Cancel/blob/master/dispatch-cancel/SpacemanBlocks.h
    
    public typealias DelayedBlock = (Bool)->(Void)
    
    let queue: DispatchQueue // queue ops will run on
    let interval: TimeInterval // delay on ops
    var previous: DelayedBlock? // the previously enqueued op
    
    public init(interval: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.interval = interval
        self.queue = queue
    }
    
    public func run(closure: (Void)->(Void)) {
    
        previous?(true)
        previous = Slow.cancellable_perform(delay: self.interval, queue: self.queue, closure: closure)
    }
    
    public static func cancellable_perform(delay: TimeInterval, queue: DispatchQueue = DispatchQueue.main, closure:(Void)->(Void)) -> DelayedBlock {
        
        var toExecute: ((Void)->(Void))? = closure
        
        let cancellable: DelayedBlock = {
            cancel in
            
            if cancel == false, let toExecute = toExecute  {
                queue.async(execute: toExecute)
                DispatchQueue.main.async(execute: toExecute)
            }
            
            toExecute = nil
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            cancellable(false)
        }
        
        return cancellable
    }
}

