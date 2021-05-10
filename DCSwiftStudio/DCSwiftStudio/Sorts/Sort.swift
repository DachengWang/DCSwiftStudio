//
//  Sort.swift
//  DCSwiftStudio
//
//  Created by wangdacheng on 2021/5/10.
//  Copyright © 2021 大成小栈. All rights reserved.
//

import Foundation

protocol SortType {
    
    func sort(items: Array<Int>) -> Array<Int>
    func setEveryStepClosure(everyStepClosure: @escaping SortResultClosure, sortSuccessClosure: @escaping SortSuccessClosure) -> Void
}
