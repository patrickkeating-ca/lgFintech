# Liquid Glass Showcase Map

**Purpose**: Demonstrate Liquid Glass as primary UX pattern, not decoration.

**Ratio**: 70% visual/interactive, 30% standard UI

---

## 1. Portfolio Split Visualization (PRIMARY SHOWCASE)

### Default State
```
┌─────────────────────────────────┐
│  RSU VEST: Mar 8, 2025          │
│  2,500 shares • $127,450        │
│                                 │
│  ┌───────────────────────────┐ │
│  │                           │ │
│  │    [Glass Card Preview]   │ │
│  │                           │ │
│  │   70%        │    30%     │ │
│  │   HOLD       │    SELL    │ │
│  │              │            │ │
│  └───────────────────────────┘ │
│                                 │
│  From your call with Fred       │
│  Dec 18, 2024                   │
└─────────────────────────────────┘
```

### Tap → Glass Morphs to Show Breakdown

**Interaction**: Tap the glass card

**Effect**: Glass splits into two distinct regions with different opacity/color

```
┌─────────────────────────────────┐
│                                 │
│  ┌─────────────┬─────────────┐ │
│  │   HOLD 70%  │  SELL 30%   │ │
│  │             │             │ │
│  │  1,750 sh   │   750 sh    │ │
│  │  $89,215    │  $38,235    │ │
│  │             │             │ │
│  │ [Green      │ [Orange     │ │
│  │  Glass      │  Glass      │ │
│  │  Thick]     │  Thin]      │ │
│  │             │             │ │
│  │ Move to     │ Transfer to │ │
│  │ portfolio   │ checking    │ │
│  └─────────────┴─────────────┘ │
│                                 │
│  Tap each section for details   │
└─────────────────────────────────┘
```

**Implementation**:
- Two glass rectangles side by side
- Left: 70% width, green tint, `.regularMaterial`
- Right: 30% width, orange tint, `.thinMaterial`
- Each tappable for drill-down
- Smooth animation: 0.6s spring when expanding from compact view

**Why Liquid Glass**:
- Instantly shows proportion visually (not just numbers)
- Interactive layers reveal details
- Premium feel for financial decision

---

## 2. Tax Withholding Layers (SECONDARY SHOWCASE)

### Visual: Stacked Glass Layers

```
┌─────────────────────────────────┐
│  TAX BREAKDOWN                  │
│                                 │
│  ┌───────────────────────────┐ │
│  │ Gross Value: $127,450     │ │ ← Opaque glass
│  └───────────────────────────┘ │
│       ↓ Withholding            │
│  ┌───────────────────────────┐ │
│  │ Federal: $35,286 (27.7%)  │ │ ← Red tint
│  │ State: $6,373 (5.0%)      │ │ ← Orange tint
│  │ FICA: $2,841 (2.2%)       │ │ ← Yellow tint
│  └───────────────────────────┘ │
│       ↓ Net Proceeds           │
│  ┌───────────────────────────┐ │
│  │ You receive: $82,950      │ │ ← Green glass, thick
│  └───────────────────────────┘ │
└─────────────────────────────────┘
```

**Interaction**: Each layer tappable, expands to show detail

**Why Liquid Glass**:
- Layering shows flow: Gross → Taxes → Net
- Color intensity shows severity of withholding
- See through layers to understand full picture

**Implementation**:
```swift
VStack(spacing: 4) {
    // Gross
    LayerCard(
        amount: 127450,
        label: "Gross Value",
        material: .regularMaterial,
        tint: .clear
    )

    // Tax layers
    LayerCard(
        amount: -35286,
        label: "Federal (27.7%)",
        material: .thinMaterial,
        tint: .red.opacity(0.3)
    )

    LayerCard(
        amount: -6373,
        label: "State (5.0%)",
        material: .thinMaterial,
        tint: .orange.opacity(0.2)
    )

    LayerCard(
        amount: -2841,
        label: "FICA (2.2%)",
        material: .thinMaterial,
        tint: .yellow.opacity(0.15)
    )

    // Net
    LayerCard(
        amount: 82950,
        label: "Net Proceeds",
        material: .thickMaterial,
        tint: .green.opacity(0.2)
    )
}
```

