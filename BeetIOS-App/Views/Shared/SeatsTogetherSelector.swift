import SwiftUI

struct SeatsTogetherSelector: View {
    @Binding var selectedCount: Int
    let options = [1, 2, 3, 4, 5]
    @State private var showPicker = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showPicker.toggle()
            }
        }) {
            HStack {
                Text("\(selectedCount) Seats Together")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray600)
                    .rotationEffect(.degrees(showPicker ? 180 : 0))
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showPicker)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
        .overlay(alignment: .top) {
            if showPicker {
                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { count in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedCount = count
                                showPicker = false
                            }
                        }) {
                            HStack {
                                Text("\(count) Seats Together")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                if selectedCount == count {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.primaryPurple)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(count == selectedCount ? Color.primaryPurple.opacity(0.1) : Color.clear)
                        }
                        
                        if count != options.last {
                            Divider()
                                .background(Color.white.opacity(0.1))
                        }
                    }
                }
                .background(Color(hex: "1F1F1F"))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                .padding(.top, 50)
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

