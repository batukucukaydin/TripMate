
import Foundation

private var _twBundle: Bundle?

extension Bundle {
    static func setLanguage(_ language: String) {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let b = Bundle(path: path) else { return }
        _twBundle = b
        object_setClass(Bundle.main, TW_PrivateBundle.self)
    }

    // 👇 Swift 6: @unchecked Sendable'ı yeniden deklare et
    private class TW_PrivateBundle: Bundle, @unchecked Sendable {
        override func localizedString(forKey key: String,
                                      value: String?,
                                      table tableName: String?) -> String {
            _twBundle?.localizedString(forKey: key, value: value, table: tableName)
            ?? super.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}