---

## 3. Advisor Conversation Context (COMPLIANCE + SHOWCASE)

### Modal: Frosted Glass Overlay

**Trigger**: Tap "From your call with Fred, Dec 18"

**Effect**: Glass modal slides up, timeline blurred behind it

```
┌─────────────────────────────────┐
│                                 │
│  [Blurred vest timeline behind] │
│                                 │
│  ┌───────────────────────────┐ │
│  │ 🗓️  Call with Fred        │ │
│  │    Dec 18, 2024 • 22 min  │ │
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
│  │ [Execute Recommendation]  │ │
│  │ [Message Fred]            │ │
│  └───────────────────────────┘ │
│                                 │
│  Tap outside to close           │
└─────────────────────────────────┘
```

**Why Liquid Glass**:
- See context (vest timeline) through frosted overlay
- Makes it crystal clear: this is from advisor, not app
- Premium feel for important financial guidance

**Compliance**:
- Never says "We recommend" or "Schwab suggests"
- Always "Fred recommends" with conversation context
- Shows what was discussed, not algorithmic advice

**Implementation**:
```swift
.sheet(isPresented: $showConversation) {
    ConversationContextView(conversation: advisorCall)
        .presentationDetents([.medium])
        .presentationBackground(.ultraThinMaterial)
}
```

---

## 4. Privacy Blur (On-Set/In-Meetings)

### Use Case: VP on set, checking phone between takes

**Default**: Dollar amounts blurred

```
┌─────────────────────────────────┐
│  UPCOMING VESTS                 │
│                                 │
│  Mar 8, 2025 • 47 days          │
│  2,500 shares                   │
│  $•••,•••  [BLURRED]            │
│                                 │
│  1,750 sh → Portfolio           │
│  750 sh → $••,•••  [BLURRED]    │
└─────────────────────────────────┘
```

**Tap + Face ID**: Glass dissolves, reveals values

```
┌─────────────────────────────────┐
│  UPCOMING VESTS                 │
│                                 │
│  Mar 8, 2025 • 47 days          │
│  2,500 shares                   │
│  $127,450  [REVEALED]           │
│                                 │
│  1,750 sh → Portfolio           │
│  750 sh → $38,235  [REVEALED]   │
└─────────────────────────────────┘
```

**Why Liquid Glass**:
- Frosted blur → clear glass transition
- Smooth animation (0.5s ease)
- Maintains context while protecting privacy

**Auto-hide**: After 10 seconds, glass frost returns

---

## 5. Countdown Progress Ring (GLANCEABLE)

### Visual: Liquid filling glass ring

```
┌─────────────────────────────────┐
│                                 │
│       ┌─────────────┐           │
│       │             │           │
│       │   47 DAYS   │           │
│       │             │           │
│       │  [Progress  │           │
│       │   Ring 68%  │           │
│       │   Filled]   │           │
│       │             │           │
│       └─────────────┘           │
│                                 │
│  Mar 8, 2025                    │
│  2,500 shares vest              │
└─────────────────────────────────┘
```

**Implementation**:
- Glass ring, filled portion has color gradient
- Empty portion is light glass (.ultraThinMaterial)
- Updates daily, smooth animation

**Why Liquid Glass**:
- Visual metaphor: time "filling up" toward vest date
- No need to calculate days mentally
- Glanceable progress

---

## 6. Multiple Vests Timeline (LAYERED CARDS)

### Visual: Stacked glass cards, scroll to separate

