import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    
    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping
        (_ status: Bool, _ error: Error?)-> ()){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                userCreationComplete(false,error)
                return
            }
            let userdata = ["provider": user?.providerID, "email": user?.email]
            let userid = user!.uid
            DataService.instance.createDBUser(uid: userid, userData: userdata)
            userCreationComplete(true, nil)
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping
        (_ status: Bool, _ error: Error?)-> ()){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false,error)
                return
            }
            loginComplete(true,nil)
        }
    }
    
    
    
    
}
