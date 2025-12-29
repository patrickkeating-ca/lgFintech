# HIG Compliance Review - Recommendations for Next Session

## Overall Assessment
- **Robinhood Minimalism**: 85% ✓
- **Apple HIG**: 75% (fixable gaps)
- **Liquid Glass Aesthetic**: 90% ✓

---

## Critical Issues (Fix First)

### 1. VestCard Gesture Handling - HIGH PRIORITY
**File**: `VestCard.swift` (lines 72-85)

**Issue**: Using manual `.simultaneousGesture(DragGesture())` instead of Button
- Breaks VoiceOver button semantics
- No keyboard navigation support
- Doesn't respect AssistiveTouch

**Fix**: Refactor to use Button + custom ButtonStyle with shimmer effect

### 2. Button Styles - HIGH PRIORITY
**Files**:
- `ApprovalButtons.swift` (lines 17-25, 29-37)
- `ApprovalConfirmationSheet.swift` (lines 132-143, 146-156)
- `VestDetailsSheet.swift` (lines 151-161)
- `AdvisorContactCard.swift` (lines 59-117)

**Issue**: Manual button styling instead of `.buttonStyle()`
- Loses Dynamic Type scaling
- No accessibility settings support (Bold Text, Increased Contrast)
- No automatic disabled state

**Fix**:
```swift
// Replace:
.background(.green)
.foregroundStyle(.white)
.clipShape(RoundedRectangle(cornerRadius: 12))

// With:
.buttonStyle(.borderedProminent)
.tint(.green)
.controlSize(.large)
```

### 3. Sheet Presentation - MEDIUM PRIORITY
**Files**:
- `VestDetailsSheet.swift` (line 178)
- `ApprovalConfirmationSheet.swift` (line 163)

**Issue**: Missing `.presentationContentInteraction(.scrolls)`
- Users can't scroll smoothly at top of sheet
- Accidentally dismiss when trying to scroll

**Fix**: Add after `.presentationDetents([.large])`

---

## Quick Wins (< 1 hour each)

### 1. Color Accessibility
**File**: `TradeRecommendationCard.swift` (lines 37, 61)
```swift
// Change:
.background(Color.blue.opacity(0.05))

// To:
.background(Color.blue.opacity(0.1))  // Better contrast
```

### 2. Dynamic Type Support
**File**: `VestCard.swift` (line 18)
```swift
// Add cap to prevent excessive scaling:
.font(.system(size: 34, weight: .bold, design: .rounded))
.dynamicTypeSize(...<DynamicTypeSize.xxxLarge)
```

### 3. Add Border Highlights (Liquid Glass Enhancement)
**All card components**
```swift
.overlay(
    RoundedRectangle(cornerRadius: 16)
        .strokeBorder(
            LinearGradient(
                colors: [.white.opacity(0.3), .white.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            lineWidth: 1
        )
)
```

### 4. Accessibility Actions for Expandable Cards
**Files**: `AboutThisPlanCard`, `ExecutionTimelineCard`, `AdvisorContactCard`
```swift
.accessibilityAddTraits(.isButton)
.accessibilityAction(.magicTap) {
    withAnimation { isExpanded.toggle() }
}
```

---

## Medium Refactors (2-4 hours)

### 1. VestDetailsSheet - Use List + LabeledContent
**Current**: Manual VStack with HStacks
**Better**: Native List with LabeledContent (iOS 16+)

```swift
List {
    Section("ESTIMATE") {
        LabeledContent("Total Shares", value: vest.sharesVesting.formatted())
        LabeledContent("Current Stock Price", value: vest.stockPrice.formatted(.currency(code: "USD")))
    }
    Section("ESTIMATED TAX WITHHOLDING") {
        // Tax rows
    }
}
.listStyle(.insetGrouped)
```

**Benefits**:
- Automatic row highlighting
- Better VoiceOver navigation
- Native iOS feel

### 2. Create ExpandableCard Reusable Component
**Current**: Duplicated expansion logic in 3 components
**Better**: Single reusable `ExpandableCard` component

**Affected files**:
- `AboutThisPlanCard.swift`
- `ExecutionTimelineCard.swift`
- `AdvisorContactCard.swift`

### 3. Standardize ButtonStyle Usage
- Create custom `ButtonStyle` subclasses for common patterns
- Replace all manual styling
- Automatic accessibility wins

---

## Major Refactors (1+ day)

### 1. VestCard Complete Refactor
- Convert to Button with custom ButtonStyle
- Preserve shimmer effect in ButtonStyle implementation
- Add keyboard navigation
- Proper accessibility semantics

### 2. Design System Package
- CardStyle protocol
- Spacing constants (4, 8, 12, 16, 20)
- Color tokens (semantic colors)
- Reusable typography styles

---

## Liquid Glass Enhancements

### Enhanced Shimmer Effect
**File**: `VestCard.swift`
```swift
Rectangle()
    .fill(gradient)
    .blur(radius: 20)  // Softer glow
    .blendMode(.plusLighter)  // Additive blending
```

### Card Border Highlights
- Add subtle gradient strokes to all cards
- Enhances glass effect
- Better depth perception

---

## Priority Order

**Session 1 (Tonight's work)**: ✅
- [x] Remove "4 key dates • Tap to expand" from ExecutionTimelineCard

**Session 2 (Next time - 1-2 hours)**:
1. Add `.presentationContentInteraction(.scrolls)` to sheets
2. Increase color opacity (0.05 → 0.1) in TradeRecommendationCard
3. Add Dynamic Type cap to VestCard
4. Add border highlights to all cards

**Session 3 (Quick fixes - 2-3 hours)**:
5. Add accessibility actions to expandable cards
6. Replace button styling with `.buttonStyle()`

**Session 4 (Refactors - 4-6 hours)**:
7. Refactor VestDetailsSheet to List
8. Create ExpandableCard component
9. Fix VestCard gesture handling

**Future (Polish phase)**:
10. Design system extraction
11. Advanced Liquid Glass effects
12. Comprehensive accessibility audit

---

## Testing Checklist

Before considering HIG compliance complete:

- [ ] Test with VoiceOver enabled
- [ ] Test with Dynamic Type at largest size
- [ ] Test with Reduce Motion enabled
- [ ] Test with Increase Contrast enabled
- [ ] Test with Bold Text enabled
- [ ] Test keyboard navigation (external keyboard)
- [ ] Run Accessibility Inspector
- [ ] Test on actual device (not just simulator)

---

## Notes

**Strengths**:
- Excellent consistency across components
- Strong Liquid Glass aesthetic implementation
- Good progressive disclosure patterns
- Clean animation and interaction design

**Areas for improvement**:
- Native button patterns
- Accessibility semantic markup
- Dynamic Type support
- Gesture handling

**Overall**: Components are 75-90% HIG compliant. With recommended fixes, can achieve 95%+ compliance while maintaining distinctive visual style.
