import Foundation
import Firebase
import FacebookLogin
import FacebookCore
import FBSDKLoginKit

class AuthService {
    static let instance = AuthService()
    
    func registerUser(withEmail email: String, andPassword password: String, firstName: String, lastName: String, userCreationComplete: @escaping
        (_ status: Bool, _ error: Error?)-> ()){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                userCreationComplete(false,error)
                return
            }
            let userdata = ["provider": user?.providerID, "email": user?.email, "first_name": firstName, "last_name": lastName]
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
    
    func facebookAuth(withCredential credential: AuthCredential, userAuthComplete: @escaping (_ status: Bool, _ error: Error?, _ errorSource: String?) ->()){
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                userAuthComplete(false, error, "firebase")
                return
            }
            
            let connection = GraphRequestConnection()
            connection.add(GraphRequest(graphPath: "/me")) { httpResponse, result in
                switch result {
                case .success(let response): //Graph Result success case
                    let username = response.dictionaryValue?["name"] as? String
                    let splitName = username!.components(separatedBy: " ")
                    let userdata = ["provider": "Facebook", "email": response.dictionaryValue?["email"], "first_name": splitName[0], "last_name": splitName[1], "facebook_friendslist": response.dictionaryValue?["friendlists"], "facebook_accesstoken": FBSDKAccessToken.current().tokenString]
                    let userid = user!.uid
                    DataService.instance.createDBUser(uid: userid, userData: userdata)
                    userAuthComplete(true, nil, nil)
                case .failed(let error): //Graph Result failed case
                    userAuthComplete(false, error, "graph_api")
                }
            }
            connection.start()
        }
    }
    
    func facebookLogin(withCredential credential: AuthCredential, userLoginComplete: @escaping (_ status: Bool, _ error: Error?) ->()){
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                userLoginComplete(false,error)
                return
            }
            userLoginComplete(true,nil)
        }
    }
}
