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
        
        healthStore.requestAuthorization(toShare: [waterType],
                                         read: [waterType]) { success, error in
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
    
    
    
    func storeWater(amount: Double, completion: @escaping (Bool) -> Void) {
        
        guard let waterType = HKSampleType.quantityType(forIdentifier: .dietaryWater) else {
            print("Sample type not available")
            return
        }
        
        let quantity = HKQuantity(unit: HKUnit.literUnit(with: .milli), doubleValue: amount)
        
        let waterSample = HKQuantitySample(
            type: waterType,
            quantity: quantity,
            start: Date(),
            end: Date())
        
        guard let healthStore = self.healthStore else { return }
        
        healthStore.save(waterSample) { success, error in
            print(" HK write finished - success: \(success); error \(error)")
            completion(success)
            
        }
    }
    
    static func readWater() {
        guard let waterType = HKSampleType.quantityType(forIdentifier: .dietaryWater) else {
            print("Sample type not available")
            return
        }
        
        let last24hPredicate = HKQuery.predicateForSamples(withStart: Date().dayBefore, end: Date(), options: .strictEndDate)
        
        let waterQuery = HKSampleQuery(sampleType: waterType,
                                       predicate: last24hPredicate,
                                       limit: HKObjectQueryNoLimit,
                                       sortDescriptors: nil) {
            (query, samples, error) in
            
            guard
                error == nil,
                let quantitySamples = samples as? [HKQuantitySample] else {
                print("Something went wrong: \(error)")
                return
            }
            
            let total = quantitySamples.reduce(0.0) { $0 + $1.quantity.doubleValue(for: HKUnit.literUnit(with: .milli)) }
            print("total water: \(total)")
            for sample in quantitySamples {
                print("\(sample.quantity.doubleValue(for: .literUnit(with: .milli)))")
            }
        }
        HKHealthStore().execute(waterQuery)
    }
    
}





