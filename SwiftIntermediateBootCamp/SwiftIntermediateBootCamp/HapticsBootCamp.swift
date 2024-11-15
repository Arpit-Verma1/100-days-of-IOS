//
//  HapticsBootCamp.swift
//  SwiftInterMediateBootCamp
//
//  Created by Arpit Verma on 15/11/24.
//

import SwiftUI

class HapticManager {
    static let instance = HapticManager()
    
    func notification(type : UINotificationFeedbackGenerator.FeedbackType)
    {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style : UIImpactFeedbackGenerator.FeedbackStyle)
    {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

struct HapticsBootCamp: View {
    var body: some View {
        VStack
        {
            Button {
                HapticManager.instance.impact(style: .light)
            } label: {
            Text("light")
            }
            Button {
                HapticManager.instance.impact(style: .medium)
            } label: {
                Text("medium")
            }
            Button {
                HapticManager.instance.impact(style:.heavy)
            } label: {
                Text("heavy")
            }
            
            Button {
                HapticManager.instance.impact(style:.rigid)
            }
          label: {
                Text("rigid")
            }
            Button {
                HapticManager.instance.notification(type: .success)
            } label: {
                Text("success")
            }
                Button {
                HapticManager.instance.notification(type: .warning)
            } label: {
                Text("warning")
            }
            Button {
                HapticManager.instance.notification(type: .error)
            } label: {
                Text("error")
            }

        }
    }
}

#Preview {
    HapticsBootCamp()
}
