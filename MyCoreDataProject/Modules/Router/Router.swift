import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showDetail(user: User?)
}

class Router: RouterProtocol {

    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?

    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }

    func initialViewController() {
        if let navigationController = navigationController {
            guard let listUsersModule = assemblyBuilder?.createListUsersModule(router: self) else { return }
            navigationController.viewControllers = [listUsersModule]
        }
    }

    func showDetail(user: User?) {
        if let navigationController = navigationController {
            guard let detailUserModule = assemblyBuilder?.createDetailUsersModule(user: user, router: self) else { return }
            navigationController.pushViewController(detailUserModule, animated: true)
        }
    }
}
