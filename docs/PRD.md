# Product Requirements Document
## Equity Compensation Liquid Glass Experience

**Target Client**: Entertainment conglomerate ($1B AUM)
**Target Users**: Entertainment employees (VPs, directors, engineers, marketing) - mobile-first, working on-road
**Primary Goal**: Showcase Liquid Glass as functional UX, demonstrate working code vs Figma
**Demo Date**: Mid-January 2025

---

## Success Criteria

**Demo must demonstrate**:
1. Working Swift code running in Xcode simulator
2. Liquid Glass as primary interaction pattern (70% visual/interactive)
3. Mobile-first experience (glanceable, fast, premium)
4. Compliance-aware design (advisor recommendations, not app advice)
5. Understanding of entertainment industry user needs

**Business outcome**:
- Win $1B client by showing Schwab can deliver modern mobile experiences
- Prove value of working prototypes over static Figma designs

---

## User Context

**Who**: VP of Production at Steamboat Co. (entertainment division)
**Scenario**: On set, between meetings, checks phone for upcoming equity vest
**Needs**:
- Quick glance at vest status (47 days away)
- Privacy (people around on set)
- Clarity on what happens at vest (hold vs sell)
- Easy access to advisor guidance

**Pain Points**:
- Existing tools are desktop-first (can't check on-the-go)
- Dollar amounts visible to anyone looking over shoulder
- Unclear what to do when shares vest
- Hard to reach advisor for guidance

---

## Feature Set (Priority Order)

### Phase 1: Primary Showcase (This Week)
1. **Privacy Blur** - Face ID reveal of dollar amounts
2. **70/30 Split Visualization** - Interactive glass morph showing hold/sell breakdown
3. **Advisor Conversation Context** - Compliance-safe recommendation display

### Phase 2: Supporting Showcase (Week 2)
4. **Tax Withholding Layers** - Stacked glass showing gross → taxes → net
5. **Multiple Vests Timeline** - Layered cards, color-coded
6. **Action Confirmation** - Swipe to execute with glass dissolve

### Phase 3: Polish (Week 3)
7. **Loading States** - Glass shimmer effects
8. **Countdown Progress Ring** - Visual time-to-vest
9. **Empty States** - Polished glass checkmark
10. **Notification Preview** - Alert overlay with context

---

## FEATURE 1: Privacy Blur

### Description
Dollar amounts are blurred by default. User taps card → Face ID prompt → successful auth reveals amount with smooth glass dissolve animation. Auto-hides after 10 seconds.

### User Story
> "As a VP checking my phone on set, I want dollar amounts hidden by default so that crew members around me don't see my compensation details."

### Visual Design
```
┌─────────────────────────────────┐
│  UPCOMING VEST                  │
│                                 │
│  Steamboat Co.                  │
│  Feb 6, 2026 • 47 days          │
│                                 │
│  2,500 shares                   │
│  $•••,•••  [BLURRED]            │
│                                 │
│  Tap to reveal                  │
└─────────────────────────────────┘

        ↓ Tap + Face ID ↓

┌─────────────────────────────────┐
│  UPCOMING VEST                  │
│                                 │
│  Steamboat Co.                  │
│  Feb 6, 2026 • 47 days          │
│                                 │
│  2,500 shares                   │
│  $127,450  [REVEALED]           │
│                                 │
│  🔒 Auto-hiding in 10s          │
└─────────────────────────────────┘
```

### Acceptance Criteria

#### AC-1.1: Default Blurred State
- [ ] On app launch, dollar amount displays as "$•••,•••"
- [ ] Blur effect uses `.regularMaterial` with 12pt blur radius
- [ ] Share count (2,500 shares) remains visible (not blurred)
- [ ] Company name "Steamboat Co." remains visible
- [ ] Vest date "Feb 6, 2026 • 47 days" remains visible
- [ ] Card background uses `.ultraThinMaterial`
- [ ] Card has 20pt corner radius
- [ ] Card has subtle shadow (black 10% opacity, 10pt radius, 5pt y-offset)

#### AC-1.2: Tap Interaction
- [ ] Tapping anywhere on the card triggers Face ID prompt
- [ ] Face ID prompt shows custom message: "Reveal vest amount"
- [ ] In simulator, Face ID prompt appears (uses Touch ID on Mac keyboard)
- [ ] If user cancels Face ID, blur remains, no error shown
- [ ] Card does not respond to taps while Face ID prompt is active

#### AC-1.3: Successful Authentication
- [ ] After successful Face ID, blur dissolves over 0.5 seconds
- [ ] Animation uses `.smooth` easing curve
- [ ] Dollar amount transitions from "$•••,•••" to "$127,450"
- [ ] Text uses `.contentTransition(.numericText())` for smooth number reveal
- [ ] Revealed amount uses `.system(size: 34, weight: .bold, design: .rounded)` font
- [ ] Small lock icon (🔒) appears below amount with "Auto-hiding in 10s" text
- [ ] Auto-hide text uses `.caption` font, `.secondary` color

#### AC-1.4: Failed Authentication
- [ ] If Face ID fails, blur remains
- [ ] Card shakes horizontally (10pt amplitude, 3 shakes, 0.3s duration)
- [ ] Haptic feedback: `.notificationOccurred(.error)`
- [ ] User can tap again to retry

#### AC-1.5: Auto-Hide Behavior
- [ ] After 10 seconds of reveal, blur returns automatically
- [ ] Blur return animation: 0.5 seconds, `.smooth` easing
- [ ] Amount transitions back to "$•••,•••"
- [ ] Lock icon and auto-hide text fade out
- [ ] Timer resets if user taps to reveal again

#### AC-1.6: Accessibility
- [ ] VoiceOver reads: "Vest amount hidden. Double tap to reveal with Face ID" (when blurred)
- [ ] VoiceOver reads: "Vest amount: $127,450" (when revealed)
- [ ] Dynamic Type support: text scales up to `.xxxLarge`
- [ ] Reduced motion: blur dissolve uses 0.1s linear fade instead of smooth curve
- [ ] Color contrast: all text meets WCAG AA (4.5:1 minimum)

#### AC-1.7: Edge Cases
- [ ] Works in light mode
- [ ] Works in dark mode
- [ ] If device doesn't support Face ID, show alert: "Face ID not available"
- [ ] If Face ID not enrolled, prompt: "Enable Face ID in Settings to use privacy mode"
- [ ] App backgrounded during reveal: blur returns when app returns to foreground

### Technical Notes
- Use `LocalAuthentication` framework (`LAContext`)
- Blur implemented with `.visualEffect { content, proxy in content.blur(...) }`
- Store reveal state in `@State private var isRevealed = false`
- Use `DispatchQueue.main.asyncAfter` for 10-second auto-hide timer
- Invalidate timer if user backgrounds app or taps again

### Dependencies
- None (standalone feature)

---

## FEATURE 2: 70/30 Split Visualization

### Description
Interactive glass card showing advisor's recommended split: 70% hold (diversified portfolio), 30% sell (cash). Tapping card morphs it into two distinct glass regions with different colors/opacity, showing breakdown details.

### User Story
> "As a user, I want to see my advisor's recommendation visually so I can quickly understand the split without reading paragraphs of text."

### Visual Design
```
DEFAULT STATE:
┌─────────────────────────────────┐
│  ADVISOR RECOMMENDATION         │
│                                 │
│  ┌───────────────────────────┐ │
│  │                           │ │
│  │   70%    │    30%         │ │
│  │   HOLD   │    SELL        │ │
│  │          │                │ │
│  └───────────────────────────┘ │
│                                 │
│  From your call with Fred       │
│  Dec 18, 2025                   │
│                                 │
│  Tap for breakdown              │
└─────────────────────────────────┘

TAPPED STATE:
┌─────────────────────────────────┐
│  ADVISOR RECOMMENDATION         │
│                                 │
│  ┌─────────────┬─────────────┐ │
│  │   HOLD 70%  │  SELL 30%   │ │
│  │             │             │ │
│  │  1,750 sh   │   750 sh    │ │
│  │  $89,215    │  $38,235    │ │
│  │             │             │ │
│  │ Move to     │ Transfer to │ │
│  │ portfolio   │ checking    │ │
│  └─────────────┴─────────────┘ │
│                                 │
│  Tap sections for more          │
└─────────────────────────────────┘
```

### Acceptance Criteria

#### AC-2.1: Default Compact View
- [ ] Card shows two sections side-by-side: "70% HOLD" | "30% SELL"
- [ ] Proportions visually correct: left section 70% width, right section 30% width
- [ ] Both sections use `.thinMaterial` background
- [ ] Left section (Hold) has green tint: `.green.opacity(0.15)`
- [ ] Right section (Sell) has orange tint: `.orange.opacity(0.15)`
- [ ] Divider line between sections: 1pt, `.secondary` color, 50% opacity
- [ ] Text "70% HOLD" and "30% SELL" centered, `.headline.bold()` font
- [ ] Below card: "From your call with Fred" (`.subheadline`, `.secondary`)
- [ ] Date "Dec 18, 2025" (`.caption`, `.tertiary`)
- [ ] "Tap for breakdown" hint (`.caption`, `.secondary`)

#### AC-2.2: Tap to Expand Animation
- [ ] Tapping anywhere on card triggers expansion
- [ ] Animation duration: 0.6 seconds
- [ ] Animation uses `.spring(response: 0.6, dampingFraction: 0.75)`
- [ ] Card height expands from 120pt to 220pt
- [ ] Sections morph to show details (shares, dollar amounts, actions)
- [ ] Haptic feedback on tap: `.impactOccurred(.medium)`

#### AC-2.3: Expanded View - Hold Section (70%)
- [ ] Shows "HOLD 70%" header (`.title3.bold()`, green color)
- [ ] Shows share count: "1,750 sh" (`.title2`, monospaced)
- [ ] Shows dollar value: "$89,215" (`.title3.bold()`)
- [ ] Shows action: "Move to portfolio" (`.subheadline`, `.secondary`)
- [ ] Background remains green-tinted glass (`.regularMaterial` + green 0.2 opacity)
- [ ] All text left-aligned within section
- [ ] 16pt padding on all sides

#### AC-2.4: Expanded View - Sell Section (30%)
- [ ] Shows "SELL 30%" header (`.title3.bold()`, orange color)
- [ ] Shows share count: "750 sh" (`.title2`, monospaced)
- [ ] Shows dollar value: "$38,235" (`.title3.bold()`)
- [ ] Shows action: "Transfer to checking" (`.subheadline`, `.secondary`)
- [ ] Background remains orange-tinted glass (`.regularMaterial` + orange 0.2 opacity)
- [ ] All text left-aligned within section
- [ ] 16pt padding on all sides

#### AC-2.5: Math Validation
- [ ] Hold shares (1,750) + Sell shares (750) = Total shares (2,500) ✓
- [ ] Hold value ($89,215) + Sell value ($38,235) = Total value ($127,450) ✓
- [ ] Hold percentage: 1,750 / 2,500 = 70% ✓
- [ ] Sell percentage: 750 / 2,500 = 30% ✓
- [ ] Assumes share price: $127,450 / 2,500 = $50.98/share

#### AC-2.6: Collapse Interaction
- [ ] Tapping expanded card again collapses it back to compact view
- [ ] Collapse animation: 0.5 seconds, `.smooth` easing
- [ ] Returns to 120pt height
- [ ] Sections return to simple "70% HOLD | 30% SELL" layout
- [ ] Haptic feedback on collapse: `.impactOccurred(.light)`

#### AC-2.7: Accessibility
- [ ] Compact view VoiceOver: "Advisor recommendation: Hold 70%, Sell 30%. From your call with Fred on December 18, 2025. Double tap for breakdown."
- [ ] Expanded view VoiceOver: "Hold section: 1,750 shares, $89,215, move to portfolio. Sell section: 750 shares, $38,235, transfer to checking."
- [ ] Dynamic Type: all text scales properly
- [ ] Reduced motion: instant layout change (no animation)

#### AC-2.8: Edge Cases
- [ ] Works in light mode (green/orange tints visible)
- [ ] Works in dark mode (tints adjusted for contrast)
- [ ] Card width adapts to screen size (iPhone SE → Pro Max)
- [ ] Text wraps gracefully on small screens
- [ ] If dollar amounts hidden (privacy mode), shows "$•••,•••" in expanded view

### Technical Notes
- Use `@State private var isExpanded = false`
- Layout: `HStack` with two `VStack` sections, proportional widths
- Animation: `.animation(.spring(...), value: isExpanded)`
- Math: Calculate from total shares (2,500) × share price ($50.98) × percentages
- Percentages stored in data model (not hardcoded in view)

### Dependencies
- Privacy blur (if enabled, dollar amounts in expanded view respect blur state)

---

## FEATURE 3: Advisor Conversation Context

### Description
Tapping "From your call with Fred" opens a frosted glass modal showing conversation details. Ensures compliance: recommendation comes from advisor, not app. User sees what was discussed, Fred's recommendation, and actions.

### User Story
> "As a compliance officer, I need to ensure the app never provides financial advice. All recommendations must clearly come from the user's advisor, with full conversation context."

### Visual Design
```
┌─────────────────────────────────┐
│  [Vest timeline dimmed behind]  │
│                                 │
│  ┌───────────────────────────┐ │
│  │ 🗓️  Call with Fred        │ │
│  │    Dec 18, 2025 • 22 min  │ │
│  │                           │ │
│  │ DISCUSSED:                │ │
│  │ • Tax implications of     │ │
│  │   holding vs selling      │ │
│  │ • Your goal: diversify    │ │
│  │   from company stock      │ │
│  │ • Market outlook for Q1   │ │
│  │ • 70/30 split strategy    │ │
│  │                           │ │
│  │ FRED'S RECOMMENDATION:    │ │
│  │ Hold 70% in diversified   │ │
│  │ portfolio, sell 30% to    │ │
│  │ cover taxes + cash needs  │ │
│  │                           │ │
│  │ [Message Fred]            │ │
│  │ [Close]                   │ │
│  └───────────────────────────┘ │
│                                 │
└─────────────────────────────────┘
```

### Acceptance Criteria

#### AC-3.1: Modal Trigger
- [ ] Tapping "From your call with Fred, Dec 18, 2025" text opens modal
- [ ] Text is tappable (blue color, underlined on press)
- [ ] Modal presents over current view using `.sheet` modifier
- [ ] Modal uses `.presentationDetents([.medium])` (half-screen height)
- [ ] Modal background: `.ultraThinMaterial` (see timeline behind)
- [ ] Background content dims to 60% opacity when modal open

#### AC-3.2: Modal Header
- [ ] Shows calendar icon (🗓️) + "Call with Fred"
- [ ] Shows date: "Dec 18, 2025" + duration: "22 min"
- [ ] Header font: `.headline`
- [ ] Header aligned left, 20pt from edge
- [ ] Date/duration font: `.subheadline`, `.secondary` color

#### AC-3.3: Discussion Points Section
- [ ] Section header: "DISCUSSED:" (`.caption.bold()`, `.secondary`)
- [ ] Four bullet points, each on new line:
  - "• Tax implications of holding vs selling"
  - "• Your goal: diversify from company stock"
  - "• Market outlook for Q1"
  - "• 70/30 split strategy"
- [ ] Bullets use `.body` font, `.primary` color
- [ ] 8pt spacing between bullets
- [ ] 12pt padding around section

#### AC-3.4: Recommendation Section
- [ ] Section header: "FRED'S RECOMMENDATION:" (`.caption.bold()`, `.secondary`)
- [ ] Recommendation text: "Hold 70% in diversified portfolio, sell 30% to cover taxes + cash needs"
- [ ] Text uses `.body` font, `.primary` color
- [ ] Text wraps to multiple lines if needed
- [ ] 16pt padding around section
- [ ] Background: light green tint (`.green.opacity(0.05)`)
- [ ] 12pt corner radius on background

#### AC-3.5: Action Buttons
- [ ] Two buttons at bottom: "Message Fred" and "Close"
- [ ] "Message Fred" button:
  - Blue background, white text
  - `.headline` font
  - 16pt padding vertical, full width
  - 12pt corner radius
  - Tap → deep link to Schwab messaging (or show "Feature coming soon" alert)
- [ ] "Close" button:
  - Gray background (`.secondary`), white text
  - `.subheadline` font
  - 12pt padding vertical, full width
  - 12pt corner radius
  - Tap → dismisses modal

#### AC-3.6: Modal Dismissal
- [ ] Tapping "Close" button dismisses modal
- [ ] Swiping down on modal dismisses it (standard iOS behavior)
- [ ] Dismiss animation: 0.4 seconds, `.smooth` easing
- [ ] Background content returns to 100% opacity
- [ ] Modal can be re-opened by tapping trigger text again

#### AC-3.7: Compliance Language
- [ ] NEVER uses "We recommend" or "Schwab suggests"
- [ ] ALWAYS attributes to advisor: "Fred's recommendation"
- [ ] ALWAYS shows conversation date and context
- [ ] ALWAYS shows discussion points (not just recommendation)
- [ ] No algorithmic or automated advice language anywhere

#### AC-3.8: Accessibility
- [ ] VoiceOver reads full modal content in order: header → discussed → recommendation → buttons
- [ ] "Message Fred" button: "Button. Message Fred"
- [ ] "Close" button: "Button. Close"
- [ ] Dynamic Type: text scales, modal scrollable if content overflows
- [ ] Reduced transparency: modal uses solid background instead of glass

#### AC-3.9: Edge Cases
- [ ] Works in light mode (tint visible)
- [ ] Works in dark mode (adjusted contrast)
- [ ] Long discussion points wrap properly (don't overflow)
- [ ] Long recommendation text wraps properly
- [ ] If advisor name changes, updates throughout (not hardcoded "Fred")
- [ ] If no conversation exists, "Message Fred" shows instead of recommendation

### Technical Notes
- Use `@State private var showConversation = false`
- Modal: `.sheet(isPresented: $showConversation) { ConversationView() }`
- Data model: `AdvisorConversation` with fields: date, duration, discussionPoints[], recommendation, advisorName
- Deep link: `URL(string: "schwab://messages/advisor/fred")` (placeholder)

### Dependencies
- None (standalone modal)

---

## FEATURE 4: Tax Withholding Layers

### Description
Stacked glass layers showing gross vest value → taxes deducted → net proceeds. Each layer tappable to show detail. Color-coded by severity (red = federal, orange = state, yellow = FICA).

### User Story
> "As a user who doesn't understand tax withholding, I want to see visually how much is taken out and why, so I know what I'll actually receive."

### Visual Design
```
┌─────────────────────────────────┐
│  TAX BREAKDOWN                  │
│                                 │
│  ┌───────────────────────────┐ │
│  │ Gross: $127,450           │ │ ← Clear glass
│  └───────────────────────────┘ │
│         ↓                       │
│  ┌───────────────────────────┐ │
│  │ Federal: -$35,286 (27.7%) │ │ ← Red tint
│  │ State: -$6,373 (5.0%)     │ │ ← Orange tint
│  │ FICA: -$2,841 (2.2%)      │ │ ← Yellow tint
│  └───────────────────────────┘ │
│         ↓                       │
│  ┌───────────────────────────┐ │
│  │ Net: $82,950              │ │ ← Green glass, thick
│  └───────────────────────────┘ │
└─────────────────────────────────┘
```

### Acceptance Criteria

#### AC-4.1: Gross Value Layer (Top)
- [ ] Shows "Gross Value: $127,450"
- [ ] Uses `.regularMaterial` background, no tint
- [ ] Font: `.title3.bold()`
- [ ] 16pt padding vertical
- [ ] 12pt corner radius
- [ ] Arrow (↓) below layer, 24pt size, `.secondary` color

#### AC-4.2: Tax Deduction Layers (Middle)
- [ ] Three layers stacked vertically, 4pt spacing between
- [ ] Federal layer:
  - Text: "Federal: -$35,286 (27.7%)"
  - Background: `.thinMaterial` + `.red.opacity(0.2)`
  - Font: `.body`
- [ ] State layer:
  - Text: "State: -$6,373 (5.0%)"
  - Background: `.thinMaterial` + `.orange.opacity(0.15)`
  - Font: `.body`
- [ ] FICA layer:
  - Text: "FICA: -$2,841 (2.2%)"
  - Background: `.thinMaterial` + `.yellow.opacity(0.1)`
  - Font: `.body`
- [ ] Each layer: 12pt padding vertical, 12pt corner radius
- [ ] Arrow (↓) below stack

#### AC-4.3: Net Proceeds Layer (Bottom)
- [ ] Shows "You receive: $82,950"
- [ ] Uses `.thickMaterial` background + `.green.opacity(0.2)` tint
- [ ] Font: `.title2.bold()`
- [ ] 20pt padding vertical
- [ ] 12pt corner radius
- [ ] Emphasized (visually heavier than other layers)

#### AC-4.4: Tax Math Validation
- [ ] Gross: $127,450
- [ ] Federal (27.7%): $127,450 × 0.277 = $35,303.65 ≈ $35,286 ✓
- [ ] State (5.0%): $127,450 × 0.05 = $6,372.50 ≈ $6,373 ✓
- [ ] FICA (2.2%): $127,450 × 0.022 = $2,803.90 ≈ $2,841 ✓
- [ ] Net: $127,450 - $35,286 - $6,373 - $2,841 = $82,950 ✓
- [ ] Total deduction: 34.9% (reasonable)

#### AC-4.5: Layer Tap Interaction (Future)
- [ ] Tapping any tax layer expands it to show detail (e.g., federal breakdown)
- [ ] For MVP: tap shows "Feature coming soon" alert
- [ ] Haptic feedback on tap: `.impactOccurred(.light)`

#### AC-4.6: Accessibility
- [ ] VoiceOver reads layers top to bottom: "Gross value $127,450. Federal tax withheld $35,286, 27.7%. State tax withheld $6,373, 5%. FICA tax withheld $2,841, 2.2%. You receive $82,950."
- [ ] Dynamic Type: text scales, layers remain stacked
- [ ] Color blind: layers distinguishable by position (not just color)

#### AC-4.7: Edge Cases
- [ ] Works in light mode (tints visible)
- [ ] Works in dark mode (adjusted tints)
- [ ] If privacy mode enabled, dollar amounts blurred (percentages visible)
- [ ] Small screens: layers stack vertically, no horizontal overflow

### Technical Notes
- Use `VStack(spacing: 4)` for layer stack
- Each layer: `HStack` with label + amount
- Tax rates configurable (not hardcoded)
- Math: Calculate from gross amount × tax rates

### Dependencies
- Privacy blur (if enabled, respects blur state)

---

## FEATURE 5: Multiple Vests Timeline

### Description
Layered glass cards showing upcoming vests, color-coded chronologically (green → blue → purple → orange). Scroll to separate cards. Tap any card to expand and see split visualization.

### User Story
> "As a user with quarterly vests, I want to see all upcoming vests at a glance so I can plan ahead."

### Visual Design
```
COMPACT (STACKED):
┌─────────────────────────────────┐
│  VESTING TIMELINE               │
│                                 │
│  ┌───────────────────────────┐ │
│  │ Feb 6 • 47d • $127k       │ │ ← Green glass
│  └───────────────────────────┘ │
│    ┌───────────────────────────┐│
│    │ May 6 • 136d • $127k      ││ ← Blue glass
│    └───────────────────────────┘│
│      ┌───────────────────────────┐
│      │ Aug 6 • 228d • $127k      │ ← Purple glass
│      └───────────────────────────┘
│                                 │
│  Tap any card to expand         │
└─────────────────────────────────┘

EXPANDED (SCROLLED):
┌─────────────────────────────────┐
│  ┌───────────────────────────┐ │
│  │ Feb 6, 2026 • 47 days     │ │
│  │ Steamboat Co.             │ │
│  │ 2,500 shares • $127,450   │ │
│  │                           │ │
│  │ 70% HOLD | 30% SELL       │ │
│  └───────────────────────────┘ │
│                                 │
│  ┌───────────────────────────┐ │
│  │ May 6, 2026 • 136 days    │ │
│  │ ...                       │ │
│  └───────────────────────────┘ │
└─────────────────────────────────┘
```

### Acceptance Criteria

#### AC-5.1: Card Stacking (Default)
- [ ] Cards initially overlap, each offset 16pt down and 8pt right
- [ ] Top card (soonest vest) fully visible
- [ ] Second card shows top 40pt (header visible)
- [ ] Third card shows top 24pt (date visible)
- [ ] Fourth card+ not visible in stack
- [ ] Z-index: top card highest, decreasing down stack

#### AC-5.2: Color Coding
- [ ] 1st vest (Feb 6): green tint (`.green.opacity(0.2)`)
- [ ] 2nd vest (May 6): blue tint (`.blue.opacity(0.2)`)
- [ ] 3rd vest (Aug 6): purple tint (`.purple.opacity(0.2)`)
- [ ] 4th vest: orange tint (`.orange.opacity(0.2)`)
- [ ] Pattern repeats if more than 4 vests

#### AC-5.3: Scroll to Separate
- [ ] Scrolling down separates cards (vertical spacing increases)
- [ ] Animation: smooth spring (response 0.5, damping 0.8)
- [ ] Fully separated: 16pt spacing between cards
- [ ] Each card shows full details when separated

#### AC-5.4: Card Content (Compact)
- [ ] Date: "Feb 6" (`.headline.bold()`)
- [ ] Countdown: "47d" (`.subheadline`, `.secondary`)
- [ ] Value: "$127k" (`.title3`, abbreviated)
- [ ] All on one line, separated by bullets (•)

#### AC-5.5: Card Content (Expanded via Tap)
- [ ] Tapping card expands it to full height (220pt)
- [ ] Shows: Date, company, shares, dollar amount, 70/30 split preview
- [ ] Same layout as Feature 2 (split visualization)
- [ ] Other cards remain compact

#### AC-5.6: Accessibility
- [ ] VoiceOver: "Vesting timeline. 3 upcoming vests. First vest: February 6, 2026, 47 days, $127,450. Second vest: May 6, 2026, 136 days, $127,450. Third vest: August 6, 2026, 228 days, $127,450."
- [ ] Each card individually accessible
- [ ] Scroll container accessible with swipe gestures

### Technical Notes
- Use `ScrollView` with `LazyVStack`
- Card offset: `.offset(x: CGFloat(index) * 8, y: CGFloat(index) * 16)`
- Expand/collapse: `@State` per card
- Color array: `[.green, .blue, .purple, .orange]`, cycle with `% 4`

### Dependencies
- Privacy blur (respects blur for dollar amounts)
- Split visualization (expanded card shows split)

---

## FEATURE 6: Action Confirmation

### Description
When user taps "Execute Fred's Recommendation", glass modal slides up requiring swipe-to-confirm. Shows exactly what will happen. Glass dissolves on successful swipe.

### User Story
> "As a user about to execute a financial transaction, I want a clear confirmation step so I don't accidentally execute the wrong action."

### Visual Design
```
┌─────────────────────────────────┐
│  [Vest timeline dimmed behind]  │
│                                 │
│  ┌───────────────────────────┐ │
│  │ EXECUTE RECOMMENDATION    │ │
│  │                           │ │
│  │ This will:                │ │
│  │                           │ │
│  │ ✓ Move 1,750 shares       │ │
│  │   ($89,215) to your       │ │
│  │   diversified portfolio   │ │
│  │                           │ │
│  │ ✓ Sell 750 shares         │ │
│  │   ($38,235) and transfer  │ │
│  │   to checking             │ │
│  │                           │ │
│  │ [Swipe to Confirm] →→→    │ │
│  │ ═══════════════════════   │ │
│  │                           │ │
│  └───────────────────────────┘ │
│                                 │
└─────────────────────────────────┘
```

### Acceptance Criteria

#### AC-6.1: Modal Presentation
- [ ] Modal triggered by tapping "Execute Recommendation" button
- [ ] Modal slides up from bottom, 0.5s `.smooth` animation
- [ ] Background dims to 40% opacity
- [ ] Modal uses `.regularMaterial` background
- [ ] Modal height: 320pt (fixed)
- [ ] 20pt corner radius on top corners

#### AC-6.2: Content Display
- [ ] Header: "EXECUTE RECOMMENDATION" (`.headline.bold()`)
- [ ] Subheader: "This will:" (`.subheadline`, `.secondary`)
- [ ] Two checklist items:
  - "✓ Move 1,750 shares ($89,215) to your diversified portfolio"
  - "✓ Sell 750 shares ($38,235) and transfer to checking"
- [ ] Each item: `.body` font, left-aligned, 8pt spacing
- [ ] Green checkmarks (`.green` color)

#### AC-6.3: Swipe to Confirm Control
- [ ] Horizontal slider at bottom of modal
- [ ] Track: gray rounded rectangle, 54pt height, full width
- [ ] Thumb: blue rounded rectangle, 50pt × 50pt, white arrow (→→→) icon
- [ ] Label: "Swipe to Confirm" centered in track, fades as thumb moves
- [ ] Initial position: thumb at left edge (0%)
- [ ] Swiping right moves thumb smoothly

#### AC-6.4: Swipe Completion
- [ ] If user drags thumb past 80% of track width, action confirms
- [ ] Haptic feedback on completion: `.notificationOccurred(.success)`
- [ ] Thumb snaps to right edge (100%)
- [ ] Track turns green briefly (0.3s)
- [ ] Modal and background dissolve out (0.6s)
- [ ] Success message appears: "Recommendation executed" (toast notification)

#### AC-6.5: Swipe Cancellation
- [ ] If user releases thumb before 80%, thumb springs back to left
- [ ] Spring animation: 0.3s, bouncy
- [ ] No haptic feedback
- [ ] Modal remains open, user can try again

#### AC-6.6: Dismiss Without Executing
- [ ] User can tap outside modal to dismiss
- [ ] User can swipe down on modal to dismiss
- [ ] No action executed if dismissed without completing swipe
- [ ] Background returns to 100% opacity

#### AC-6.7: Accessibility
- [ ] VoiceOver: "Execute recommendation modal. This will move 1,750 shares ($89,215) to your diversified portfolio, and sell 750 shares ($38,235) and transfer to checking. Swipe to confirm button."
- [ ] Swipe control has accessibility action: "Activate" (double-tap to execute)
- [ ] Dynamic Type: text scales, modal scrolls if needed

### Technical Notes
- Swipe control: `DragGesture` on custom view
- Track progress: `@State private var swipeProgress: CGFloat = 0`
- Completion threshold: `swipeProgress > 0.8`
- Use `UIImpactFeedbackGenerator` for haptics

### Dependencies
- None

---

## Data Models

### VestEvent
```swift
struct VestEvent: Identifiable, Codable {
    let id: UUID
    let vestDate: Date
    let companyName: String
    let sharesVesting: Int
    let estimatedValue: Double
    let advisorRecommendation: AdvisorRecommendation?
}
```

### AdvisorRecommendation
```swift
struct AdvisorRecommendation: Codable {
    let advisorName: String
    let conversationDate: Date
    let conversationDuration: Int // minutes
    let discussionPoints: [String]
    let recommendationText: String
    let holdPercentage: Double
    let sellPercentage: Double
}
```

### TaxEstimate
```swift
struct TaxEstimate: Codable {
    let grossValue: Double
    let federalTax: Double
    let federalRate: Double
    let stateTax: Double
    let stateRate: Double
    let ficaTax: Double
    let ficaRate: Double

    var netValue: Double {
        grossValue - federalTax - stateTax - ficaTax
    }
}
```

---

## Sample Data (Phase 1)

```json
{
  "id": "vest-001",
  "vestDate": "2026-02-06T09:00:00Z",
  "companyName": "Steamboat Co.",
  "sharesVesting": 2500,
  "estimatedValue": 127450.00,
  "advisorRecommendation": {
    "advisorName": "Fred",
    "conversationDate": "2025-12-18T14:30:00Z",
    "conversationDuration": 22,
    "discussionPoints": [
      "Tax implications of holding vs selling",
      "Your goal: diversify from company stock",
      "Market outlook for Q1",
      "70/30 split strategy"
    ],
    "recommendationText": "Hold 70% in diversified portfolio, sell 30% to cover taxes + cash needs",
    "holdPercentage": 0.70,
    "sellPercentage": 0.30
  },
  "taxEstimate": {
    "grossValue": 127450.00,
    "federalTax": 35286.00,
    "federalRate": 0.277,
    "stateTax": 6373.00,
    "stateRate": 0.05,
    "ficaTax": 2841.00,
    "ficaRate": 0.022
  }
}
```

---

## Technical Stack

**Language**: Swift
**Framework**: SwiftUI
**Minimum iOS**: 17.0
**Architecture**: MVVM
**State Management**: `@Observable` (iOS 17+)
**Data Persistence**: JSON files (Phase 1), UserDefaults (later)
**Authentication**: LocalAuthentication framework (Face ID)

---

## Testing Strategy (Simulator)

### Manual Test Cases

**TC-1: Privacy Blur Basic Flow**
1. Launch app
2. Verify dollar amount blurred
3. Tap card
4. Verify Face ID prompt appears
5. Approve Face ID (Hardware → Face ID → Matching Face)
6. Verify amount revealed
7. Wait 10 seconds
8. Verify amount re-blurs

**TC-2: 70/30 Split Visualization**
1. Find split card
2. Tap card
3. Verify expansion animation smooth
4. Verify math correct (1,750 + 750 = 2,500)
5. Tap again
6. Verify collapse animation smooth

**TC-3: Advisor Conversation Modal**
1. Tap "From your call with Fred"
2. Verify modal appears with frosted background
3. Verify discussion points visible
4. Verify "Fred's recommendation" text (not "We recommend")
5. Tap "Close"
6. Verify modal dismisses

**TC-4: Light/Dark Mode**
1. Enable dark mode (Settings → Developer → Dark Appearance)
2. Verify all glass effects visible
3. Verify text readable
4. Verify colors adjusted appropriately

**TC-5: Dynamic Type**
1. Increase text size (Settings → Accessibility → Display → Larger Text)
2. Set to maximum size
3. Verify all text scales properly
4. Verify layouts don't break

---

## Success Metrics

### For Demo (Mid-January)
- [ ] App runs in Xcode simulator without errors
- [ ] All 6 core features functional
- [ ] Liquid Glass effects smooth (60fps minimum)
- [ ] Demo flow takes 90 seconds, hits all key moments
- [ ] Compliance language correct (no "We recommend")
- [ ] Works in light and dark mode

### For Client Evaluation
- [ ] Client says "This is what we want" (qualitative)
- [ ] Client asks technical questions about implementation (shows interest)
- [ ] Client compares favorably to Figma mockups from competitors
- [ ] Schwab team gets approval to move forward with build

---

## Out of Scope (Phase 1)

- Real API integration (Schwab accounts, live advisor data)
- watchOS companion app
- Push notifications
- Real financial transactions
- Multi-user support
- Settings screen
- Onboarding flow
- Real device testing (simulator only for now)
- App Store submission

---

## Next Steps

1. **Create Xcode project** (30 min)
   - iOS App, SwiftUI, minimum deployment iOS 17.0
   - Name: "EquityGlass" or "VestManager"

2. **Implement Feature 1: Privacy Blur** (2-3 hours)
   - Build VestCard component
   - Add Face ID integration
   - Test in simulator

3. **Implement Feature 2: Split Visualization** (3-4 hours)
   - Build SplitCard component
   - Add tap-to-expand animation
   - Test math calculations

4. **Implement Feature 3: Advisor Modal** (2 hours)
   - Build ConversationView
   - Add sample data
   - Test compliance language

5. **Daily demo check**: Run app, verify all features work, assess smoothness

---

**PRD Version**: 1.0
**Last Updated**: Dec 21, 2025
**Owner**: Patrick Keating
**Status**: Ready for Implementation
