import UIKit

extension UIColor {
       static var ypBlack: UIColor { UIColor(named: "dark") ?? UIColor.black }
    static var ypGreen: UIColor {
        UIColor(named: "green") ?? UIColor.green
    }
    static var ypRed: UIColor {
        UIColor(named: "red") ?? UIColor.red
    }
    static var ypGrey: UIColor {
        UIColor(named: "grey") ?? UIColor.lightGray
    }
    static var ypWhite: UIColor {UIColor.white}
    static var ypBackground: UIColor {
        UIColor(named: "background") ?? UIColor.darkGray
    }
}
