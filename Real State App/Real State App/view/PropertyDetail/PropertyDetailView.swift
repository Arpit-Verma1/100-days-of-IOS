//
//  PropertyDetailView.swift
//  Real State App
//
//  Created by Arpit Verma on 1/11/26.
//

import SwiftUI
import AVKit

struct PropertyDetailView: View {
    let property: PropertyModel
    @Environment(\.dismiss) var dismiss
    @State private var showDetailSheet = false
    @State private var selectedDetent: PresentationDetent = .medium
    @State private var isVideoPlaying = false
    @State private var showFloorDetail = false
    @State private var selectedFloorVideo: String = ""
    @State private var selectedFloorNumber: Int = 1
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ZStack(alignment: .top) {
                    CustomVideoPlayerView(videoName: property.video, videoSpeed: 0.25, isPlaying: $isVideoPlaying)
                        .frame(width: geometry.size.width, height: geometry.size.height + 100)
                        .clipped()
                        .ignoresSafeArea(.all)
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left" )
                            .foregroundColor( .white)
                            .font(.system(size: 12, weight: .semibold))
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(.blue.opacity(0.1))
                            )
                    }
                    .glassEffect(.clear)
                    .padding(16)
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image(systemName: "cube.fill" )
                            .foregroundColor( .white)
                            .font(.system(size: 12, weight: .semibold))
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(.blue.opacity(0.1))
                            )
                    }
                    .glassEffect(.clear)
                    .padding(16)
                    .buttonStyle(PlainButtonStyle())
                }
                   
                    }
                }
                .navigationBarBackButtonHidden()
                .sheet(isPresented: $showDetailSheet) {
                    if showFloorDetail == false {
                        PropertyDetailSheetView(
                            property: property,
                            onNavigateToFloorDetail: { videoName, floorNumber in
                                selectedFloorVideo = videoName
                                selectedFloorNumber = floorNumber
                                showFloorDetail = true
                            }
                        )
                        .presentationDetents([.fraction(0.15), .medium, .fraction(0.9)], selection: $selectedDetent)
                        .presentationDragIndicator(.visible)
                    }
                    else {
                        PropertyDetailSheetView(
                            property: property,
                            onNavigateToFloorDetail: { videoName, floorNumber in
                                selectedFloorVideo = videoName
                                selectedFloorNumber = floorNumber
                                //                            showDetailSheet = false
                                showFloorDetail = true
                            }
                        ).presentationDetents([.fraction(0)], selection: $selectedDetent)
                    }
                }
                .onAppear {
                    showDetailSheet = true
                    selectedDetent = .medium
                    isVideoPlaying = false
                }

                .onChange(of: selectedDetent) { oldValue, newValue in
                    if newValue == .fraction(0.15) {
                        isVideoPlaying = true
                    } else if newValue == .medium {
                        isVideoPlaying = false
                    }
                }
                
                if showFloorDetail {
                    FloorDetailView(
                        videoName: selectedFloorVideo,
                        floorNumber: selectedFloorNumber,
                        onClose: {
                            showFloorDetail = false
                        }
                    )
                    .transition(.opacity)
                    .zIndex(100)
                }
            }
        }

}

#Preview {
    PropertyDetailView(
        property: PropertyModel(
            bedCount: 5,
            bathCount: 4,
            propertyName: "Live Oak Meadows",
            monthlyRent: 4500,
            propertyArea: 2155,
            fhaEnable: false,
            singleSotry: true,
            description: "Escape to luxury in this modern architectural gem perched above the coastline. Midnight Ocean Villa offers panoramic ocean views",
            location: "Riverton, NJ",
            image: "real state 3", video: "real state 1.mp4",floors: [ FloorModel(image: "plan1",video : "interior.mp4", name :"Floor 1" ), FloorModel(image: "plan2", video: "interior.mp4", name: "Floor 2"), FloorModel(image: "plan3", video: "interior.mp4", name: "Floor 3")]
        )
    )
}
