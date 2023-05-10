import SwiftUI
import CryptoKit
import Foundation

struct ContentView: View {
    @AppStorage("cosmosmasterkey") private var cosmoskey = ""
    @AppStorage("accountname") private var accountname = ""
    @AppStorage("databaseid") private var databaseid = ""
    @AppStorage("collectionid") private var collectionid = ""
    @AppStorage("sql") private var sqltext = ""
    
    func callCosmos() {
        let verb = $sqltext.wrappedValue != "" ? "POST" : "GET"
        Task.init {
            do {
                let json = try await callCosmosDB(verb:verb, accountName: $accountname.wrappedValue, masterKey: $cosmoskey.wrappedValue, databaseId: $databaseid.wrappedValue, collectionId: $collectionid.wrappedValue, 
                                                  sqlQuery: $sqltext.wrappedValue)
                print("JSON Response: \(json)")
                
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    var body: some View {
        VStack {
            TextField("Enter key", text: $cosmoskey).padding()
            TextField("Enter account name", text: $accountname).padding()
            TextField("database id", text: $databaseid).padding()
            TextField("collectionid", text: $collectionid).padding()
            TextField("sql", text: $sqltext).padding()
            Button("CallCosmos") {
                callCosmos()
            }
        }
    }
}
