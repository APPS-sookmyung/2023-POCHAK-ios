//
//  RecentSearchTermManager.swift
//  pochak
//
//  Created by 장나리 on 1/16/24.
//
import RealmSwift

class RecentSearchRealmManager {
    private let realm: Realm

    init() {
        // Get the default Realm
        self.realm = try! Realm()
    }

    // MARK: - Create
    func addRecentSearch(term: String) {
        // Check if the term already exists in Realm
        if let existingSearchTerm = realm.objects(RecentSearchModel.self).filter("term == %@", term).first {
            // Term already exists, update the date
            try! realm.write {
                existingSearchTerm.date = Date()
            }
            print("Term date updated in Realm")
        } else {
            // Term does not exist, add it to Realm
            let searchTerm = RecentSearchModel(term: term)
            try! realm.write {
                realm.add(searchTerm)
            }
            print("Term added to Realm")
        }
    }

    // MARK: - Read
    func getAllRecentSearchTerms() -> Results<RecentSearchModel> {
        // Retrieve all RecentSearchModel objects from Realm
        return realm.objects(RecentSearchModel.self)
    }

    // MARK: - Update
    func updateRecentSearchTerm(originalTerm: String, newTerm: String) {
        guard let searchTerm = realm.objects(RecentSearchModel.self).filter("term == %@", originalTerm).first else {
            print("Original term not found in Realm")
            return
        }

        try! realm.write {
            // Update the term with a new value
            searchTerm.term = newTerm
            // Update the date to reflect the modification
            searchTerm.date = Date()
        }
        print("Term updated in Realm")
    }

    // MARK: - Delete
    func deleteRecentSearchTerm(term: String) {
        guard let searchTerm = realm.objects(RecentSearchModel.self).filter("term == %@", term).first else {
            print("Term not found in Realm")
            return
        }

        try! realm.write {
            // Delete the term from Realm
            realm.delete(searchTerm)
        }
        print("Term deleted from Realm")
    }
}
