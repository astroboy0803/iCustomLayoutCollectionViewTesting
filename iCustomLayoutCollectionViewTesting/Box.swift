//
//  Box.swift
//  CustomLayoutCollectionViewTesting
//
//  Created by astroboy0803 on 2020/8/27.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import Foundation

class Box<T> {
    public typealias linsterType = (_ newValue: T?, _ oldValue: T?) -> Void
    
    var _EventListeners: [linsterType] = []
    
    var value: T? = nil {
        didSet {
            self.execute(newValue: value, oldValue: oldValue)
        }
    }
    
    init(_ value: T? , listener: [linsterType]? = nil) {
        
        self.value = value
        self._EventListeners = listener ?? []
    }
    
    deinit {
        //CSRPrint.info("CSRSaveBoxing<\(type(of: value))> deinit)")
    }
    
    // MARK: 單一binding
    func binding(trigger: Bool = true , _ index : Int? = nil ,  listener: @escaping linsterType) {
        self.appendingBinding(trigger: trigger,index: index, listener: listener)
    }
    
    private func appendingBinding(trigger: Bool = true ,index : Int? = nil , listener: @escaping linsterType) {
        if let index = index , index <  self._EventListeners.count
        {
            self._EventListeners.insert(listener, at: index)
        }
        else
        {
            self._EventListeners.append(listener)
        }
        
        if trigger {
            listener(self.value, self.value)
        }
    }
    
    func removeAllBinding() {
        self._EventListeners.removeAll()
    }
    
    private func execute(newValue: T?, oldValue: T?) {
        for listener in self._EventListeners {
            listener(newValue, oldValue)
        }
    }
}

