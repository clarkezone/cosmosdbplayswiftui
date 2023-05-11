import SwiftUI

import SwiftUI
import CryptoKit
import Foundation

struct ResultsView: View {
    @EnvironmentObject var dataModel: DataModel
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack{
                    ForEach($dataModel.items) {
                        $item in
                        NavigationLink(destination: GeoItemView(item:item)) {
                            Text("Item")
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            dataModel.StartLoad()
        })
    }
}
