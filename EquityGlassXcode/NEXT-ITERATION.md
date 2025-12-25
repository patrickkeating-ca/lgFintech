# Next Iteration - Premium Polish & Personalization

*Created: December 24, 2025*

---

## 1. Personalize Execution Flow by User Tier

**Problem:** Alex and Marcus see identical execution flow, but their situations differ.

**Alex (VP, $384K, Premium):**
- Has DAF coordination with Maria (tax specialist)
- Charitable giving strategy
- Next Steps: "Coordinate DAF with Maria (Tax Specialist)"

**Marcus (IT Manager, $67K, Standard):**
- No tax specialist
- No DAF
- Next Steps: Should be different or absent

**Solution:**
- Conditional Next Steps section based on user data
- Check if `advisorRecommendation` includes DAF mention
- Or add tier field to user model
- Marcus might see: "Review tax withholding in Schwab portal" instead

---

## 2. Information Hierarchy - What's the Meat?

**Current state:**
- "3 vests scheduled in 2026" (collapsed)
- "Upcoming Events" timeline carousel
- Execution is buried as one of many elements

**User feedback:**
> "The meat is the execution. Need to think through this."

**Questions:**
- Is the upcoming events timeline essential upfront?
- Should execution be more prominent?
- Do users care about September events when February is 48 days away?

**Considerations:**
- Timeline shows 12 events (too much?)
- Execution (Fred's Plan) is what drives action
- 3 vests scheduled is passive info

**Possible solutions:**
- Collapse or minimize timeline by default
- Make "Execute Plan" button more prominent earlier
- Timeline: Next 3 events only, "View All" option
- Reorder: Stock → Money → Fred → Execute (tight grouping)

---

## 3. Make Vest Info Feel Seamless & Premium

**Current structure feels disjointed:**

```
┌─────────────────────────────────┐
│ VestCard                        │
│ - Upcoming Vest header          │
│ - 3,430 shares                  │
│ - $384,777                      │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│ AdvisorHeroCard                 │
│ - Fred Amsden, CFP®             │
│ - Hold 70% / Sell 30%           │
│ - Execute Plan button           │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│ TaxWithholdingLayers            │
│ - Gross → Federal → State → Net │
└─────────────────────────────────┘
```

**Why it feels disjointed:**
- Three separate cards
- Visual hierarchy unclear
- Feels like browsing, not executing

**Premium experience should feel:**
- Unified story: "Here's your vest → Here's Fred's plan → Execute"
- Visual flow guides eye naturally
- Less scrolling to see full picture

**Ideas to explore:**

### Option A: Unified Vest Summary Card
- Combine VestCard + Fred + Execute into single component
- Sections within one card instead of three cards
- Natural reading flow top-to-bottom

### Option B: Progressive Disclosure
- Vest amount prominent
- Fred's recommendation expands inline
- Execute button appears after expansion
- Tax breakdown on separate screen (after execution)

### Option C: Step Progression
- "Your Vest" → "Fred's Recommendation" → "Execute"
- Visual stepper showing current position
- Swipe between sections?

### Option D: Layered Cards (Depth)
- Main card: Vest amount + Execute
- Fred's card overlays/slides over when needed
- Tax as modal or bottom sheet
- Z-axis hierarchy instead of Y-axis scroll

**Questions to answer:**
- Is tax breakdown essential pre-execution?
- Should Execute Plan be above-the-fold?
- Can we reduce 3 cards to 2? Or 1?

---

## 4. Other Polish Items

**From critique:**
- [ ] Fred's avatar: Replace placeholder with stock photo
- [ ] P&L from previous vest: Show track record
- [ ] Timeline: Focus on next 3 events, not all 12
- [ ] Calendar badge: Wire up or remove (currently visual only)

**Liquid Glass opportunities:**
- [ ] Transitions between cards
- [ ] Card stacking animations
- [ ] Scroll-based parallax effects
- [ ] Ambient lighting on cards

---

## Summary

**Core tension:**
Mobile-first users want instant execution, but comprehensive financial info requires context.

**Current:** Information-heavy (read-first)
**Goal:** Action-oriented (do-first) while maintaining premium feel

**Next session priorities:**
1. Personalize execution flow (Alex vs Marcus)
2. Prototype unified vest → recommendation → execute flow
3. Test reduced timeline (3 events vs 12)
4. Evaluate card consolidation options
