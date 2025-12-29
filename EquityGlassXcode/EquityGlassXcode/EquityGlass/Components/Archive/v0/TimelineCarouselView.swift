import SwiftUI

struct TimelineCarouselView: View {
    let events: [TimelineEvent]

    private var sortedEvents: [TimelineEvent] {
        events.sorted { $0.date < $1.date }
    }

    var body: some View {
        VStack(spacing: 12) {
            // Carousel with page dots
            TabView {
                ForEach(sortedEvents) { event in
                    TimelineCardView(event: event)
                        .padding(.horizontal)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .frame(height: 280)
        }
    }
}

#Preview {
    TimelineCarouselView(events: [
        TimelineEvent(
            id: UUID(),
            date: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
            type: .advisorMeeting,
            title: "Q1 Planning with Fred",
            description: "Review vest strategy",
            actionable: true
        ),
        TimelineEvent(
            id: UUID(),
            date: Calendar.current.date(byAdding: .day, value: 14, to: Date())!,
            type: .vest,
            title: "RSU Vest: 3,430 shares",
            description: "Execute split",
            actionable: true
        ),
        TimelineEvent(
            id: UUID(),
            date: Calendar.current.date(byAdding: .day, value: 30, to: Date())!,
            type: .taxDeadline,
            title: "Q1 Tax Payment",
            description: "Estimated tax due",
            actionable: true
        )
    ])
    .padding()
}
