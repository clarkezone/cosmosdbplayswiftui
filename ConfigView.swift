import SwiftUI
import CryptoKit
import Foundation

struct ContentView: View {
    @EnvironmentObject var dataModel: DataModel
    
    var body: some View {
        VStack {
            TextField("Enter key", text: $dataModel.cosmoskey).padding()
            TextField("Enter account name", text: $dataModel.accountname).padding()
            TextField("database id", text: $dataModel.databaseid).padding()
            TextField("collectionid", text: $dataModel.collectionid).padding()
            TextField("sql", text: $dataModel.sqltext).padding()

            NavigationLink(destination: ResultsView()) {
                Text("Load map points")            
            }
        }
        .navigationBarTitle("Config")
        .navigationBarTitleDisplayMode(.inline)
    }
}
