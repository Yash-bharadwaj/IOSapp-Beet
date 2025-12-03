import SwiftUI

struct DateTimeSelectionView: View {
    @Environment(Router.self) private var router
    let movie: Movie
    @State private var selectedDate: Date
    @State private var selectedTime: String?
    @State private var appearAnimation = false
    @State private var showTimeSlots = false
    
    init(movie: Movie) {
        self.movie = movie
        _selectedDate = State(initialValue: Calendar.current.startOfDay(for: Date()))
    }
    
    // Available dates (next 7 days)
    private var availableDates: [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                dates.append(date)
            }
        }
        return dates
    }
    
    // Available showtimes for selected date
    private var availableShowtimes: [String] {
        // Different showtimes for different days (example)
        let allShowtimes = ["10:45 AM", "02:45 PM", "08:00 PM", "10:30 PM"]
        return allShowtimes
    }
    
    // Computed property to check if we should show time slots
    private var shouldShowTimeSlots: Bool {
        showTimeSlots && !availableShowtimes.isEmpty
    }
    
    // MARK: - Helper Methods
    
    func formatDateDay(_ date: Date) -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        return "\(day)"
    }
    
    func formatDateLetter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        let dayLetter = formatter.string(from: date)
        return String(dayLetter.prefix(1))
    }
    
    func isDateSelected(_ date: Date) -> Bool {
        Calendar.current.isDate(selectedDate, inSameDayAs: date)
    }
    
    func isDateToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
        selectedTime = nil // Reset time when date changes
    }
    
    func selectTime(_ time: String) {
        selectedTime = time
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Close Button
                HStack {
                    Button(action: {
                        haptic(.light)
                        router.pop()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .padding(.bottom, 20)
                .zIndex(10)
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Movie Info Card
                        HStack(spacing: 16) {
                            // Movie Poster
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "FF6B35"), Color(hex: "FF4500")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 90, height: 135)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 45))
                                        .foregroundColor(.black.opacity(0.3))
                                )
                            
                            // Movie Details
                            VStack(alignment: .leading, spacing: 6) {
                                // Title
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("the")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                    Text("BAD GUYS")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                
                                // Details
                                Text("2025 · Animation · 96 min")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.top, 2)
                                
                                // IMDb Rating
                                HStack(spacing: 6) {
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(Color(hex: "F5C518"))
                                        .frame(width: 34, height: 15)
                                        .overlay(
                                            Text("IMDb")
                                                .font(.system(size: 8, weight: .bold))
                                                .foregroundColor(.black)
                                        )
                                    if let imdbRating = movie.imdbRating {
                                        Text(String(format: "%.1f", imdbRating))
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.top, 4)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .opacity(appearAnimation ? 1 : 0)
                        .offset(y: appearAnimation ? 0 : -20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: appearAnimation)
                        
                        // When to Watch Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("When to Watch?")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Select date and time")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.gray600)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .opacity(appearAnimation ? 1 : 0)
                        .offset(y: appearAnimation ? 0 : 10)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: appearAnimation)
                        
                        // Date Selection
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(availableDates, id: \.self) { date in
                                    DateButton(
                                        day: formatDateDay(date),
                                        letter: formatDateLetter(date),
                                        isSelected: isDateSelected(date),
                                        isToday: isDateToday(date),
                                        action: {
                                            haptic(.selection)
                                            selectDate(date)
                                            // Show time slots immediately with animation
                                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                                showTimeSlots = true
                                            }
                                        }
                                    )
                                }
                                
                                // Scroll indicator
                                Button(action: {}) {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.gray600)
                                        .frame(width: 56, height: 56)
                                        .background(Color.white.opacity(0.05))
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        .opacity(appearAnimation ? 1 : 0)
                        .offset(y: appearAnimation ? 0 : 10)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: appearAnimation)
                        
                        // Instructional Text - hide when time slots are shown
                        if !shouldShowTimeSlots {
                            Text("Select a day to see the available showtimes")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.gray600)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 8)
                                .opacity(appearAnimation ? 1 : 0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: appearAnimation)
                        }
                        
                        // Time Selection (only show after date is selected)
                        if shouldShowTimeSlots {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(availableShowtimes, id: \.self) { time in
                                    TimeSlotButton(
                                        time: time,
                                        isSelected: selectedTime == time,
                                        action: {
                                            haptic(.selection)
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                selectTime(time)
                                            }
                                        }
                                    )
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                            .padding(.bottom, 20)
                        }
                        
                        Spacer().frame(height: 120)
                    }
                    .padding(.top, 8)
                }
                
                // Continue Button - positioned at bottom with safe area
                VStack(spacing: 0) {
                    // Gradient fade to prevent content from being hidden
                    LinearGradient(
                        colors: [Color.black.opacity(0), Color.black],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 20)
                    .allowsHitTesting(false)
                    
                    Button(action: {
                        guard let time = selectedTime else { return }
                        haptic(.medium)
                        // Navigate to ticket selection (which then goes to seat selection)
                        router.navigate(to: .ticketSelection(movie, time))
                    }) {
                        Text("Continue")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(selectedTime != nil ? .black : .gray600)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                Group {
                                    if selectedTime != nil {
                                        LinearGradient(
                                            colors: [Color(hex: "FFC107"), Color(hex: "FF8C00")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    } else {
                                        LinearGradient(
                                            colors: [Color.gray600.opacity(0.3), Color.gray600.opacity(0.3)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    }
                                }
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 28))
                    }
                    .disabled(selectedTime == nil)
                    .accessibilityLabel("Continue")
                    .accessibilityHint(selectedTime == nil ? "Select a date and time to continue" : "Proceed to ticket selection")
                    .padding(.horizontal, 24)
                    .padding(.bottom, 34)
                    .opacity(appearAnimation ? 1 : 0)
                    .offset(y: appearAnimation ? 0 : 20)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: appearAnimation)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            appearAnimation = true
            // Show time slots after a brief delay since today is selected by default
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    showTimeSlots = true
                }
            }
        }
    }
}

// Date Button Component
struct DateButton: View {
    let day: String
    let letter: String
    let isSelected: Bool
    let isToday: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(day)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(isSelected ? .black : .white)
                Text(letter)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .black.opacity(0.7) : .gray600)
            }
            .frame(width: 56, height: 56)
            .background(
                Group {
                    if isSelected {
                        Color(hex: "FFC107")
                    } else {
                        Color.white.opacity(0.1)
                    }
                }
            )
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(isSelected ? Color.clear : Color.gray600.opacity(0.2), lineWidth: 1)
            )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .accessibilityLabel("Date \(day), \(letter)")
        .accessibilityHint(isSelected ? "Selected date" : isToday ? "Today" : "Double tap to select")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// Time Slot Button Component
struct TimeSlotButton: View {
    let time: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                // Time text on the left
                Text(time)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isSelected ? .black : .white)
                    .padding(.leading, 20)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        isSelected ? 
                            Color.white : 
                            Color(red: 0.15, green: 0.15, blue: 0.15)
                    )
                
                // Additional dark gray rectangle on the right (for visual balance)
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .frame(width: 60)
                    .padding(.trailing, 0)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? 
                            Color.clear : 
                            Color.white.opacity(0.1), 
                        lineWidth: 1
                    )
            )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .accessibilityLabel("Showtime \(time)")
        .accessibilityHint(isSelected ? "Selected showtime" : "Double tap to select")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    DateTimeSelectionView(movie: .badGuys)
        .environment(Router())
}

