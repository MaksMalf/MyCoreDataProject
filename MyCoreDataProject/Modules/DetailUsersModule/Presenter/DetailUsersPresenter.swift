//
//  DetailUsersPresenter.swift
//  MyCoreDataProject
//
//  Created by Maksim Malofeev on 28/08/2022.
//

import Foundation

protocol DetailUsersViewProtocol: AnyObject {
    func setUser(_ user: User?)
}

protocol DetailUsersPresenterProtocol: AnyObject {
    init(view: DetailUsersViewProtocol, userDataService: UserDataProtocol, router: RouterProtocol, user: User?)
    var user: User? { get set }
    func getUser()
    func updateUser(_ user: User, newName: String?, dateOfBirth: String?, gender: String?, avatar: Data?)
}

class DetailUsersPresenter: DetailUsersPresenterProtocol {

    var user: User?
    weak var view: DetailUsersViewProtocol?
    let userDataService: UserDataProtocol!
    var router: RouterProtocol?

    required init(view: DetailUsersViewProtocol, userDataService: UserDataProtocol, router: RouterProtocol, user: User?) {
        self.view = view
        self.userDataService = userDataService
        self.user = user
        self.router = router
    }

    func getUser() {
        view?.setUser(user)
    }

    func updateUser(_ user: User,
                    newName: String?,
                    dateOfBirth: String?,
                    gender: String?,
                    avatar: Data?) {

        userDataService.updateUser(user,
                                   newName: newName,
                                   dateOfBirth: dateOfBirth,
                                   gender: gender,
                                   avatar: avatar)
    }
}
