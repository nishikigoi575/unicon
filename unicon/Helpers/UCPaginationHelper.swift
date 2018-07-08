//
//  UCPaginationHelper.swift
//  unicon
//
//  Created by yo hanashima on 2018/06/24.
//  Copyright © 2018 Imajin Kawabe. All rights reserved.
//

import Foundation
import Firestore.FIRDocumentSnapshot

class UCPaginationHelper<T> {
    enum UCPaginationState {
        case initial
        case ready
        case loading
        case end
    }
    
    // MARK: - Properties
    
    var pageSize: UInt
    let serviceMethod: (UInt, Int, String?, @escaping (([T]) -> Void)) -> Void
    var state: UCPaginationState = .initial
    var numOfObjects: Int = 0
    var keyUID: String?
    
    // MARK: - Init
    
    init(pageSize: UInt = 10, keyUID: String?, serviceMethod: @escaping (UInt, Int, String?, @escaping (([T]) -> Void)) -> Void) {
        self.pageSize = pageSize
        self.serviceMethod = serviceMethod
        self.keyUID = keyUID
    }
    
    func paginate(completion: @escaping ([T]) -> Void) {
        
        switch state {
            
        case .initial:
            numOfObjects = 0
            fallthrough
            
        case .ready:
            state = .loading
            serviceMethod(pageSize, numOfObjects, keyUID) { [weak self] (objects: [T]) in
                
                defer {
                    self?.numOfObjects += objects.count
                    if let pageSize = self?.pageSize {
                        self?.state = objects.count < Int(pageSize) ? .end : .ready
                    }
                }
                completion(objects)
            }
            
        case .loading, .end:
            return
        }
    }
    
    func reloadData(completion: @escaping ([T]) -> Void) {
        state = .initial
        paginate(completion: completion)
    }
}

class UCPaginationTeamHelper {
    static func paginationTeam(pageSize: UInt, numOfObjects: Int, ref: CollectionReference, completion: @escaping ([Team]) -> Void) {
        if numOfObjects > 0 {
            print("pagination next")
            let first = ref.limit(to: numOfObjects)
            first.getDocuments {(snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error retreving price: \(error.debugDescription)")
                    return completion([])
                }
                
                guard let lastSnapshot = snapshot.documents.last else {
                    return completion([])
                }
                
                let next = ref.start(afterDocument: lastSnapshot).limit(to: Int(pageSize))
                next.getDocuments { (nextSnapshot, error) in
                    guard let nextSnapshot = nextSnapshot else {
                        print("Error : \(error.debugDescription)")
                        return completion([])
                    }
                    let dispatchGroup = DispatchGroup()
                    
                    var teams = [Team]()
                    for teamSnap in nextSnapshot.documents {
                        guard let teamDict = teamSnap.data() as? [String: Any]
                            else { continue }
                        
                        dispatchGroup.enter()
                        
                        TeamService.show(forTeamID: teamSnap.documentID) { (team) in
                            if let team = team {
                                teams.append(team)
                                dispatchGroup.leave()
                            }
                        }
                    }
                    dispatchGroup.notify(queue: .main, execute: {
                        completion(teams)
                    })
                }
            }
        } else {
            print("pagination initial")
            let query = ref.limit(to: Int(pageSize))
            query.getDocuments{ (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error retreving posts: \(error.debugDescription)")
                    return completion([])
                }
                let dispatchGroup = DispatchGroup()
                
                var teams = [Team]()
                for teamSnap in snapshot.documents {
                    guard let teamDict = teamSnap.data() as? [String: Any]
                        else { continue }
                    
                    dispatchGroup.enter()
                    TeamService.show(forTeamID: teamSnap.documentID) { (team) in
                        if let team = team {
                            teams.append(team)
                            dispatchGroup.leave()
                        }
                    }
                }
                dispatchGroup.notify(queue: .main, execute: {
                    completion(teams)
                })
            }
        }
    }
}
