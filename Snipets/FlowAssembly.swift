import Foundation
import Swinject
import Moya
import FlowwowCommon


public final class <#NameFlowAssembly#>: Assembly
{
    public init() {}
    
    public func assemble(container: Container) {
        container.register(<#Servise#>.self, factory: { r in
            let networkingManager = r.resolve(NetworkingManager.self)!
            let errorReporter = r.resolve(ErrorReporter.self)!
            
            let provider = MoyaProvider<<#ServiceApi#>>(manager: networkingManager)
            return <#ServiceClass#>(provider: provider, errorReporter: errorReporter)
        }).inObjectScope(.container)
    }
}


extension Bundle
{
    class var current: Bundle {
        Bundle(for: <#NameFlowAssembly#>.self)
    }
}
