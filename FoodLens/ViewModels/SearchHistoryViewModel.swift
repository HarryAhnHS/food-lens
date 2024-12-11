//
//  SearchHistoryViewModel.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class SearchHistoryViewModel: ObservableObject {
    @Published var searches: [UserSearch] = []

    private let db = Firestore.firestore()

//    / Fetch all searches for the current user from Firestore
    func fetchSearches() {
        guard let user = Auth.auth().currentUser else {
            print("No authenticated user")
            return
        }

        db.collection("users")
            .document(user.uid)
            .collection("searchHistory")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching searches: \(error.localizedDescription)")
                    return
                }

                self.searches = snapshot?.documents.compactMap { doc -> UserSearch? in
                    do {
                        return try doc.data(as: UserSearch.self)
                    } catch {
                        print("Error decoding search document: \(error)")
                        return nil
                    }
                } ?? []
            }
    }

    // Add a new search to the current user's searchHistory
    func addSearch(barcode: String, isSaved: Bool) {
        guard let user = Auth.auth().currentUser else {
            print("No authenticated user")
            return
        }

        let newSearch = UserSearch(barcode: barcode, timestamp: Date(), isSaved: isSaved)

        do {
            try db.collection("users")
                .document(user.uid)
                .collection("searchHistory")
                .document(barcode)
                .setData(newSearch.toDictionary())
        } catch {
            print("Error adding search: \(error.localizedDescription)")
        }
    }

    /// Toggle the `isSaved` status of a search
    func toggleSave(search: UserSearch) {
        guard let user = Auth.auth().currentUser else {
            print("No authenticated user")
            return
        }

        let documentRef = db.collection("users")
            .document(user.uid)
            .collection("searchHistory")
            .document(search.barcode)

        var updatedSearch = search
        updatedSearch.isSaved.toggle()

        do {
            try documentRef.setData(from: updatedSearch, merge: true) { error in
                if let error = error {
                    print("Error updating save status: \(error.localizedDescription)")
                } else if let index = self.searches.firstIndex(where: { $0.barcode == search.barcode }) {
                    DispatchQueue.main.async {
                        self.searches[index] = updatedSearch
                    }
                }
            }
        } catch {
            print("Error encoding search: \(error.localizedDescription)")
        }
    }
}

