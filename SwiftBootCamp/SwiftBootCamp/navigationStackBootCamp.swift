//
//  navigationStackBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 02/11/24.
//

import SwiftUI

struct navigationStackBootCamp: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40, content: {
                    ForEach(0..<10) { value in
                        NavigationLink(value:value) {
                            Text("click me \(value)")
                        }
                    }
                })
            }
            .navigationTitle("nav bootcamp")
            .navigationDestination(for: Int.self) { value in
                secScreen(value:value)
            }
        }
    }
}

struct secScreen : View {
    let value : Int
    init(value: Int) {
        self.value = value
    }
    var body : some View {
        VStack {
            Text("\(value)")
        }
    }
}

#Preview {
    navigationStackBootCamp()
}
