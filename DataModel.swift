import SwiftUI

class DataModel: ObservableObject {
    @Published var items: [Document] = []
    
    @AppStorage("cosmosmasterkey") public var cosmoskey = ""
    @AppStorage("accountname") public var accountname = ""
    @AppStorage("databaseid") public var databaseid = ""
    @AppStorage("collectionid") public var collectionid = ""
    @AppStorage("sql") public var sqltext = ""
    private var isLoading = false
    
    public func StartLoad() {
        if (!isLoading) {
            callCosmos()
        } else {
            print("Already loading")
        }
    }
    
    func callCosmos() {
        isLoading=true
        let verb = $sqltext.wrappedValue != "" ? "POST" : "GET"
        Task.init {
            do {
                let json = try await callCosmosDB(verb:verb, accountName: $accountname.wrappedValue, masterKey: $cosmoskey.wrappedValue, databaseId: $databaseid.wrappedValue, collectionId: $collectionid.wrappedValue, 
                                                  sqlQuery: $sqltext.wrappedValue)
                if let mappoints = json as? MyData {
                    for item in mappoints.Documents {
                        items.append(item)
                    }
                } else {
                    print("no dice")
                }
                isLoading=false
                //print("JSON Response: \(json)")
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
}
