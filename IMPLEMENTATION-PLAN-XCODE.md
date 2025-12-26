# Implementation Plan: Vest Execution Screen (iOS SwiftUI)

## Overview

This document outlines the implementation plan for the vest execution screen in the iOS app, based on the finalized HTML mockups (`robinhood-mockup-alex-v2.html`). The screen supports two user tiers with the same structure but personalized content.

---

## Personas & Scenarios

### Alex (Premium Tier - Schwab Private Client)
- **Vest Amount:** $384,777 (3,430 shares @ $112.18)
- **Advisor:** Fred Amsden, CFP® - Senior Wealth Advisor
- **Contact:** Direct line: (650) 555-1212
- **Scenario:** Tax withholding and charitable giving coordination
- **Discussion Points:** Tax-loss harvesting, donor-advised fund strategy, Q1 charitable giving, 70/30 execution timing
- **Recommendation:** Hold 70% for diversified portfolio, Sell 30% for tax withholding and charitable contributions

### Marcus (Standard Tier)
- **Vest Amount:** $67,000 (estimated - adjust to actual)
- **Advisor:** Sofia [Last Name] (or similar) - Financial Advisor
- **Contact:** Shared support line: (800) 555-XXXX (not direct line)
- **Scenario:** House down payment
- **Discussion Points:** Down payment timing and cash needs, diversification strategy, ESPP contribution decisions, balancing short-term (house) and long-term goals
- **Recommendation:** Similar structure, personalized to Marcus's goals

**Key Difference:** Both get recommendations from financial advisors. Premium tier gets senior wealth advisor with direct access. Standard tier gets financial advisor with shared support line. Both have "Request Changes" option.

---

## Screen Hierarchy (Finalized)

```
1. Stock Price Header
   ├─ Ticker (STBT)
   ├─ Current Price ($112.18)
   └─ Daily Change (+$2.45, +2.23%)

2. About This Plan (Collapsible)
   ├─ Conversation with [Advisor Name, Credentials]
   ├─ Date & Duration
   ├─ Plan Overview (one-liner)
   └─ Discussion Notes (expandable)

3. Upcoming Vest Card
   ├─ Label: "Upcoming Vest"
   ├─ Share Count (3,430 shares - prominent, centered, tappable)
   ├─ Vest Date with Countdown (Vest Date: Feb 6, 48 days)
   └─ Tap Hint (Tap for estimated value and tax)

4. Execution Timeline (Collapsible)
   ├─ Vest Date (Feb 6) - 3,430 shares vest. Held in brokerage account.
   ├─ Modify/Cancel Deadline (Feb 13) - Last day to change or cancel plan
   ├─ Blackout Period (Feb 17-18) - Trading restricted (earnings/announcements)
   └─ Execution Date (Feb 27) - 1,029 shares sold. Funds available same day.

5. Trade Plan Recommendation
   ├─ Hold: 2,401 shares → Portfolio
   └─ Sell: 1,029 shares → Checking account

6. Primary Action
   └─ [Review and Approve Plan] button

7. Secondary Action
   └─ [Request Changes] button

8. Your [Tier] Advisor (Collapsible)
   ├─ Advisor Name & Credentials
   ├─ Title & Division
   └─ Contact Options (Message, Call, Book Meeting)
```

---

## Data Model

### VestEvent Model (Update Existing)

```swift
struct VestEvent: Identifiable, Codable {
    let id: UUID
    let vestDate: Date
    let companyName: String
    let ticker: String
    let sharesVesting: Int
    let stockPrice: Double
    let stockPriceLastUpdated: Date
    let estimatedValue: Double

    // Advisor & Recommendation
    let advisorRecommendation: AdvisorRecommendation?

    // Tax Estimate
    let taxEstimate: TaxEstimate?

    // Timeline & History
    let timelineEvents: [TimelineEvent]?
    let vestHistory: [VestHistoryItem]?

    // NEW: Execution Plan
    let executionPlan: ExecutionPlan?
}
```

### NEW: ExecutionPlan Model

```swift
struct ExecutionPlan: Codable {
    let vestDate: Date
    let modifyCancelDeadline: Date
    let blackoutPeriod: DateInterval?  // Optional - not all vests have blackout
    let executionDate: Date

    let holdShares: Int
    let sellShares: Int
    let holdDestination: String        // "Portfolio"
    let sellDestination: String        // "Checking account"

    let canModify: Bool                // Until modify deadline
    let canCancel: Bool                // Until modify deadline

    var cancelDestination: String {    // Computed property
        return "brokerage account"
    }
}
```

### AdvisorRecommendation Model (Update Existing)

