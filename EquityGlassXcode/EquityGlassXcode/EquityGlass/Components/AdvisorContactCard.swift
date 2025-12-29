import SwiftUI

struct AdvisorContactCard: View {
    let recommendation: AdvisorRecommendation
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
                // Header with chevron
                HStack {
                    Text("YOUR SCHWAB ADVISOR")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .tracking(0.5)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }

                // Always visible: Advisor name with credentials
                Text(recommendation.fullCredentials)
                    .font(.body.bold())
                    .foregroundStyle(.primary)

            // Expandable contact details
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()

                    // Photo with title and company
                    HStack(alignment: .top, spacing: 12) {
                        // Advisor photo
                        Group {
                            if let photoAsset = recommendation.advisorPhotoAsset {
                                Image(photoAsset)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                // Fallback to system icon if no photo provided
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .strokeBorder(Color.secondary.opacity(0.2), lineWidth: 1)
                        )

                        // Title and company
                        VStack(alignment: .leading, spacing: 4) {
                            if let title = recommendation.advisorTitle {
                                Text(title)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            if let company = recommendation.advisorCompany {
                                Text(company)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }

                    // Contact buttons
                    VStack(spacing: 8) {
                        // Email button
                        Button(action: {
                            // TODO: Email action
                            print("Email \(recommendation.advisorName)")
                        }) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundStyle(.blue)
                                Text("Contact \(recommendation.advisorName)")
                                    .foregroundStyle(.primary)
                                Spacer()
                            }
                            .font(.body)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)

                        // Phone button (premium tier only)
                        if let phone = recommendation.advisorPhone {
                            Button(action: {
                                if URL(string: "tel:\(phone.filter { $0.isNumber })") != nil {
                                    // This would open the phone dialer in a real app
                                    print("Calling \(phone)")
                                }
                            }) {
                                HStack {
                                    Image(systemName: "phone.fill")
                                        .foregroundStyle(.green)
                                    Text("Call \(phone)")
                                        .foregroundStyle(.primary)
                                    Spacer()
                                }
                                .font(.body)
                                .padding()
                                .background(Color.secondary.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)
                        }

                        // Book a meeting button
                        Button(action: {
                            // TODO: Book meeting action
                            print("Book a meeting with \(recommendation.advisorName)")
                        }) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundStyle(.orange)
                                Text("Book a Meeting")
                                    .foregroundStyle(.primary)
                                Spacer()
                            }
                            .font(.body)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded.toggle()
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.primary.opacity(0.05), radius: 4, y: 2)
    }
}

#Preview {
    VStack(spacing: 20) {
        // Premium tier (Alex - has phone and photo)
        AdvisorContactCard(
            recommendation: AdvisorRecommendation(
                advisorName: "Fred",
                advisorFullName: "Fred Amsden",
                advisorTitle: "Senior Wealth Advisor",
                advisorCredentials: "CFP®",
                advisorCompany: "Schwab Private Client",
                advisorPhone: "(650) 555-1212",
                advisorPhotoAsset: "AdvisorAvatar",
                conversationDate: Date(),
                conversationDuration: 22,
                discussionPoints: [],
                recommendationText: "Execute 70/30 split",
                holdPercentage: 0.70,
                sellPercentage: 0.30
            )
        )

        // Standard tier (Marcus - general Schwab line)
        AdvisorContactCard(
            recommendation: AdvisorRecommendation(
                advisorName: "Sofia",
                advisorFullName: "Sofia Patel",
                advisorTitle: "Financial Advisor",
                advisorCredentials: nil,
                advisorCompany: "Schwab",
                advisorPhone: "(800) 555-3852",
                advisorPhotoAsset: "SofiaPatelAvatar",
                conversationDate: Date(),
                conversationDuration: 18,
                discussionPoints: [],
                recommendationText: "Let's discuss your options",
                holdPercentage: 0.60,
                sellPercentage: 0.40
            )
        )
    }
    .padding()
}
