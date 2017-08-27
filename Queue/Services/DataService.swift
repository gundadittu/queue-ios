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
    func createExternalSpotifySong(user_id: String, songData: [String:Any]) -> String?{
        if let key = songData[songSpotifyIDKey] as? String {
            REF_EXTERNALSONGS_SONGS.child("\(key)").updateChildValues(songData) //useless?
            REF_EXTERNALSONGS_SONGSBYUSER.child("\(user_id)/\(key)").updateChildValues(songData)
            return key
        }
        return nil
    }
    
    func removeExternalSpotifySong(key: String) {
        return
    }
    
    func removeExternalSpotifySongbyUser(userID: String, key: String) {
        return
    }
    
    func createExternalSpotifyPlaylist(_ user_id: String,_ playlistData: [String:Any]) -> String? {
        if let key = playlistData["playlist_spotify_id"] as? String {
            REF_EXTERNALPLAYLISTS_PLAYLISTS.child("\(key)").updateChildValues(playlistData)
            REF_EXTERNALPLAYLISTS_PLAYLISTSBYUSER.child("\(user_id)/\(key)").updateChildValues(playlistData)
            return key
        }
        return nil
    }
    
}
