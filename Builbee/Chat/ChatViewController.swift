//
//  ChatViewController.swift
//  Builbee
//
//  Created by Khawar Khan on 26/10/2020.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit
import MessageKit
import Firebase
import InputBarAccessoryView
import CodableFirebase

struct Constants {
    static let areaOfExperience = "area_of_exp"
    struct refs {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chatThreads")
    }
}

struct MessageModal: Decodable {
    var id: String
    var content: String
    var created: String
    var senderID: String
    var senderName: String
}


class ChatViewController: MessagesViewController {
    
    var assigneeId = "-1"
    var isFrom = "AgentHomeC"
    var projectList: ProjectData? = nil
    var customerPostedProjects: PostData? = nil
    var userProfileInDefault = UserDefaults.standard.object(forKey: "ProfileModal") as? [String: Any]
    var messages: [Message] = []
    var chat_id = "-1"
    var projectId = "-1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "backicon"), style: .done, target: self, action: #selector(self.action(sender:)))

        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black

    }
    
    override func viewWillAppear(_ animated: Bool) {
        projectId = "\(String(describing: projectList!.id!))"
        chat_id = self.assigneeId + getUserID()
        
        getMessage()
    }
    
    func getUserID() -> String {
        return userProfileInDefault?["id"] as! String
    }
    
    @IBAction func backBtnTpd(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func action(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func sendDataIntoConversationList() {
        print(projectList!.id!)
        
        
        let chatList: [String: Any] = ["createdDate": "\(Date().timeIntervalSince1970)", "projectId": self.projectId ?? "-1","assignee": getUserID() , "chatId": chat_id]
        Builbee.Constants.refs.databaseRoot.child("chatList").child(assigneeId).child(chat_id).setValue(chatList)
                
            
        let chatListForAssignee: [String: Any] = ["createdDate": "\(Date().timeIntervalSince1970)" ,"projectId": self.projectId, "assignee": assigneeId, "chatId": chat_id]
        Builbee.Constants.refs.databaseRoot.child("chatList").child(getUserID()).child(chat_id).setValue(chatListForAssignee)
            
        }
    
    func getMessage() {
        
        Constants.refs.databaseChats.child(chat_id).observe( .value, with: { snapshot in
            guard snapshot.value != nil else { return }

            self.messages = []
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if var postDict = snap.value as? Dictionary<String, Any> {
                        postDict["id"] = snap.key as String
                        do {
                               let model = try FirebaseDecoder().decode(MessageModal.self, from: postDict)
                               print(model)
//                            self.messages.append()

                            DispatchQueue.main.async {
                                self.messagesCollectionView.reloadData()
                                self.messagesCollectionView.scrollToBottom(animated: true)
                            }

                           } catch let error {
                               print(error)
                           }
                    } else {
                        print("error")
                    }
                }
            }
        })

    }
    
}

extension ChatViewController: InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    func currentSender() -> SenderType {
        return Sender(id: getUserID(), displayName:  userProfileInDefault?["name"] as! String)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section] as! MessageType
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        print(messages.count)
        return messages.count
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        sendDataIntoConversationList()
        sendMessageToDb (message: inputBar.inputTextView.text)
        inputBar.inputTextView.text = ""
        
    }
    
    func sendMessageToDb (message: String) {
        
     let ref = Builbee.Constants.refs.databaseChats.child(chat_id).childByAutoId()
        let message = ["senderID": getUserID(), "content": message , "created": "\(Date().timeIntervalSince1970)", "senderName": userProfileInDefault?["name"] ?? ""] as [String : Any]
    ref.setValue(message)
    }
}




struct Message {
    
    var id: String
    var content: String
    var created: TimestampType
    var senderID: String
    var senderName: String
    
    var dictionary: [String: Any] {
        
        return [
            "id": id,
            "content": content,
            "created": created,
            "senderID": senderID,
            "senderName":senderName]
        
    }
}

extension Message {
    init?(dictionary: [String: Any]) {
        
        guard let id = dictionary["id"] as? String,
            let content = dictionary["content"] as? String,
            let created = dictionary["created"] as? TimestampType,
            let senderID = dictionary["senderID"] as? String,
            let senderName = dictionary["senderName"] as? String
            else {return nil}
        
        self.init(id: id, content: content, created: created, senderID: senderID, senderName:senderName)
        
    }
}

extension Message: MessageType {
    
    var sender: SenderType {
        return Sender(id: senderID, displayName: senderName)
    }
    
    var messageId: String {
        return id
    }
    
    var sentDate: Date {
        return created.dateValue()
    }
    
    var kind: MessageKind {
        return .text(content)
    }
}
