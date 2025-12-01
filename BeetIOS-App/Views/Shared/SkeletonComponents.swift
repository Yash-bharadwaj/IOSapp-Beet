import SwiftUI

struct PosterSkeleton: View {
    var body: some View {
        VStack(spacing: 16) {
            SkeletonView(width: nil, height: 400, cornerRadius: 24)
                .aspectRatio(2/3, contentMode: .fit)
            
            // Title skeleton
            SkeletonView(width: 200, height: 28, cornerRadius: 8)
            
            // Info badges skeleton
            HStack(spacing: 12) {
                SkeletonView(width: 80, height: 20, cornerRadius: 10)
                SkeletonView(width: 60, height: 20, cornerRadius: 10)
                SkeletonView(width: 50, height: 20, cornerRadius: 4)
            }
        }
    }
}

struct SeatGridSkeleton: View {
    var body: some View {
        VStack(spacing: 10) {
            // Screen skeleton
            SkeletonView(width: nil, height: 120, cornerRadius: 12)
                .padding(.horizontal, 24)
            
            // Grid skeleton
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 8), spacing: 10) {
                ForEach(0..<64) { _ in
                    SkeletonView(width: nil, height: 24, cornerRadius: 6)
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

struct TicketSkeleton: View {
    var body: some View {
        VStack(spacing: 0) {
            // Top section
            HStack(spacing: 16) {
                SkeletonView(width: 80, height: 120, cornerRadius: 12)
                
                VStack(alignment: .leading, spacing: 8) {
                    SkeletonView(width: 150, height: 20, cornerRadius: 4)
                    SkeletonView(width: 120, height: 14, cornerRadius: 4)
                    SkeletonView(width: 100, height: 14, cornerRadius: 4)
                }
                
                Spacer()
            }
            .padding(20)
            
            // Perforation
            HStack(spacing: 4) {
                ForEach(0..<30) { _ in
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 6, height: 6)
                }
            }
            .frame(height: 1)
            
            // Bottom section
            VStack(spacing: 12) {
                SkeletonView(width: 200, height: 40, cornerRadius: 4)
                SkeletonView(width: 120, height: 12, cornerRadius: 4)
            }
            .padding(20)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

