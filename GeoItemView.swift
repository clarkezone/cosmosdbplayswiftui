import SwiftUI
import MapKit

struct GeoItemView: View {
    @State var item: Document
    @State var region: MKCoordinateRegion
    
    init(item:Document) {
        self.item = item
        // TODO these are transposed
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item.Lon, longitude: item.Lat), span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
    }
    
    var body: some View {
        Text("Lat \(item.Lat)")
        Text("Lon \(item.Lon)")
        Map(coordinateRegion: $region).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}
