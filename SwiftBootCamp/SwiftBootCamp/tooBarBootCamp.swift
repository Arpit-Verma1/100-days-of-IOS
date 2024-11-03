//
//  tooBarBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 02/11/24.
//

import SwiftUI

struct tooBarBootCamp: View {
    var body: some View {
        NavigationStack  {
            ZStack {
                Color.purple.ignoresSafeArea()
                ScrollView {
                    ForEach(0..<10){ _ in
                        
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 100, height: 100, alignment: .leading)
                    }
                }
            }
            .navigationTitle("toolbar")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading,
                            content: {Image(systemName: "heart.fill")})
                ToolbarItem(placement: .navigationBarTrailing,
                            content: {Image(systemName: "heart.fill")})
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

#Preview {
    tooBarBootCamp()
}
