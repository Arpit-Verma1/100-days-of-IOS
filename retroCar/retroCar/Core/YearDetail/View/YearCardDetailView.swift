//
//  YearDetailView.swift
//  retroCar
//
//  Created by Arpit Verma on 12/27/25.
//
import SwiftUI

struct YearCardDetailView : View {
    
    @State var yearModel : YearModel
    @State private var showBottomCards: Bool = false
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var isTransitioning: Bool = false
    @State private var currentImageOpacity: Double = 1.0
    @State private var previousImageOpacity: Double = 0.0
    @State private var nextImageOpacity: Double = 0.0
    @State private var bottomCardOffset: CGFloat = 0
    @State private var isExpanded: Bool = false
    @State private var verticalDragOffset: CGFloat = 0
    @State private var yearTextOffset: CGFloat = 0
    @State private var yearTextOpacity: Double = 1.0
    @State private var lineOpacity: Double = 1.0
    @State private var carImageOpacity: Double = 1.0
    @State private var detailRowsOffset: CGFloat = 0
    let allYears: [YearModel]
    var namespace: Namespace.ID
    var onDismiss: () -> Void
    
    var body : some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 1, dampingFraction: 0.8)) {
                        showBottomCards = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onDismiss()
                    }
                }
            
            VStack(alignment: .leading, spacing: 0) {
                CarouselContainerView(currentIndex: $currentIndex, isExpanded: $isExpanded, showBottomCards: $showBottomCards, dragOffset: $dragOffset, isTransitioning: $isTransitioning, currentImageOpacity: $currentImageOpacity, previousImageOpacity: $previousImageOpacity, nextImageOpacity: $nextImageOpacity, bottomCardOffset: $bottomCardOffset, verticalDragOffset: $verticalDragOffset, yearTextOffset: $yearTextOffset, yearTextOpacity: $yearTextOpacity, lineOpacity: $lineOpacity, carImageOpacity: $carImageOpacity, detailRowsOffset: $detailRowsOffset, namespace: namespace, onDismiss: {
                    onDismiss()
                })
                    .fixedSize(horizontal: false, vertical: isExpanded)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if !isTransitioning {
                                    if isExpanded {
                                        handleVerticalDrag(translation: value.translation.height)
                                    } else {
                                        if abs(value.translation.height) > abs(value.translation.width) {
                                            handleVerticalDrag(translation: value.translation.height)
                                        } else {
                                            dragOffset = value.translation.width
                                            updateOpacityDuringDrag(translation: value.translation.width)
                                            updateBottomCardOffset(translation: value.translation.width)
                                        }
                                    }
                                }
                            }
                            .onEnded { value in
                                if !isTransitioning {
                                    if isExpanded {
                                        handleVerticalSwipeEnd(translation: value.translation.height, velocity: value.predictedEndTranslation.height)
                                    } else {
                                        if abs(value.translation.height) > abs(value.translation.width) {
                                            handleVerticalSwipeEnd(translation: value.translation.height, velocity: value.predictedEndTranslation.height)
                                        } else {
                                            handleSwipeEnd(translation: value.translation.width, velocity: value.predictedEndTranslation.width)
                                        }
                                    }
                                }
                            }
                    )
                
                if isExpanded {
                    DetailRowView(yearModel: yearModel)
                        .offset(y: detailRowsOffset)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                if !isExpanded {
                    Spacer()
                    BottomCardView(yearModel: yearModel)
                    .offset(y: showBottomCards ? bottomCardOffset : 200)
                    .opacity(showBottomCards && !isExpanded ? max(0, 1.0 - abs(bottomCardOffset) / 200.0) : (isExpanded ? 0 : 1))
                }
                
            }
            .padding(10)
           
            .onAppear {
                if let index = allYears.firstIndex(where: { $0.id == yearModel.id }) {
                    currentIndex = index
                }
                updateImageOpacities()
                bottomCardOffset = 0
                detailRowsOffset = UIScreen.main.bounds.height
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
                    showBottomCards = true
                    bottomCardOffset = 0
                }
            }
        }
    }
    
    
    private func handleSwipeEnd(translation: CGFloat, velocity: CGFloat) {
        let threshold: CGFloat = 100
        let velocityThreshold: CGFloat = 500
        
        // Determine swipe direction
        if translation > threshold || velocity > velocityThreshold {
            // Swipe right - go to previous
            if currentIndex > 0 {
                transitionToIndex(currentIndex - 1, direction: .right)
            } else {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    dragOffset = 0
                    currentImageOpacity = 1.0
                    previousImageOpacity = 0.0
                    nextImageOpacity = 0.0
                    bottomCardOffset = 0
                }
            }
        } else if translation < -threshold || velocity < -velocityThreshold {
            // Swipe left - go to next
            if currentIndex < allYears.count - 1 {
                transitionToIndex(currentIndex + 1, direction: .left)
            } else {
                // Bounce back if at last item
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    dragOffset = 0
                    currentImageOpacity = 1.0
                    previousImageOpacity = 0.0
                    nextImageOpacity = 0.0
                    bottomCardOffset = 0
                }
            }
        } else {
            // Not enough swipe - bounce back
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                dragOffset = 0
                currentImageOpacity = 1.0
                previousImageOpacity = 0.0
                nextImageOpacity = 0.0
                bottomCardOffset = 0
            }
        }
    }
    
    enum SwipeDirection {
        case left, right
    }
    
    private func transitionToIndex(_ newIndex: Int, direction: SwipeDirection) {
        isTransitioning = true
        let screenWidth = UIScreen.main.bounds.width
        let cardWidth = screenWidth - 40
        
        // If expanded, collapse first
        if isExpanded {
            collapseView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                performHorizontalTransition(to: newIndex)
            }
        } else {
            // Animate bottom card down
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                bottomCardOffset = 200
            }
            
            // After bottom card goes down, update index and animate carousel
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                performHorizontalTransition(to: newIndex)
            }
        }
    }
    
    private func performHorizontalTransition(to newIndex: Int) {
        currentIndex = newIndex
        yearModel = allYears[newIndex]
        
        // Reset drag offset (carousel will reposition based on currentIndex)
        dragOffset = 0
        
        // Update opacities
        currentImageOpacity = 1.0
        previousImageOpacity = 0.0
        nextImageOpacity = 0.0
        
        // Reset vertical animations
        yearTextOffset = 0
        yearTextOpacity = 1.0
        lineOpacity = 1.0
        carImageOpacity = 1.0
        detailRowsOffset = UIScreen.main.bounds.height
        
        // Reset bottom card and bring it back up
        bottomCardOffset = 200
        showBottomCards = true
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            bottomCardOffset = 0
        }
        
        isTransitioning = false
    }
    
    private func updateImageOpacities() {
        // Update opacities based on current index
        // Current image is always visible when not transitioning
        currentImageOpacity = 1.0
        // Previous and next images are always 0 opacity when not transitioning
        previousImageOpacity = 0.0
        nextImageOpacity = 0.0
    }
    
    private func updateOpacityDuringDrag(translation: CGFloat) {
        let screenWidth = UIScreen.main.bounds.width
        let cardWidth = screenWidth - 40
        let progress = abs(translation) / cardWidth
        let clampedProgress = min(progress, 1.0)
        
        if translation < 0 {
            // Swiping left - current fades out, next fades in
            if currentIndex < allYears.count - 1 {
                currentImageOpacity = 1.0 - clampedProgress
                nextImageOpacity = clampedProgress
            }
        } else if translation > 0 {
            // Swiping right - current fades out, previous fades in
            if currentIndex > 0 {
                currentImageOpacity = 1.0 - clampedProgress
                previousImageOpacity = clampedProgress
            }
        }
    }
    
    private func updateBottomCardOffset(translation: CGFloat) {
        let screenWidth = UIScreen.main.bounds.width
        let cardWidth = screenWidth - 40
        let progress = abs(translation) / cardWidth
        let clampedProgress = min(progress, 1.0)
        
        // Bottom card moves down proportionally to drag progress
        bottomCardOffset = clampedProgress * 200
    }
    
    private func handleVerticalDrag(translation: CGFloat) {
        let screenHeight = UIScreen.main.bounds.height
        let progress = abs(translation) / screenHeight
        let clampedProgress = min(progress, 1.0)
        
        if translation < 0 {
            // Swiping up
            if !isExpanded {
                verticalDragOffset = translation
                yearTextOffset = translation * 0.3 // Move year text up
                yearTextOpacity = 1.0 - clampedProgress * 1.5 // Fade out faster
                lineOpacity = 1.0 - clampedProgress * 1.5
                carImageOpacity = 1.0 - clampedProgress * 1.5
                detailRowsOffset = screenHeight * (1.0 - clampedProgress) // Rows come from bottom
                // Bottom card moves down simultaneously as year text goes up
                bottomCardOffset = abs(translation) * 0.5 // Move bottom card down proportionally
            }
        } else {
            // Swiping down
            if isExpanded {
                verticalDragOffset = translation
                yearTextOffset = -abs(translation) * 0.3 // Move year text back down
                yearTextOpacity = clampedProgress * 1.5 // Fade in
                lineOpacity = clampedProgress * 1.5
                carImageOpacity = clampedProgress * 1.5
                detailRowsOffset = translation // Rows go back down
                // Bottom card moves back up as year text comes down
                bottomCardOffset = 200 - abs(translation) * 0.5 // Move bottom card back up
            }
        }
    }
    
    private func handleVerticalSwipeEnd(translation: CGFloat, velocity: CGFloat) {
        let threshold: CGFloat = 100
        let velocityThreshold: CGFloat = 500
        
        if translation < -threshold || velocity < -velocityThreshold {
            // Swipe up - expand
            if !isExpanded {
                expandView()
            } else {
                // Bounce back
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    resetVerticalAnimations()
                }
            }
        } else if translation > threshold || velocity > velocityThreshold {
            // Swipe down - collapse
            if isExpanded {
                collapseView()
            } else {
                // Bounce back
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    resetVerticalAnimations()
                }
            }
        } else {
            // Not enough swipe - bounce back
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                resetVerticalAnimations()
            }
        }
    }
    
    private func expandView() {
        isExpanded = true
        let screenHeight = UIScreen.main.bounds.height
        
        // Animate year text and line moving up and disappearing
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            yearTextOffset = -150
            yearTextOpacity = 0
            lineOpacity = 0
        }
        
        // Animate car image disappearing
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            carImageOpacity = 0
        }
        
        // Animate bottom card going down
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            showBottomCards = false
            bottomCardOffset = 200
        }
        
        // Animate rows coming from bottom
        withAnimation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.2)) {
            detailRowsOffset = 150
        }
        
        verticalDragOffset = 0
    }
    
    private func collapseView() {
        isExpanded = false
        let screenHeight = UIScreen.main.bounds.height
        
        // Animate rows going down
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            detailRowsOffset = screenHeight
        }
        
        // Animate year text and line coming back
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
            yearTextOffset = 0
            yearTextOpacity = 1
            lineOpacity = 1
        }
        
        // Animate car image appearing
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
            carImageOpacity = 1
        }
        
        // Animate bottom card coming back up
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showBottomCards = true
                bottomCardOffset = 0
            }
        }
        
        verticalDragOffset = 0
    }
    
    private func resetVerticalAnimations() {
        if !isExpanded {
            yearTextOffset = 0
            yearTextOpacity = 1
            lineOpacity = 1
            carImageOpacity = 1
            detailRowsOffset = UIScreen.main.bounds.height
            bottomCardOffset = 0
        } else {
            yearTextOffset = -150
            yearTextOpacity = 0
            lineOpacity = 0
            carImageOpacity = 0
            detailRowsOffset = 0
            bottomCardOffset = 200
        }
        verticalDragOffset = 0
    }
}

#Preview {
    @Previewable @Namespace var namespace
    YearCardDetailView(
        yearModel: sampleYear,
        allYears: years,
        namespace: namespace,
        onDismiss: {}
   )
}