```
┌─────────────────────────────────┐
│  VESTING TIMELINE               │
│                                 │
│  ┌───────────────────────────┐ │
│  │ Mar 8 • 47d • $127k       │ │ ← Top card (green glass)
│  └───────────────────────────┘ │
│    ┌───────────────────────────┐│
│    │ Jun 8 • 139d • $127k      ││ ← Middle (blue glass)
│    └───────────────────────────┘│
│      ┌───────────────────────────┐
│      │ Sep 8 • 231d • $127k      │ ← Bottom (purple glass)
│      └───────────────────────────┘
│                                 │
│  Tap any card to expand         │
└─────────────────────────────────┘
```

**Interaction**:
- Scroll down → cards separate, show full details
- Tap card → expands to show 70/30 split + advisor context
- Different glass tint for each (green → blue → purple → orange)

**Why Liquid Glass**:
- Layering shows chronological relationship
- Color coding helps quick identification
- Smooth spring animation on scroll

---

## 7. Action Confirmation (EXECUTE RECOMMENDATION)

### When user taps "Execute Fred's Recommendation"

**Glass overlay slides up**:

```
┌─────────────────────────────────┐
│                                 │
│  [Vest timeline dimmed behind]  │
│                                 │
│  ┌───────────────────────────┐ │
│  │                           │ │
│  │  EXECUTE RECOMMENDATION   │ │
│  │                           │ │
│  │  This will:               │ │
│  │                           │ │
│  │  ✓ Move 1,750 shares      │ │
│  │    ($89,215) to your      │ │
│  │    diversified portfolio  │ │
│  │                           │ │
│  │  ✓ Sell 750 shares        │ │
│  │    ($38,235) and transfer │ │
│  │    to checking            │ │
│  │                           │ │
│  │  [Swipe to Confirm]       │ │
│  │  ═══════════════════════  │ │
│  │         →→→               │ │
│  │                           │ │
│  └───────────────────────────┘ │
│                                 │
└─────────────────────────────────┘
```

**Interaction**: Swipe right → glass dissolves, executes

**Why Liquid Glass**:
- See underlying vest data through confirmation screen
- Prevents accidental taps (swipe vs tap)
- Glass dissolve = "transparent" execution

---

## 8. Loading States (FETCHING ADVISOR RECOMMENDATION)

### When app loads advisor's latest recommendation

```
┌─────────────────────────────────┐
│  UPCOMING VEST                  │
│                                 │
│  Mar 8, 2025 • 47 days          │
│  2,500 shares • $127,450        │
│                                 │
│  ┌───────────────────────────┐ │
│  │                           │ │
│  │  [Glass shimmer effect]   │ │
│  │                           │ │
│  │  Loading Fred's latest    │ │
│  │  recommendation...        │ │
│  │                           │ │
│  │  ▓▓▓▓▓░░░░░░░░░          │ │
│  └───────────────────────────┘ │
└─────────────────────────────────┘
```

**Effect**: Glass card with shimmer gradient passing through

**Why Liquid Glass**:
- Maintains premium feel during loading
- Not a boring spinner
- Communicates "working" without being distracting

---

## 9. Notification Preview (VEST DAY APPROACHING)

### When user gets "7 days until vest" notification

