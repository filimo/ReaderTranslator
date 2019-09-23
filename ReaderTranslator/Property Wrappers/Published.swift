import Foundation
import Combine

private var cancellableSet: Set<AnyCancellable> = []

extension Published {
    init(wrappedValue defaultValue: Value, key: String) {
        let value = UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
        self.init(initialValue: value)
        projectedValue
            .sink { val in
                UserDefaults.standard.set(val, forKey: key)
            }
            .store(in: &cancellableSet)
    }
}

extension Published where Value: RawRepresentable, Value.RawValue == String {
    init(wrappedValue defaultValue: Value, key: String) {
        let savedValue = UserDefaults.standard.string(forKey: key) ?? ""
        let value = Value.init(rawValue: savedValue) ?? defaultValue
        
        self.init(initialValue: value)
        projectedValue
            .sink { val in
                UserDefaults.standard.set(val.rawValue, forKey: key)
            }
            .store(in: &cancellableSet)
    }
}

