//
//  ConditionalPillTask.swift
//  TusenTac
//
//  Created by ingeborg ødegård oftedal on 21/12/15.
//  Copyright © 2015 ingeborg ødegård oftedal. All rights reserved.
//

/*import Foundation
import ResearchKit

class ConditionalPillTask : ORKOrderedTask {
    
    init() {
        super.init(identifier: Identifier.PillTask.rawValue, steps: PillTask.steps)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func stepAfterStep(step: ORKStep?, withResult result: ORKTaskResult) -> ORKStep? {
        let currentStepIdentifier = step?.identifier
        if currentStepIdentifier == Identifier.PillOptionStep.rawValue {
            if (b) {
                return self.steps[1] as? ORKStep
            }
            else {
                return self.steps[2] as? ORKStep
            }
        }
            // litt hacky løsnig
        else if currentStepIdentifier == Identifier.BloodPressureMeasuredStep.rawValue {
            return self.steps[3] as? ORKStep
        }
        else if currentStepIdentifier == Identifier.BloodPressureNotMeasuredStep.rawValue {
            return nil
        }
        return super.stepAfterStep(step, withResult: result)
    }

}*/