**Lock screen notification** (can't control this, standard iOS)

**In-app alert overlay**:

```
┌─────────────────────────────────┐
│                                 │
│  [Home screen dimmed 40%]       │
│                                 │
│  ┌───────────────────────────┐ │
│  │ 🗓️  7 Days Until Vest      │ │
│  │                           │ │
│  │ Mar 8, 2025               │ │
│  │ 2,500 shares • $127k      │ │
│  │                           │ │
│  │ Fred's recommendation     │ │
│  │ is ready to execute       │ │
│  │                           │ │
│  │ [View Details]            │ │
│  │ [Dismiss]                 │ │
│  └───────────────────────────┘ │
│                                 │
└─────────────────────────────────┘
```

**Why Liquid Glass**:
- See home screen (other vests) through alert
- Maintains context
- Not a jarring interruption

---

## 10. Empty State (NO UPCOMING VESTS)

### When all vests have been processed

```
┌─────────────────────────────────┐
│                                 │
│                                 │
│       ┌─────────────┐           │
│       │             │           │
│       │   ✓         │           │
│       │             │           │
│       │  All set!   │           │
│       │             │           │
│       └─────────────┘           │
│                                 │
│  No upcoming vests              │
│                                 │
│  Your next vest date will       │
│  appear here when scheduled     │
│                                 │
└─────────────────────────────────┘
```

**Why Liquid Glass**:
- Even empty states look premium
- Clear glass circle with checkmark
- Subtle, not heavy

---

## Liquid Glass Usage Summary

### Where It's Used (10 moments):

1. **70/30 Split Visualization** - Primary showcase, interactive
2. **Tax Withholding Layers** - Educational, shows flow
3. **Advisor Conversation Context** - Compliance + premium feel
4. **Privacy Blur** - Functional privacy, smooth reveal
5. **Countdown Progress Ring** - Glanceable, visual time
6. **Multiple Vests Timeline** - Layered cards, color-coded
7. **Action Confirmation** - Transparent execution
8. **Loading States** - Premium waiting experience
9. **Notification Preview** - Contextual alerts
10. **Empty State** - Polished even when nothing to show

### Ratio:
- **70%**: Visual/interactive Liquid Glass (split viz, tax layers, timeline, confirmations)
- **30%**: Standard UI (text labels, buttons, navigation)

---

## Implementation Priority

### Phase 1 (Week 1): Core Showcase
- [x] Privacy blur with Face ID reveal
- [ ] 70/30 split visualization (tap to expand)
- [ ] Advisor conversation context modal
- [ ] Tax withholding layers

### Phase 2 (Week 2): Polish
- [ ] Countdown progress ring
- [ ] Multiple vests timeline (layered cards)
- [ ] Action confirmation (swipe to execute)
- [ ] Loading states with shimmer

### Phase 3 (Week 3): Final touches
- [ ] Notification preview overlay
- [ ] Empty state
- [ ] Device testing for smoothness
- [ ] Demo mode with perfect timing

---

## Technical Notes

### Materials Used:
- `.ultraThinMaterial` - Light blur (backgrounds)
- `.thinMaterial` - Medium blur (secondary cards)
- `.regularMaterial` - Standard blur (primary cards)
- `.thickMaterial` - Heavy blur (modals, confirmations)

### Color Tints:
- Green: Hold/diversify actions
- Orange: Sell actions
- Red: Tax withholding
- Blue: Neutral/default
- Purple: Future vests

### Animation Timing:
- **Quick**: 0.2s (button press)
- **Standard**: 0.4s (card expand)
- **Smooth**: 0.6s (split visualization morph)
- **Deliberate**: 0.8s (modal present/dismiss)

### Performance:
- All glass effects 60fps minimum
- Test on iPhone SE (slowest target device)
- Reduce motion support (simpler animations)

---

## Demo Script

**"Let me show you what we're building..."**

1. Open app → "This is a vest tracking experience for [client] employees"
2. Tap privacy blur → Face ID reveal → "On-set privacy"
3. Tap 70/30 split card → Glass morphs → "Interactive split visualization"
4. Tap "From Fred" → Modal slides up → "Advisor conversation context - no compliance issues"
5. Tap "Execute" → Swipe confirmation → "Transparent execution"
6. Show timeline → Scroll → Cards separate → "Layered glass timeline"

**Total demo time**: 90 seconds

**What you've shown**:
- Working code (not Figma)
- Liquid Glass as functional UX (not decoration)
- Mobile-first experience
- Compliance-aware design
- Thinking about real user needs (privacy, time savings, advisor relationship)

---

**This is the spec. Every screen uses Liquid Glass purposefully.**