```swift
struct AdvisorRecommendation: Codable {
    // Advisor Info
    let advisorName: String            // "Fred" or "Sofia"
    let advisorFullName: String        // "Fred Amsden" or "Sofia [Last Name]"
    let advisorTitle: String           // "Senior Wealth Advisor" vs "Financial Advisor"
    let advisorCredentials: String?    // "CFP®" (optional)
    let advisorCompany: String         // "Schwab Private Client" vs "Schwab Wealth Services"
    let advisorPhone: String           // "(650) 555-1212" vs "(800) 555-XXXX"

    // NEW: Contact type
    let contactType: ContactType       // .directLine vs .sharedSupport

    // Conversation Details
    let conversationDate: Date
    let conversationDuration: Int      // minutes
    let discussionPoints: [String]

    // Recommendation
    let recommendationText: String
    let holdPercentage: Double
    let sellPercentage: Double
}

enum ContactType: String, Codable {
    case directLine = "Direct Line"
    case sharedSupport = "Support Line"
}
```

### TaxEstimate Model (Update Existing)

```swift
struct TaxEstimate: Codable {
    let grossValue: Double

    let federalTax: Double
    let federalRate: Double

    let stateTax: Double               // NEW: CA state tax
    let stateRate: Double              // NEW: e.g., 0.11
    let stateName: String              // NEW: "CA"

    let ficaTax: Double
    let ficaRate: Double

    var netAfterAllTaxes: Double {     // Computed property
        return grossValue - federalTax - stateTax - ficaTax
    }
}
```

---

## SwiftUI Component Mapping

### HTML → Swift Component Mapping

| HTML Element | Swift Component | Location |
|--------------|----------------|----------|
| Stock ticker/price header | `StockPriceHeader` | Existing component |
| "About This Plan" section | `AboutThisPlanCard` | **NEW** |
| Upcoming Vest card | `UpcomingVestCard` | **NEW** (replaces existing VestCard) |
| Execution Timeline | `ExecutionTimelineCard` | **NEW** |
| Trade Plan Recommendation | `TradeRecommendationCard` | **NEW** |
| Review and Approve button | `PrimaryActionButton` | **NEW** |
| Request Changes button | `SecondaryActionButton` | **NEW** |
| Your Advisor section | `AdvisorContactCard` | **NEW** |
| Approval Modal | `ApprovalConfirmationSheet` | **NEW** |
| Vest Details Modal | `VestDetailsSheet` | **NEW** |

---

## Component Specifications

### 1. AboutThisPlanCard

**Purpose:** Show advisor conversation context with progressive disclosure

**Props:**
```swift
struct AboutThisPlanCard: View {
    let recommendation: AdvisorRecommendation
    @State private var isExpanded = false

    var body: some View { ... }
}
```

**Layout:**
```
┌─────────────────────────────────────┐
│ ABOUT THIS PLAN               [▼]   │
├─────────────────────────────────────┤
│ Conversation with Fred Amsden, CFP®│
│ Dec 18, 28 min                      │
│                                     │
│ Hold 70% for diversified portfolio, │
│ sell 30% for tax withholding and    │
│ charitable giving                   │
│                                     │
│ Tap for notes                       │
├─────────────────────────────────────┤
│ [EXPANDED STATE]                    │
│ DISCUSSION NOTES                    │
│ • Tax withholding strategy...       │
│ • Charitable giving coordination... │
│ • Diversification and concentration │
│ • 70/30 split balances tax...       │
└─────────────────────────────────────┘
```

**Key Details:**
- Card background: `.regularMaterial`
- Tap anywhere on card to expand/collapse
- Rotation animation on caret (0° → 180°)
- Spring animation on expansion
- Font: `.caption.bold()` for "ABOUT THIS PLAN"
- Font: `.subheadline` for meta, `.body` for overview

---

### 2. UpcomingVestCard

**Purpose:** Display vest amount prominently with tap-to-reveal details

**Props:**
```swift
struct UpcomingVestCard: View {
    let vest: VestEvent
    @State private var showVestDetails = false

    var body: some View { ... }
}
```

**Layout:**
```
┌─────────────────────────────────────┐
│ UPCOMING VEST                       │
│                                     │
│           3,430 shares              │  ← Large, centered, tappable
│                                     │
│     Vest Date: Feb 6 (48 days)     │  ← Centered
│                                     │
│   Tap for estimated value and tax  │  ← Hint text
└─────────────────────────────────────┘
```

**Key Details:**
- Share count: `.largeTitle.bold()`, centered, tappable
- Vest date: `.body`, centered, includes countdown
- Tap hint: `.caption`, `.secondary` color
- Tap gesture on shares opens `VestDetailsSheet`
- Background: `.regularMaterial`
- Padding: 24pt all sides

---

### 3. ExecutionTimelineCard

**Purpose:** Show key milestones with progressive disclosure

**Props:**
```swift
struct ExecutionTimelineCard: View {
    let executionPlan: ExecutionPlan
    @State private var isExpanded = false

    var body: some View { ... }
}
```

