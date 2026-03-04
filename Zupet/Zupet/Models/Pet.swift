import Foundation
import SwiftUI

struct Pet: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
    let stripeColor: Color
    let height: Double
}

