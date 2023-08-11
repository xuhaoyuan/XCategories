import UIKit

public extension UIColor {
    
    convenience init?(hex: String?) {
        
        guard let hex = hex, !hex.isEmpty else { return nil }
        
        let r, g, b, a: CGFloat
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                if hexColor.count == 8 {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: Double(r), green: Double(g), blue: Double(b), alpha: Double(a))
                    return
                } else if hexColor.count == 6 {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    a = 255 / 255
                    self.init(red: Double(r), green: Double(g), blue: Double(b), alpha: Double(a))
                    return
                }
            }
        }
        return nil
    }
    
    convenience init?(hex: String, alpha: Float) {
        var hex = hex.uppercased()
        if hex.hasPrefix("#") {
            hex = String(hex.dropFirst())
        }
        guard let hexVal = Int(hex, radix: 16) else {
            return nil
        }
        self.init(hex6: hexVal, alpha: alpha)
    }
    
    convenience init?(hex6: Int, alpha: Float) {
        self.init(red: CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
                  blue: CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0,
                  alpha: CGFloat(alpha)
        )
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: a)
    }
}

public extension UIColor {
    var image: UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