**Layout (Collapsed):**
```
┌─────────────────────────────────────┐
│ Execution Timeline            [▼]   │
└─────────────────────────────────────┘
```

**Layout (Expanded):**
```
┌─────────────────────────────────────┐
│ Execution Timeline            [▲]   │
├─────────────────────────────────────┤
│ 📅  VEST DATE                       │
│     Feb 6, 2026                     │
│     3,430 shares vest. Held in      │
│     brokerage account.              │
│                                     │
│ ✓  MODIFY/CANCEL DEADLINE           │
│     Feb 13, 2026                    │
│     Last day to change or cancel    │
│                                     │
│ ⚠️  BLACKOUT PERIOD                 │
│     Feb 17-18, 2026                 │
│     Trading restricted (earnings)   │
│                                     │
│ 🕐  EXECUTION DATE                  │
│     Feb 27, 2026                    │
│     1,029 shares sold. Funds        │
│     available same day.             │
└─────────────────────────────────────┘
```

**Icons:**
- Vest Date: Calendar (green) - `Image(systemName: "calendar")`
- Modify/Cancel: Calendar with checkmark (gray) - `Image(systemName: "calendar.badge.checkmark")`
- Blackout: Warning (orange) - `Image(systemName: "exclamationmark.triangle.fill")`
- Execution: Clock (green) - `Image(systemName: "clock.fill")`

**Key Details:**
- Background: `.ultraThinMaterial` (darker than card)
- Icon size: 20x20pt
- Label: `.caption.uppercased()`, `.secondary`
- Value: `.body.bold()`
- Description: `.subheadline`, `.secondary`
- Spacing: 16pt between items
- Spring animation on expand/collapse

---

### 4. TradeRecommendationCard

**Purpose:** Display hold/sell split clearly

**Props:**
```swift
struct TradeRecommendationCard: View {
    let executionPlan: ExecutionPlan

    var body: some View { ... }
}
```

**Layout:**
```
┌─────────────────────────────────────┐
│ TRADE PLAN RECOMMENDATION           │
├─────────────────────────────────────┤
│  ┌──────────┐     ┌──────────┐     │
│  │   HOLD   │     │   SELL   │     │
│  │  2,401   │     │  1,029   │     │
│  │  shares  │     │  shares  │     │
│  │          │     │          │     │
│  │→Portfolio│     │→Checking │     │
│  └──────────┘     └──────────┘     │
└─────────────────────────────────────┘
```

**Key Details:**
- Label: `.caption.bold()`, `.secondary`
- Split boxes: `.ultraThinMaterial`, rounded corners (12pt)
- Action label (HOLD/SELL): `.caption.uppercased()`, `.secondary`
- Share count: `.title3.bold()`
- Destination: `.caption`, `.secondary`
- HStack spacing: 8pt
- Equal width boxes (50% each)

---

### 5. PrimaryActionButton & SecondaryActionButton

**Props:**
```swift
struct PrimaryActionButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.green)  // Schwab green
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 28))
        }
    }
}

struct SecondaryActionButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.body.weight(.semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.clear)
                .foregroundColor(.primary)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                )
        }
    }
}
```

---

### 6. AdvisorContactCard

**Purpose:** Provide access to advisor with progressive disclosure

**Props:**
```swift
struct AdvisorContactCard: View {
    let recommendation: AdvisorRecommendation
    @State private var isExpanded = false

    var body: some View { ... }
}
```

**Layout (Collapsed):**
```
┌─────────────────────────────────────┐
│ YOUR SCHWAB ADVISOR           [▼]   │
│                                     │
│ Fred Amsden, CFP®                   │
└─────────────────────────────────────┘
```

**Layout (Expanded):**
```
┌─────────────────────────────────────┐
│ YOUR SCHWAB ADVISOR           [▲]   │
│                                     │
│ Fred Amsden, CFP®                   │
│ Senior Wealth Advisor               │
│ Schwab Private Client               │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 📧 Contact Fred                 │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 📞 Call (650) 555-1212          │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 📅 Book a Meeting               │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

**Key Details:**
- Header: `.caption.uppercased()`, `.secondary`
- Name: `.title3.bold()`
- Title: `.body`, `.secondary`
- Division: `.subheadline`, `.tertiary`
- Contact buttons: 44pt height, `.secondary` border
- Button icons: SF Symbols
- Marcus version: Shows shared support number, different title

---

### 7. ApprovalConfirmationSheet

**Purpose:** Final confirmation before authorization

**Props:**
```swift
struct ApprovalConfirmationSheet: View {
    let vest: VestEvent
    let executionPlan: ExecutionPlan
    let recommendation: AdvisorRecommendation
    @Binding var isPresented: Bool
    let onConfirm: () -> Void

