import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
  
    static let instance = DataService()
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_EXTERNALMUSIC = DB_BASE.child("externalMusic")
    private var _REF_EXTERNALSONGS = DB_BASE.child("externalMusic/externalSongs")
    private var _REF_EXTERNALSONGS_SONGS = DB_BASE.child("externalMusic/externalSongs/songs")
    private var _REF_EXTERNALSONGS_SONGSBYUSER = DB_BASE.child("externalMusic/externalSongs/songsByUser")
    private var _REF_EXTERNALPLAYLISTS = DB_BASE.child("externalMusic/externalPlaylists")
    private var _REF_EXTERNALPLAYLISTS_PLAYLISTS = DB_BASE.child("externalMusic/externalPlaylists/playlists")
    private var _REF_EXTERNALPLAYLISTS_PLAYLISTSBYUSER = DB_BASE.child("externalMusic/externalPlaylists/playlistsByUser")
    private var _REF_GROUPPLAYLISTS = DB_BASE.child("groupPlaylists") //add getter
    private var _REF_GROUPPLAYLISTS_BYUSER = DB_BASE.child("groupPlaylists/playlistsbyuser") //add getter
    private var _REF_GROUPPLAYLISTS_PLAYLISTS = DB_BASE.child("groupPlaylists/playlists") //add getter

    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    var REF_EXTERNALMUSIC: DatabaseReference {
        return _REF_EXTERNALMUSIC
    }
    var REF_EXTERNALSONGS: DatabaseReference {
        return _REF_EXTERNALSONGS
    }
    var REF_EXTERNALSONGS_SONGS: DatabaseReference {
        return _REF_EXTERNALSONGS_SONGS
    }
    var REF_EXTERNALSONGS_SONGSBYUSER: DatabaseReference {
        return _REF_EXTERNALSONGS_SONGSBYUSER
    }
    var REF_EXTERNALPLAYLISTS: DatabaseReference {
        return _REF_EXTERNALPLAYLISTS
    }
    var REF_EXTERNALPLAYLISTS_PLAYLISTS: DatabaseReference {
        return _REF_EXTERNALPLAYLISTS_PLAYLISTS
    }
    var REF_EXTERNALPLAYLISTS_PLAYLISTSBYUSER: DatabaseReference {
        return _REF_EXTERNALPLAYLISTS_PLAYLISTSBYUSER
    }
    
    var REF_GROUPPLAYLISTS_PLAYLISTS: DatabaseReference {
        return _REF_GROUPPLAYLISTS_PLAYLISTS
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child("\(uid)").updateChildValues(userData)
    }
    
    func writeUserData(uid: String, key: String, data: Any){
        REF_USERS.child("\(uid)").updateChildValues([key:data])
    }
    
    func readUserData(uid: String, key: String, completion: @escaping (_ response: Any?, _ error: Bool) -> Void){
        self.REF_USERS.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? Any {
                completion(value, false)
            } else {
                completion(nil, true)
            }
        })
    }
    
    func createUniqueID() -> String{
        return NSUUID().uuidString
    }
    
    //add return error option? error handling?
    func createExternalSPSong(user_id: String, songData: [String:Any], completionHandler: @escaping (String?)->Void)  -> Void {
        if let key = songData[songSourceIDKey] as? String {
            REF_EXTERNALSONGS_SONGS.child("\(key)").updateChildValues(songData) //useless?
            REF_EXTERNALSONGS_SONGSBYUSER.child("\(user_id)/\(key)").updateChildValues(songData)
            completionHandler(key)
            return
        }
        completionHandler(nil)
    }
    
    func createExternalSPPlaylist(_ user_id: String,_ playlistData: [String:Any], completionHandler: @escaping (String?)->Void) -> Void {
        if let key = playlistData[playlistSourceIDKey] as? String {
            REF_EXTERNALPLAYLISTS_PLAYLISTS.child("\(key)").updateChildValues(playlistData)
            REF_EXTERNALPLAYLISTS_PLAYLISTSBYUSER.child("\(user_id)/\(key)").updateChildValues(playlistData)
            completionHandler(key)
        }
        completionHandler(nil)
    }
    
    func createExternalAMSong(_ user_id: String,_ songData: [String:Any]) throws ->Void {
        if let key = songData[songSourceIDKey] as? Int {
            ///self.REF_EXTERNALSONGS_SONGS.child("\(String(describing: key))").updateChildValues(songData) //useless?
            self.REF_EXTERNALSONGS_SONGSBYUSER.child("\(user_id)/\(key)").updateChildValues(songData)
        } else {
            throw DataError.uploadingPlaylist
        }
    }
    
    func createExternalAMPlaylist(_ user_id: String,_ playlistData: [String:Any]) throws -> Void{
        if let key = playlistData[playlistSourceIDKey] as? UInt64 {
            self.REF_EXTERNALPLAYLISTS_PLAYLISTS.child("\(key)").updateChildValues(playlistData)
            self.REF_EXTERNALPLAYLISTS_PLAYLISTSBYUSER.child("\(user_id)/\(key)").updateChildValues(playlistData)
        } else {
            throw DataError.uploadingPlaylist
        }
    }
    
    func removeExternalSong(key: String) {
        return
    }
    
    func removeExternalSongbyUser(userID: String, key: String) {
        return
    }
    
    func createGroupPlaylist(title: String, type: playlistType, ownerID: String, trackList: [track], playlistPrivacyStatus: accessType, mood: playlistMood, invitations: [playlistInvitation], participants: [playlistUser], completionHandler: @escaping (Error?,GroupPlaylist?)->Void) {
        
        let key = _REF_GROUPPLAYLISTS_PLAYLISTS.childByAutoId().key
        //parse trackslist, image, send invitations, add particpants
        let playlistArray = ["name": title, "mood": mood, "playlist_type": type, "playlist_owner_id": ownerID] as [String : Any]
        let childUpdates = ["\(key)": playlistArray]
        /*
        self._REF_GROUPPLAYLISTS_BYUSER.child(ownerID).updateChildValues(childUpdates) { (error, dbRef) in //check to see if any of the key data, etc. is nil
            if error != nil {
                print(error?.localizedDescription)
            }
        }
         */
        /*
        self._REF_GROUPPLAYLISTS_PLAYLISTS.updateChildValues(childUpdates) { (error, dbRef) in
            if error == nil{
                let playlist = GroupPlaylist(playlistKey: key, title: title)
                completionHandler(nil, playlist)
            } else {
                completionHandler(error, nil)
            }
        }
         */
        
        let playlist = GroupPlaylist(playlistKey: key, title: title)
        completionHandler(nil, playlist)
    }
}
