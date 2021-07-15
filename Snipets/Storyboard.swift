import UIKit


enum <#EnumModuleStoryboards#>: String {
    case <#caseName#> = "<#caseName#>"
}


extension UIStoryboard
{
    convenience init(name: <#EnumModuleStoryboards#>) {
        self.init(name: name.rawValue, bundle: .current)
    }
}
