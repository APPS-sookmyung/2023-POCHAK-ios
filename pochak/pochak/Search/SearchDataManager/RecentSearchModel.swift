//
//  RecentSearchModel.swift
//  pochak
//
//  Created by 장나리 on 1/16/24.
//

import Foundation
import RealmSwift

class RecentSearchModel : Object {
    @Persisted(primaryKey: true) var objectID : ObjectId
    @Persisted var term: String // primary key로 지정
    @Persisted var date: Date

    convenience init(term: String) {
        self.init()
        self.term = term
    }
}

