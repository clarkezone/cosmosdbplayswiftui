import SwiftUI

@main
struct MyApp: App {
    @StateObject var dataModel = DataModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack() {
                ContentView()
            }
            .environmentObject(dataModel)
            .navigationViewStyle(.stack)
        }
    }
}
