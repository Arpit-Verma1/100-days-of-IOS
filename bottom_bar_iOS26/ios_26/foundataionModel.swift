//
//  foundataionModel.swift
//  ios_26
//
//  Created by Arpit Verma on 23/06/25.
//

import SwiftUI
import FoundationModels

struct foundataionModel: View {
    @State private var prompt : String = ""
    @State private var answer:  String = ""
    @State private var disableControls : Bool = false
    var body: some View {
        NavigationStack {
            
                ScrollView(.vertical){
                    Text(answer)
                    
                }
                .safeAreaBar(edge: .bottom) {
                    HStack(spacing: 20) {
                        TextField("Prompt",text: $prompt)
                    }
                }
        
            
                Button {
                    Task {
                        guard !prompt.isEmpty else {return}
                        do {
                                let session = LanguageModelSession()
                                disableControls = true
                                
                                let response =  session.streamResponse(to: prompt)
                                for try await chunk in response  {
                                    self.answer = chunk
                                }
                                
                                disableControls = true
                            
                        }
                        catch {
                            disableControls = true
                            print(error.localizedDescription)
                        }
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .frame(width: 50, height: 50    )
                }
                .buttonStyle(.glass)
            
        }.disabled(disableControls)
            .padding(15)
    }
}

#Preview {
    foundataionModel()
}
