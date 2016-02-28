//
//  TaskListRow.swift
//  MedForsk
//
//  Created by Paul Philip Mitchell on 24/07/15.
//  Copyright (c) 2015 Universitetet i Oslo. All rights reserved.
//

/*
Copyright (c) 2015, Apple Inc. All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1.  Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

2.  Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.

3.  Neither the name of the copyright holder(s) nor the names of any contributors
may be used to endorse or promote products derived from this software without
specific prior written permission. No license is granted to the trademarks of
the copyright holders even if such marks are included in this software.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import ResearchKit

/**
 An enum that corresponds to a row displayed in a `TaskListViewController`.
 
 Each of the tasks is composed of one or more steps giving examples of the
 types of functionality supported by the ResearchKit framework.
 */
enum TaskListRow: Int, CustomStringConvertible {
    case Pill
    case Eat
    case Weight
    case SideEffect
    
    /// Returns an array of all the task list row enum cases.
    static var allCases: [TaskListRow] {
        /*
        Create a generator that creates a `TaskListRow` at a specific index.
        When `TaskListRow`'s `rawValue` initializer returns `nil`, the generator
        will stop generating values. This will happen when the enum has no more
        cases represented by `caseIndex`.
        */
        var caseIndex = 0
        let caseGenerator = anyGenerator { TaskListRow(rawValue: caseIndex++) }
        
        // Create a sequence that will consume the generator to create an array.
        let caseSequence = AnySequence(caseGenerator)
        
        return Array(caseSequence)
    }
    
    // MARK: Printable
    
    var description: String {
        switch self {
        case .Pill:
            return "Registrer dose".localized
        case .Eat:
            return "Registrer måltid".localized
        case .Weight:
            return "Registrer vekt".localized
        case .SideEffect:
            return "Registrer bivirkninger".localized
        }
    }
    
    // MARK: Properties
    
    /// Returns a new `ORKTask` that the `TaskListRow` enumeration represents.
    var representedTask: ORKTask {
        switch self {
        case .Pill:
            return PillTask
        case .Eat:
            return EatTask
        case .Weight:
            return WeightTask
        case .SideEffect:
            return SideEffectTask
        }
    }
}