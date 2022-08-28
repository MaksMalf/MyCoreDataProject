import UIKit

protocol AssemblyBuilderProtocol {
    func createListUsersModule(router: RouterProtocol) -> UIViewController
    func createDetailUsersModule(user: User?, router: RouterProtocol) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {

    func createListUsersModule(router: RouterProtocol) -> UIViewController {
        let model = UserDataService.shared
        let view = ListUsersViewController()
        let presentor = ListUsersPresenter(view: view, userDataService: model, router: router)
        view.presentor = presentor
        return view
    }

    func createDetailUsersModule(user: User?, router: RouterProtocol) -> UIViewController {
        let model = UserDataService.shared
        let view = DetailUsersViewController()
        let presentor = DetailUsersPresenter(view: view, userDataService: model, router: router, user: user)
        view.presenter = presentor
        return view
    }

}
