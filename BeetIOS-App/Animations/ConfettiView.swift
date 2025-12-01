import SwiftUI
import UIKit

/// Confetti animation view for celebration effects.
/// Displays animated particles falling from top to bottom.
struct ConfettiView: View {
    @State private var animate = false
    
    // Animation constants
    private let particleCount = 50
    private let particleSize: CGFloat = 10
    private let startYOffset: CGFloat = -50
    private let endYOffset: CGFloat = 50
    private let minDuration: Double = 3.0
    private let maxDuration: Double = 5.0
    private let maxRotation: Double = 360.0
    
    var body: some View {
        ZStack {
            ForEach(0..<particleCount, id: \.self) { index in
                ConfettiParticle(
                    particleSize: particleSize,
                    startYOffset: startYOffset,
                    endYOffset: endYOffset,
                    minDuration: minDuration,
                    maxDuration: maxDuration,
                    maxRotation: maxRotation
                )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct ConfettiParticle: View {
    @State private var location: CGPoint
    @State private var rotation: Double = 0
    
    let colors: [Color] = [.red, .blue, .green, .yellow, .pink, .purple, .orange]
    let color: Color
    let particleSize: CGFloat
    let startYOffset: CGFloat
    let endYOffset: CGFloat
    let minDuration: Double
    let maxDuration: Double
    let maxRotation: Double
    
    init(
        particleSize: CGFloat,
        startYOffset: CGFloat,
        endYOffset: CGFloat,
        minDuration: Double,
        maxDuration: Double,
        maxRotation: Double
    ) {
        let startX = CGFloat.random(in: 0...UIScreen.main.bounds.width)
        _location = State(initialValue: CGPoint(x: startX, y: startYOffset))
        color = colors.randomElement() ?? .red
        self.particleSize = particleSize
        self.startYOffset = startYOffset
        self.endYOffset = endYOffset
        self.minDuration = minDuration
        self.maxDuration = maxDuration
        self.maxRotation = maxRotation
    }
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: particleSize, height: particleSize)
            .rotationEffect(.degrees(rotation))
            .position(location)
            .onAppear {
                withAnimation(
                    Animation.linear(duration: Double.random(in: minDuration...maxDuration))
                        .repeatForever(autoreverses: false)
                ) {
                    location = CGPoint(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: UIScreen.main.bounds.height + endYOffset
                    )
                    rotation = Double.random(in: 0...maxRotation)
                }
            }
    }
}

