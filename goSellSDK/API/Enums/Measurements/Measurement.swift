//
//  Measurement.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

public enum Measurement {
    
    case area(Area)
    case duration(Duration)
    case electricCharge(ElectricCharge)
    case electricCurrent(ElectricCurrent)
    case energy(Energy)
    case length(Length)
    case mass(Mass)
    case units
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal init?(category: String, unit: String? = nil) {
        
        switch category {
            
        case Constants.area:
            
            guard let nonnullUnit = unit, let measurementUnit = Area(string: nonnullUnit) else { return nil }
            self = .area(measurementUnit)
            
        case Constants.duration:
            
            guard let nonnullUnit = unit, let measurementUnit = Duration(string: nonnullUnit) else { return nil }
            self = .duration(measurementUnit)
            
        case Constants.electricCharge:
            
            guard let nonnullUnit = unit, let measurementUnit = ElectricCharge(string: nonnullUnit) else { return nil }
            self = .electricCharge(measurementUnit)
            
        case Constants.electricCurrent:
            
            guard let nonnullUnit = unit, let measurementUnit = ElectricCurrent(string: nonnullUnit) else { return nil }
            self = .electricCurrent(measurementUnit)
            
        case Constants.energy:
            
            guard let nonnullUnit = unit, let measurementUnit = Energy(string: nonnullUnit) else { return nil }
            self = .energy(measurementUnit)
            
        case Constants.length:
            
            guard let nonnullUnit = unit, let measurementUnit = Length(string: nonnullUnit) else { return nil }
            self = .length(measurementUnit)
            
        case Constants.mass:
            
            guard let nonnullUnit = unit, let measurementUnit = Mass(string: nonnullUnit) else { return nil }
            self = .mass(measurementUnit)
            
        case Constants.units:
            
            self = .units
            
        default:
            
            return nil
        }
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let area             = "area"
        fileprivate static let duration         = "duration"
        fileprivate static let electricCharge   = "electric_charge"
        fileprivate static let electricCurrent  = "electric_current"
        fileprivate static let energy           = "energy"
        fileprivate static let length           = "length"
        fileprivate static let mass             = "mass"
        fileprivate static let units            = "units"
        
        @available(*, unavailable) private init() {}
    }
}

// MARK: - CustomStringConvertible
extension Measurement: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            
        case .area(_)           : return Constants.area
        case .duration(_)       : return Constants.duration
        case .electricCharge(_) : return Constants.electricCharge
        case .electricCurrent(_): return Constants.electricCurrent
        case .energy(_)         : return Constants.energy
        case .length(_)         : return Constants.length
        case .mass(_)           : return Constants.mass
        case .units             : return Constants.units

        }
    }
}

// MARK: - CountableCasesEnum
extension Measurement: CountableCasesEnum {
    
    public static var all: [Measurement] {
        
        var result: [Measurement] = []
        
        Measurement.Area.all.forEach            { result.append(.area($0))              }
        Measurement.Duration.all.forEach        { result.append(.duration($0))          }
        Measurement.ElectricCharge.all.forEach  { result.append(.electricCharge($0))    }
        Measurement.ElectricCurrent.all.forEach { result.append(.electricCurrent($0))   }
        Measurement.Energy.all.forEach          { result.append(.energy($0))            }
        Measurement.Length.all.forEach          { result.append(.length($0))            }
        Measurement.Mass.all.forEach            { result.append(.mass($0))              }
        
        result.append(.units)
        
        return result
    }
}


// MARK: - Equatable
extension Measurement: Equatable {
    
    public static func == (lhs: Measurement, rhs: Measurement) -> Bool {
        
        switch (lhs, rhs) {
            
        case (.area             (let lhsUnit), .area            (let rhsUnit))  : return lhsUnit == rhsUnit
        case (.duration         (let lhsUnit), .duration        (let rhsUnit))  : return lhsUnit == rhsUnit
        case (.electricCharge   (let lhsUnit), .electricCharge  (let rhsUnit))  : return lhsUnit == rhsUnit
        case (.electricCurrent  (let lhsUnit), .electricCurrent (let rhsUnit))  : return lhsUnit == rhsUnit
        case (.energy           (let lhsUnit), .energy          (let rhsUnit))  : return lhsUnit == rhsUnit
        case (.length           (let lhsUnit), .length          (let rhsUnit))  : return lhsUnit == rhsUnit
        case (.mass             (let lhsUnit), .mass            (let rhsUnit))  : return lhsUnit == rhsUnit
        case (.units                         , .units)                          : return true
            
        default: return false

        }
    }
}
