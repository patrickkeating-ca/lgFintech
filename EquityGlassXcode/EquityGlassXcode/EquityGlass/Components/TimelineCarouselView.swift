import SwiftUI

struct TimelineCarouselView: View {
    let events: [TimelineEvent]
    @State private var currentPage = 0

    private var sortedEvents: [TimelineEvent] {
        events.sorted { $0.date < $1.date }
    }

    private var displayEvents: [TimelineEvent] {
        Array(sortedEvents.prefix(6))
    }

    private var remainingEvents: [TimelineEvent] {
        Array(sortedEvents.dropFirst(6))
    }

    var body: some View {
        VStack(spacing: 12) {
            // Page indicator
            if !sortedEvents.isEmpty {
                HStack(spacing: 4) {
                    Text("Upcoming Events")
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)

                    Spacer()

                    ForEach(0..<min(displayEvents.count + (remainingEvents.isEmpty ? 0 : 1), 7), id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.blue : Color.secondary.opacity(0.4))
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.horizontal)
            }

            // Carousel
            TabView(selection: $currentPage) {
                // Display first 6 events as individual cards
                ForEach(Array(displayEvents.enumerated()), id: \.element.id) { index, event in
                    TimelineCardView(event: event)
                        .padding(.horizontal)
                        .tag(index)
                }

                // "More" card if there are remaining events
                if !remainingEvents.isEmpty {
                    moreCard
                        .padding(.horizontal)
                        .tag(displayEvents.count)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 280)
        }
    }

    var moreCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "ellipsis.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.blue)

                Spacer()

                Text("\(remainingEvents.count)")
                    .font(.title.bold())
                    .foregroundStyle(.blue)
            }

            Text("More Events")
                .font(.title3.bold())

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(remainingEvents) { event in
                        HStack(spacing: 8) {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 6))
                                .foregroundStyle(.secondary)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(event.title)
                                    .font(.subheadline.bold())
                                Text(event.date, style: .date)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.primary.opacity(0.1), radius: 10, y: 5)
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
