import CoreData

protocol UserDataProtocol: AnyObject {
    var allUsers: [User]? { get }

    func saveUser(_ name: String)
    func getAllUsers() -> [User]?
    func deleteUser(_ user: User)
    func updateUser(_ user: User, newName: String?, dateOfBirth: String?, gender: String?, avatar: Data?)
}

class UserDataService: UserDataProtocol {

    // MARK: - Propertries

    static let shared = UserDataService()

    var allUsers: [User]? {
        return getAllUsers()
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HWCoreDataProject")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private lazy var context = persistentContainer.viewContext

    // MARK: - Functions

    func saveUser(_ name: String) {
        let newUser = User(context: context)
        newUser.name = name

        do {
            try context.save()
        } catch {
            print(error)
        }
    }

    func getAllUsers() -> [User]? {
        do {
            let request = User.fetchRequest() as NSFetchRequest<User>
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            let users = try context.fetch(request)
            return users
        } catch {
            print(error)
            return nil
        }
    }

    func deleteUser(_ user: User) {
        context.delete(user)
        do {
            try context.save()
        } catch {
            print(error)
        }
    }

    func updateUser(_ user: User, newName: String?, dateOfBirth: String?, gender: String?, avatar: Data?) {
        if let newName = newName {
            user.name = newName
        }

        if let dateOfBirth = dateOfBirth {
            user.dateOfBirth = dateOfBirth.convertToDate()
        }

        if let gender = gender {
            user.gender = gender
        }

        if let avatar = avatar {
            user.avatar = avatar
        }

        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}

// MARK: - Core Data Saving support

extension UserDataService {
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
