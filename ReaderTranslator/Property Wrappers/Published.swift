import Foundation
import Combine

private var cancellableSet: Set<AnyCancellable> = []

extension Published where Value: Codable {
    init(wrappedValue defaultValue: Value, key: String) {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let value = try JSONDecoder().decode(Value.self, from: data)
                self.init(initialValue: value)
            } catch {
                print("🐞🐞🐞Error while deconding yser data")
                self.init(initialValue: defaultValue)
            }
        } else {
            self.init(initialValue: defaultValue)
        }

        projectedValue
            .sink { val in
                do {
                    let data = try JSONEncoder().encode(val)
                    UserDefaults.standard.set(data, forKey: key)
                } catch {
                    print("Error while decoding user data")
                }
            }
            .store(in: &cancellableSet)
    }
}

//extension Published {
//    init(wrappedValue defaultValue: Value, key: String) {
//        let value = UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
//        self.init(initialValue: value)
//        projectedValue
//            .sink { val in
//                UserDefaults.standard.set(val, forKey: key)
//            }
//            .store(in: &cancellableSet)
//    }
//}

//extension Published where Value: RawRepresentable, Value.RawValue == String {
//    init(wrappedValue defaultValue: Value, key: String) {
//        let savedValue = UserDefaults.standard.string(forKey: key) ?? ""
//        let value = Value.init(rawValue: savedValue) ?? defaultValue
//
//        self.init(initialValue: value)
//        projectedValue
//            .sink { val in
//                UserDefaults.standard.set(val.rawValue, forKey: key)
//            }
//            .store(in: &cancellableSet)
//    }
//}