    var body: some View { ... }
}
```

**Layout:**
```
┌─────────────────────────────────────┐
│ Confirm Authorization         [Done]│
├─────────────────────────────────────┤
│ TRADE PLAN RECOMMENDATION           │
│ Hold: 2,401 shares → Portfolio      │
│ Sell: 1,029 shares → Checking       │
│ Execution Date: Feb 27, 2026        │
├─────────────────────────────────────┤
│ WHAT HAPPENS NEXT                   │
│ Fred will execute this plan on your │
│ behalf on Feb 27, 2026. By          │
│ authorizing, you are putting this   │
│ plan in motion.                     │
├─────────────────────────────────────┤
│ YOUR CONTROL                        │
│                                     │
│ ✏️  CHANGE PLAN                     │
│     Request changes anytime until   │
│     Feb 13, 2026                    │
│                                     │
│ ❌  CANCEL PLAN                     │
│     Cancel anytime until Feb 13,    │
│     2026                            │
│                                     │
│ If cancelled: All 3,430 shares will │
│ be held in your brokerage account   │
│ (100% hold).                        │
├─────────────────────────────────────┤
│ By confirming, you agree to Schwab's│
│ Terms & Conditions and authorize    │
│ this transaction.                   │
├─────────────────────────────────────┤
│ [Confirm Authorization]             │
│ [Go Back]                           │
└─────────────────────────────────────┘
```

**Key Details:**
- Presented as `.sheet`
- Navigation bar with "Done" button (closes without confirming)
- Section dividers: `.secondary` color, 1pt
- "What Happens Next" background: `.ultraThinMaterial`
- T&C link: Tappable, opens Safari/in-app browser
- Confirm button: Green, prominent
- Go Back button: Secondary style
- On confirm: Close sheet, show success alert, update state

---

### 8. VestDetailsSheet

**Purpose:** Show estimated value and complete tax breakdown

**Props:**
```swift
struct VestDetailsSheet: View {
    let vest: VestEvent
    @Binding var isPresented: Bool

