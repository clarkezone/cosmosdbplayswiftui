import SwiftUI
import CryptoKit
import Foundation

struct ContentView: View {
    @AppStorage("cosmosmasterkey") private var cosmoskey = ""
    @AppStorage("accountname") private var accountname = ""
    @AppStorage("databaseid") private var databaseid = ""
    @AppStorage("collectionid") private var collectionid = ""
    
    var body: some View {
        VStack {
            Text("Cosmos Key:")
            TextField("Enter key", text: $cosmoskey).padding()
            Text("Accountname:")
            TextField("Enter account name", text: $accountname).padding()
            Text("Database ID:")
            TextField("database id", text: $databaseid).padding()
            Text("Collection id:")
            TextField("collectionid", text: $collectionid).padding()
            Button("CallCosmos") {
                let verb = "POST"
                let sqlQuery = "SELECT top 10 * FROM geocache p order by p.Timestamp desc"
                Task.init {
                    do {
                        let json = try await callCosmosDB(verb:verb, accountName: $accountname.wrappedValue, masterKey: $cosmoskey.wrappedValue, databaseId: $databaseid.wrappedValue, collectionId: $collectionid.wrappedValue, sqlQuery: sqlQuery)
                        print("JSON Response: \(json)")
                        
                    } catch {
                        print("Error: \(error)")
                    }
                }

            }
        }
    }
}
