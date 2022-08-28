//
//  ListUsersPresenter.swift
//  MyCoreDataProject
//
//  Created by Maksim Malofeev on 28/08/2022.
//

import Foundation

protocol ListUsersViewProtocol: AnyObject {
    func updateTableView()
}

protocol ListUsersViewPresenterProtocol: AnyObject {
    init(view: ListUsersViewProtocol, userDataService: UserDataProtocol, router: RouterProtocol)
    func getAllUsers()
    func saveData(_ name: String)
    func deleteUser(_ user: User)
    func tapOnTheUser(user: User?)
    var users: [User]? { get set }
}

class ListUsersPresenter: ListUsersViewPresenterProtocol {
    var users: [User]?
    weak var view: ListUsersViewProtocol?
    var router: RouterProtocol?
    let userDataService: UserDataProtocol!

    required init(view: ListUsersViewProtocol, userDataService: UserDataProtocol, router: RouterProtocol) {
        self.view = view
        self.userDataService = userDataService
        self.router = router
    }

    func saveData(_ name: String) {
        self.userDataService.saveUser(name)
        view?.updateTableView()
    }

    func deleteUser(_ user: User) {
        self.userDataService.deleteUser(user)
        view?.updateTableView()
    }

    func getAllUsers() {
        users = self.userDataService.allUsers
    }

    func tapOnTheUser(user: User?) {
        router?.showDetail(user: user)
    }
}