    var body: some View { ... }
}
```

**Layout:**
```
┌─────────────────────────────────────┐
│ Vest Value Breakdown          [Done]│
├─────────────────────────────────────┤
│ ESTIMATE                            │
│ Total Shares          3,430         │
│ Current Stock Price   $112.18       │
│ Estimated Value       ~$384,777     │
│                                     │
│ Value will change based on stock    │
│ price at vest date (Feb 6, 2026)    │
├─────────────────────────────────────┤
│ TAX WITHHOLDING (EST.)              │
│ Federal Tax (27.7%)   ~$106,583     │
│ CA State Tax (11%)    ~$42,326      │
│ FICA (1.5%)          ~$5,772        │
│ ─────────────────────────────────── │
│ Net After Taxes       ~$230,096     │
│                                     │
│ Tax withholding automatically       │
│ deducted at vest. Consult tax       │
│ advisor for specific situation.     │
├─────────────────────────────────────┤
│ [Got It]                            │
└─────────────────────────────────────┘
```

**Key Details:**
- Presented as `.sheet`
- Section titles: `.caption.uppercased()`, `.secondary`
- Row layout: HStack with `.spaceBetween` alignment
- Label: `.body`, `.secondary`
- Value: `.body.bold()`
- Divider before "Net After Taxes"
- Disclaimer: `.caption`, `.secondary`, light background
- "Got It" button: Primary style, closes sheet

---

## Progressive Implementation Phases

### Phase 1: Data Model & Infrastructure (Week 1)

**Goal:** Set up data structures and backend connections

**Tasks:**
1. Update `VestEvent` model with new fields
   - Add `executionPlan: ExecutionPlan?`
   - Ensure backward compatibility with existing JSON

2. Create `ExecutionPlan` model
   - Implement all properties
   - Add computed properties for destinations
   - Write unit tests

3. Update `AdvisorRecommendation` model
   - Add `contactType` enum
   - Add phone number field
   - Support both Fred and Sofia scenarios

4. Update `TaxEstimate` model
   - Add state tax fields
   - Add `netAfterAllTaxes` computed property
   - Update JSON parsing

5. Create JSON data files
   - `scenario-alex-v2.json` (Premium tier with Fred)
   - `scenario-marcus-v2.json` (Standard tier with Sofia)
   - Include all timeline dates, blackout periods, execution plans

6. Update `DataStore` service
   - Load new JSON structure
   - Handle optional fields gracefully
   - Add loading states for async operations

**Deliverables:**
- ✅ Updated models with proper Codable conformance
- ✅ JSON test data for both personas
- ✅ Unit tests passing
- ✅ No regression in existing functionality

---

### Phase 2: Core UI Components (Week 2)

**Goal:** Build reusable SwiftUI components

**Tasks:**
1. Create `AboutThisPlanCard`
   - Collapsible expansion
   - Rotation animation on caret
   - Spring animation on content
   - Extract discussion points as bullet list

2. Create `UpcomingVestCard`
   - Prominent share count display
   - Countdown calculation
   - Tap gesture handling
   - Pass vest data to modal

3. Create `ExecutionTimelineCard`
   - Collapsible timeline
   - Icon selection based on milestone type
   - Color coding (green = action, orange = warning, gray = deadline)
   - Optional blackout period (only show if exists)

4. Create `TradeRecommendationCard`
   - Equal-width split boxes
   - Material background
   - Clear labeling

5. Create button components
   - `PrimaryActionButton` (green)
   - `SecondaryActionButton` (outline)
   - Reusable across app

6. Create `AdvisorContactCard`
   - Collapsible advisor details
   - Contact buttons (message, call, book)
   - Handle different advisor tiers
   - Phone number tap → Call action

**Deliverables:**
- ✅ All components built and tested in isolation
- ✅ SwiftUI Previews for each component
- ✅ Accessibility labels and hints
- ✅ Dark mode support verified
- ✅ Dynamic Type support

---

### Phase 3: Modal Sheets (Week 3)

**Goal:** Implement confirmation and detail modals

**Tasks:**
1. Create `ApprovalConfirmationSheet`
   - Plan summary section
   - "What Happens Next" explanation
   - Control options (change/cancel)
   - Explicit cancellation destination
   - T&C link (opens Safari/WebView)
   - Confirm/Go Back buttons
   - State management for confirmation flow

2. Create `VestDetailsSheet`
   - Estimate section with disclaimer
   - Tax breakdown (Federal, State, FICA)
   - Net after all taxes calculation
   - "Got It" button to dismiss

3. Implement modal presentation logic
   - State management with `@State` and `@Binding`
   - Sheet presentation modifiers
   - Dismiss gestures
   - Prevent accidental dismissal during confirmation

4. Handle success/error states
   - Success alert after confirmation
   - Error handling for network issues
   - Loading states during submission

**Deliverables:**
- ✅ Both modals fully functional
- ✅ Proper state management
- ✅ Graceful error handling
- ✅ Success feedback to user

---

### Phase 4: Main Screen Assembly (Week 4)

**Goal:** Assemble components into complete vest execution screen

**Tasks:**
1. Create main `VestExecutionView`
   - NavigationStack wrapper
   - Scroll view with all components in order
   - State management for all modals
   - Action handlers for buttons

2. Implement navigation flow
   - Entry point from home/dashboard
   - Pass `VestEvent` data
   - Handle deep linking (if needed)

3. Wire up all interactions
   - Tap on shares → `VestDetailsSheet`
   - "Review and Approve Plan" → `ApprovalConfirmationSheet`
   - "Request Changes" → Contact advisor flow
   - Advisor contact buttons → Message/Call/Book actions

4. Implement confirmation flow
   - On confirm: Submit to backend API
   - Show success message
   - Update UI state (show "Plan Authorized" badge?)
   - Navigate back or show post-confirmation screen

5. Add "Request Changes" functionality
   - Message composer (if using Messages framework)
   - Or: Email composer with pre-filled recipient
   - Or: In-app messaging to advisor

**Deliverables:**
- ✅ Fully functional vest execution screen
- ✅ All user interactions working
- ✅ Proper navigation flow
- ✅ Data persistence (if needed)

---

### Phase 5: Tier-Specific Customization (Week 5)

**Goal:** Support both Premium (Alex) and Standard (Marcus) tiers

**Tasks:**
1. Implement tier detection
   - Read from user profile/account data
   - Or: Pass tier as parameter to view

2. Conditional rendering based on tier
   - Premium: Fred Amsden, CFP®, Senior Wealth Advisor, Direct line
   - Standard: Sofia [Last Name], Financial Advisor, Support line

3. Scenario-specific content
   - Alex: Tax withholding and charitable giving discussion points
   - Marcus: House down payment discussion points
   - Load from JSON based on user ID or scenario ID

4. Contact flow differentiation
   - Premium: Direct message to Fred, direct call, book with Fred
   - Standard: Message to support, call support line, book with available advisor

5. Testing with both personas
   - Test Alex scenario end-to-end
   - Test Marcus scenario end-to-end
   - Verify all content is personalized correctly

**Deliverables:**
- ✅ Tier-based rendering working
- ✅ Both personas tested thoroughly
- ✅ No hardcoded assumptions about tier

---

### Phase 6: Polish & Accessibility (Week 6)

**Goal:** Ensure production-ready quality

**Tasks:**
1. Accessibility audit
   - VoiceOver testing
   - Dynamic Type support (test at largest sizes)
   - Color contrast verification
   - Accessibility labels for all interactive elements
   - Hints for complex gestures (tap to expand, etc.)

2. Performance optimization
   - Lazy loading for heavy components
   - Image optimization (advisor avatars)
   - Reduce re-renders where possible

3. Error handling
   - Network failures (retry logic)
   - Missing data (graceful degradation)
   - Invalid state transitions

4. Edge cases
   - Vest date in the past
   - Modify deadline already passed
   - Blackout period currently active
   - Multiple vests on same date

5. User testing
   - Internal QA testing
   - Beta testing with real users (if possible)
   - Gather feedback on clarity and flow

6. Final polish
   - Animation tuning (spring tension, duration)
   - Spacing consistency
   - Typography refinement
   - Icon consistency

**Deliverables:**
- ✅ Accessibility score: A+ (VoiceOver, Dynamic Type, Contrast)
- ✅ All edge cases handled gracefully
- ✅ Performance benchmarks met
- ✅ User testing feedback addressed

---

## API/Backend Requirements

### Endpoints Needed

#### 1. GET /api/vests/{userId}/upcoming

**Purpose:** Fetch upcoming vest with execution plan

**Response:**
```json
{
  "id": "UUID",
  "vestDate": "2026-02-06T09:00:00Z",
  "sharesVesting": 3430,
  "stockPrice": 112.18,
  "executionPlan": {
    "vestDate": "2026-02-06T09:00:00Z",
    "modifyCancelDeadline": "2026-02-13T23:59:59Z",
    "blackoutPeriod": {
      "start": "2026-02-17T00:00:00Z",
      "end": "2026-02-18T23:59:59Z"
    },
    "executionDate": "2026-02-27T09:00:00Z",
    "holdShares": 2401,
    "sellShares": 1029
  },
  "advisorRecommendation": {
    "advisorName": "Fred",
    "advisorFullName": "Fred Amsden",
    "advisorTitle": "Senior Wealth Advisor",
    "advisorCredentials": "CFP®",
    "contactType": "directLine",
    "advisorPhone": "(650) 555-1212",
    "conversationDate": "2025-12-18T14:30:00Z",
    "conversationDuration": 22,
    "discussionPoints": [
      "Tax withholding strategy and timing",
      "Charitable giving coordination for Q1",
      "Diversification and concentration risk management",
      "70/30 split balances tax efficiency and long-term growth"
    ],
    "recommendationText": "Hold 70% for diversified portfolio, sell 30% for tax withholding and charitable giving",
    "holdPercentage": 0.70,
    "sellPercentage": 0.30
  },
  "taxEstimate": {
    "grossValue": 384777.40,
    "federalTax": 106583.34,
    "federalRate": 0.277,
    "stateTax": 42325.51,
    "stateRate": 0.11,
    "stateName": "CA",
    "ficaTax": 5771.66,
    "ficaRate": 0.015
  }
}
```

#### 2. POST /api/vests/{vestId}/authorize

**Purpose:** Submit authorization for execution plan

**Request:**
```json
{
  "vestId": "UUID",
  "executionPlanId": "UUID",
  "agreedToTerms": true,
  "timestamp": "2025-12-25T10:00:00Z"
}
```

**Response:**
```json
{
  "success": true,
  "authorizationId": "UUID",
  "confirmationNumber": "VE-2026-0206-3430",
  "message": "Plan authorized. Fred will execute on Feb 27, 2026.",
  "canModifyUntil": "2026-02-13T23:59:59Z"
}
```

#### 3. POST /api/vests/{vestId}/request-changes

**Purpose:** Send change request to advisor

**Request:**
```json
{
  "vestId": "UUID",
  "message": "I'd like to discuss adjusting the split to 60/40 instead of 70/30.",
  "preferredContact": "phone",  // "phone", "email", "message"
  "urgency": "normal"            // "normal", "urgent"
}
```

**Response:**
```json
{
  "success": true,
  "ticketId": "CHG-12345",
  "advisorName": "Fred Amsden",
  "estimatedResponse": "Within 1 business day",
  "message": "Change request submitted to Fred Amsden."
}
```

#### 4. DELETE /api/vests/{vestId}/authorization/{authorizationId}

**Purpose:** Cancel authorization (before modify deadline)

**Request:** (Empty body)

**Response:**
```json
{
  "success": true,
  "message": "Authorization cancelled. All 3,430 shares will be held in your brokerage account.",
  "cancellationTimestamp": "2025-12-28T15:30:00Z"
}
```

---

## File Structure (Xcode Project)

```
EquityGlassXcode/
├── EquityGlassXcode/
│   ├── EquityGlass/
│   │   ├── Models/
│   │   │   ├── VestEvent.swift (UPDATE)
│   │   │   ├── ExecutionPlan.swift (NEW)
│   │   │   ├── AdvisorRecommendation.swift (UPDATE)
│   │   │   ├── TaxEstimate.swift (UPDATE)
│   │   │   └── TimelineEvent.swift (existing)
│   │   │
│   │   ├── Views/
│   │   │   ├── VestExecution/
│   │   │   │   ├── VestExecutionView.swift (NEW - main screen)
│   │   │   │   ├── AboutThisPlanCard.swift (NEW)
│   │   │   │   ├── UpcomingVestCard.swift (NEW)
│   │   │   │   ├── ExecutionTimelineCard.swift (NEW)
│   │   │   │   ├── TradeRecommendationCard.swift (NEW)
│   │   │   │   ├── AdvisorContactCard.swift (NEW)
│   │   │   │   ├── ApprovalConfirmationSheet.swift (NEW)
│   │   │   │   └── VestDetailsSheet.swift (NEW)
│   │   │   │
│   │   │   ├── Shared/
│   │   │   │   ├── PrimaryActionButton.swift (NEW)
│   │   │   │   ├── SecondaryActionButton.swift (NEW)
│   │   │   │   └── StockPriceHeader.swift (existing)
│   │   │   │
│   │   │   └── ContentView.swift (UPDATE - add navigation to VestExecutionView)
│   │   │
│   │   ├── Services/
│   │   │   ├── DataStore.swift (UPDATE)
│   │   │   ├── APIService.swift (NEW - handle backend calls)
│   │   │   └── AuthService.swift (existing - for authorization tokens)
│   │   │
│   │   └── Resources/
│   │       └── Data/
│   │           ├── scenario-alex-v2.json (NEW)
│   │           └── scenario-marcus-v2.json (NEW)
│   │
│   └── Assets.xcassets/
│       └── AdvisorAvatar.imageset/ (existing - Fred's photo)
│           ├── fred-amsden-resize.png
│           ├── fred-amsden-resize@2x.png
│           └── fred-amsden-resize@3x.png
```

---

## Nice-to-Have Features (Future Enhancements)

### 1. Build Your Own Plan (Slider Interface)

**Concept:** Allow users to adjust hold/sell split with interactive slider

**Implementation:**
```swift
struct BuildYourOwnPlanView: View {
    @State private var sellPercentage: Double = 30.0
    let vest: VestEvent

    var holdShares: Int {
        Int(Double(vest.sharesVesting) * (1 - sellPercentage / 100))
    }

    var sellShares: Int {
        vest.sharesVesting - holdShares
    }

    var body: some View {
        VStack {
            Text("Adjust Your Split")

            Slider(value: $sellPercentage, in: 0...100, step: 5)
                .accentColor(.green)

            HStack {
                VStack {
                    Text("HOLD")
                    Text("\(holdShares) shares")
                        .font(.title2.bold())
                }

                VStack {
                    Text("SELL")
                    Text("\(sellShares) shares")
                        .font(.title2.bold())
                }
            }

            Button("Preview Tax Impact") {
                // Show tax calculator
            }

            Button("Submit Plan") {
                // Submit custom plan to advisor for review
            }
        }
    }
}
```

**Accessibility Concerns:**
- Sliders can be difficult for VoiceOver users
- Alternative: Stepper control or numeric input
- Provide multiple input methods

**When to Build:**
- After core functionality is stable
- User research shows demand for customization
- A/B test: Does offering customization increase engagement?

---

### 2. Price Scenario Calculator

**Concept:** "What if stock price changes?"

**Implementation:**
```swift
struct PriceScenarioView: View {
    let vest: VestEvent
    @State private var scenarioPrice: Double

    var estimatedValue: Double {
        scenarioPrice * Double(vest.sharesVesting)
    }

    var body: some View {
        VStack {
            Text("What if the stock price is...")

            TextField("Enter price", value: $scenarioPrice, format: .currency(code: "USD"))
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)

            Text("Estimated Value: \(estimatedValue, format: .currency(code: "USD"))")
                .font(.title2.bold())

            // Show tax impact at different prices
            // Show hold/sell breakdown
        }
    }
}
```

**When to Build:**
- After Phase 6 (polish)
- If user feedback indicates anxiety about price volatility

---

### 3. Multi-Vest Planning

**Concept:** Plan across multiple upcoming vests

**When to Build:**
- If users have multiple vests in short timeframes
- Phase 7+ (after core is proven)

---

## Testing Strategy

### Unit Tests

**Models:**
- ✅ `ExecutionPlan` date calculations
- ✅ `TaxEstimate` net after taxes calculation
- ✅ JSON decoding for all models

**Services:**
- ✅ `DataStore` loads data correctly
- ✅ `APIService` handles errors gracefully

### UI Tests

**Component Tests:**
- ✅ `AboutThisPlanCard` expands/collapses correctly
- ✅ `ExecutionTimelineCard` shows correct milestones
- ✅ `UpcomingVestCard` tap opens modal
- ✅ `ApprovalConfirmationSheet` submits on confirm

**Integration Tests:**
- ✅ Full user flow: View vest → Review → Approve → Success
- ✅ Cancel flow: View vest → Review → Go Back
- ✅ Request Changes flow: View vest → Request Changes → Contact advisor

**Accessibility Tests:**
- ✅ VoiceOver can navigate entire screen
- ✅ All interactive elements have labels
- ✅ Dynamic Type scales correctly

### Manual QA Checklist

- [ ] Test with Alex scenario (Premium tier)
- [ ] Test with Marcus scenario (Standard tier)
- [ ] Test with missing optional data (no blackout period, no advisor)
- [ ] Test with past vest dates (edge case)
- [ ] Test with very large numbers (1M+ shares)
- [ ] Test in Dark Mode
- [ ] Test on iPhone SE (small screen)
- [ ] Test on iPhone 15 Pro Max (large screen)
- [ ] Test on iPad (if supporting)
- [ ] Test offline (no network)
- [ ] Test slow network (3G simulation)

---

## Success Metrics

### Phase 1-6 Launch Metrics

**User Engagement:**
- % of users who view vest execution screen
- % who tap "Review and Approve Plan"
- % who complete authorization
- % who use "Request Changes"

**Time Metrics:**
- Average time to complete authorization
- Bounce rate (view but don't act)

**Quality Metrics:**
- Crash rate < 0.1%
- API error rate < 1%
- User-reported issues < 5 per 1000 users

**Conversion (Business Goals):**
- % of vests with advisor-recommended plans executed
- % of standard tier users who upgrade to premium (if applicable)

---

## Dependencies & Risks

### Technical Dependencies

1. **Backend API** - Must be ready before Phase 4
   - Risk: Backend delays block frontend testing
   - Mitigation: Use mock data and stub API responses

2. **User Profile Service** - Tier detection
   - Risk: Tier data not available or incorrect
   - Mitigation: Graceful fallback to standard tier

3. **Advisor Contact Integration** - Message/Call/Book flows
   - Risk: Third-party integrations (Calendly, MessageBird, etc.) may fail
   - Mitigation: Deep links to native apps (Messages, Phone) as backup

### Design Risks

1. **Information Overload** - Too much on one screen
   - Mitigation: Progressive disclosure (collapsible sections)
   - Monitor: User testing for confusion points

2. **Button Clarity** - "Review and Approve" might still feel too fast
   - Mitigation: Modal confirmation screen adds safety layer
   - Monitor: Track cancel rate in modal

3. **Advisor Trust** - Marcus may not trust Sofia like Alex trusts Fred
   - Mitigation: Clear credentials, conversation details, personalized notes
   - Monitor: Compare authorization rates between tiers

### Business Risks

1. **Regulatory Compliance** - T&C, disclosures, authorization language
   - Mitigation: Legal review before launch
   - Requirement: Explicit consent tracking

2. **Advisor Capacity** - Can Sofia handle volume of change requests?
   - Mitigation: Set expectations ("Response within 1-2 business days")
   - Monitor: SLA adherence

---

## Open Questions / TBD

1. **Marcus's advisor name** - "Sofia [Last Name]" placeholder
   - Need: Actual advisor name or title for Standard tier

2. **Shared support number** - "(800) 555-XXXX" placeholder
   - Need: Actual Schwab support line for Standard tier

3. **Terms & Conditions link** - Where does it point?
   - Need: URL for Schwab's actual T&C page

4. **Authorization persistence** - Where is it stored?
   - Options: Local database, backend only, both?
   - Decision: Backend is source of truth, local cache for offline viewing

5. **Post-authorization screen** - What does user see after confirming?
   - Options:
     - A) Return to dashboard with success banner
     - B) Show new screen: "Plan Authorized - What's Next"
     - C) Navigate to timeline view with authorization badge
   - Decision: TBD based on user flow design

6. **Notification strategy** - Remind user of modify deadline?
   - Options: Push notification on Feb 12 (day before deadline)
   - Decision: TBD - may be out of scope for MVP

7. **Build Your Own slider** - Stepper vs Slider vs Numeric input?
   - Decision: Defer to post-MVP, test multiple options

---

## Conclusion

This implementation plan provides a complete roadmap for building the vest execution screen in SwiftUI, supporting both Premium (Alex) and Standard (Marcus) tiers with personalized advisor recommendations, clear timelines, and robust confirmation flows.

**Estimated Timeline:** 6 weeks (with team of 2-3 developers)

**Critical Path:**
1. Data models (Week 1)
2. Core UI components (Week 2)
3. Modals (Week 3)
4. Assembly & integration (Week 4)
5. Tier customization (Week 5)
6. Polish & testing (Week 6)

**Next Steps:**
1. Review and approve this plan
2. Prioritize Phase 1 tasks
3. Assign developers to components
4. Set up weekly checkpoints
5. Begin implementation

---

**Document Version:** 1.0
**Last Updated:** 2025-12-25
**Author:** Implementation plan based on HTML mockup (robinhood-mockup-alex-v2.html)
**Status:** Ready for Review
