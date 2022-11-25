//
//  HealthStore.swift
//  Hydration App
//
//  Created by Michał Ganiebny on 25/11/2022.
//

import Foundation
import HealthKit

class HealthStore: ObservableObject {
    
    
    var healthStore: HKHealthStore?
    
    init() {
        
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        
        let waterType = HKQuantityType(.dietaryWater)
        
        guard let healthStore = self.healthStore else { return completion(false) }
        
        healthStore.requestAuthorization(toShare: [waterType], read: [waterType]) { success, error in
            completion(success)
        }
        
    }
    
    func isHealthKitAuthorized() -> Bool {
        let waterType = HKQuantityType(.dietaryWater)
        if let healthStore = self.healthStore {
            if healthStore.authorizationStatus(for: waterType) == .sharingAuthorized {
                return true
            }
            else {
                return false
            }
        }
        return false
        
    }
}
