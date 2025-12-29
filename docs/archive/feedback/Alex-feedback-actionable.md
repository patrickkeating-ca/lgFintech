# Alex's Feedback - Actionable Items

## Correct Alex Scenario (from scenario-alex.json)
- **70% hold** → Diversified portfolio (long-term growth)
- **30% sell** → Tax withholding + charitable contributions (DAF)
- **Maria coordinates** → Donor-advised fund transfer
- **Discussion topics:** Tax-loss harvesting, DAF strategy, Q1 charitable giving alignment, 70/30 execution timing

**NOT house down payment - that's wrong scenario**

---

## Alex's Critique - Raw Feedback

### What Would Stop Him from Executing:

1. **What happens AFTER I execute?**
   - Is there a confirmation screen?
   - Can I cancel this before Feb 6?
   - Trade Modification Deadline (Feb 13 in timeline) - why isn't that visible here?

2. **Settlement timeline is missing**
   - When do sold shares actually hit checking account?
   - T+2? T+3?
   - Matters for timing (tax payment, DAF coordination)
   - Fred and I discussed timing - where's that info?

3. **The DAF piece is buried**
   - Fred's notes mention 'Maria will coordinate DAF transfer'
   - That's part of the 30% sell, right?
   - How much to DAF vs checking?
   - Should be in split visualization, not hidden in notes

4. **Tax withholding - is it automatic?**
   - Modal shows tax estimates
   - Does Schwab automatically withhold federal/FICA?
   - Or do I set that up separately?
   - CA state tax - missing from modal

5. **The 'Build My Own Plan' button**
   - What does that do?
   - Start from scratch? Modify Fred's plan?
   - If I modify, do I lose Fred's recommendation?
   - Can Fred review my custom plan before I execute?

6. **Risk/market movement**
   - 48 days away, stock could move significantly
   - Is there a 'what if the price changes' scenario planner?
   - Fred and I discussed this - not seeing it reflected

### What Alex Would Add:

1. **Execution timeline card** - What happens on Feb 6, when funds arrive, cancellation deadline
2. **Destination breakdown** - Show DAF explicitly: Hold/Sell/Donate
3. **Safety mechanisms** - Confirmation screen preview, modification window, 'not final yet' messaging
4. **State tax** - CA withholding missing from modal
5. **Fred's availability** - 'Questions? Fred responds within 1 business day' somewhere visible

---

## Grouped by Module (Actionable Items)

### GROUP 1: Execution Timeline & Deadlines
**What:** Show when things happen, when he can modify, when it's final

**Items:**
- [ ] Add execution timeline (Feb 6 vest/execute, Feb 10 settlement, Feb 13 modification deadline)
- [ ] Show settlement timing (T+2 = when funds hit checking)
- [ ] Show "can modify until Feb 13" messaging
- [ ] Clarify what happens post-button tap (confirmation screen, not instant execution)

**Modular approach:**
- Collapsible timeline card after "Fred's Plan"
- Or: Progressive disclosure (tap "Review & Execute" shows timeline first)

---

### GROUP 2: DAF Visibility & Destination Breakdown
**What:** Make DAF explicit, not buried in notes

**Items:**
- [ ] Fix scenario text (remove "house down payment", use correct Alex scenario)
- [ ] Show DAF in split visualization (3-way split or clarify within 30%)
- [ ] Show Maria's role in DAF coordination
- [ ] Clarify: checking vs DAF amounts

**Modular approach:**
- Option A: 3-way split (Hold 70% / Sell for taxes 20% / Donate to DAF 10%)
- Option B: 2-way split, tap "Sell 30%" to expand breakdown
- Option C: Add DAF note under "Sell" box: "Includes DAF (Maria coordinating)"

**Question:** Do we have actual DAF split amount? Or just "some of the 30%"?

---

### GROUP 3: Tax Withholding Clarity
**What:** Is it automatic? Show CA state tax

**Items:**
- [ ] Add CA state tax to vest details modal (~$42K at 11% from taxEstimate)
- [ ] Clarify automatic withholding (federal 27.7%, FICA 1.5%, CA 11%)
- [ ] Show net after ALL taxes (not just federal + FICA)

**Modular approach:**
- Update modal to include state tax row
- Add disclaimer: "Schwab withholds automatically at vest"

---

### GROUP 4: Safety & Reversibility
**What:** Can I change my mind? When? How?

**Items:**
- [ ] Add "This is not final" messaging
- [ ] Show modification window (until Feb 13)
- [ ] Clarify button action: "Approve Plan" not "Execute Now"
- [ ] Confirmation screen before final approval

**Modular approach:**
- Change button text: "Review & Approve Plan"
- Add subtext: "You can modify until Feb 13"
- Post-tap: Show confirmation screen with full timeline

---

### GROUP 5: Build My Own Plan Clarity
**What:** What does this button do? Can Fred review?

**Items:**
- [ ] Clarify button purpose (modify Fred's plan vs start from scratch)
- [ ] Show if Fred can review custom plans
- [ ] Maintain same timeline/execution model for custom plans

**Modular approach:**
- On tap: Modal explaining "Adjust split, preview impact, Fred can review"
- Or: Just improve button label: "Customize This Plan"

---

### GROUP 6: Fred's Availability
**What:** How do I reach Fred if I have questions?

**Items:**
- [ ] Add "Questions? Fred responds within 1 business day"
- [ ] Make Fred's contact info more visible (currently buried in collapsed section)

**Modular approach:**
- Add small note near "About This Plan"
- Or: Keep in advisor section but make it less buried

---

### GROUP 7: Market Movement / Scenario Planning
**What:** What if stock price changes significantly?

**Items:**
- [ ] Add scenario planner (if price goes to X, value = Y)
- [ ] Show price sensitivity

**Modular approach:**
- This might be bloat for v1
- Could be: Tap shares → modal includes "Price sensitivity" section
- Or: Separate tool: "What if calculator"

**VERDICT:** Defer to later iteration (adds complexity)

---

## Prioritized by Impact & Modularity

### TIER 1: Must Address (Blocking Execution)

1. **Fix scenario text** - Wrong persona (house down payment → tax withholding + charitable)
2. **Add execution timeline** - Feb 6 vest, Feb 10 settlement, Feb 13 modify deadline
3. **Show DAF explicitly** - Either 3-way split or clarify within 30% sell
4. **Add CA state tax to modal** - Currently missing, shows incomplete picture
5. **Change button to "Approve Plan"** - Not "Execute" (timeline confusion)

### TIER 2: Important for Trust (Reduces Friction)

6. **Add "modify until Feb 13" messaging** - Safety/reversibility
7. **Clarify tax withholding is automatic** - Reduces setup questions
8. **Post-tap confirmation screen** - Shows full timeline before final approval
9. **Fred's availability note** - "Questions? Fred responds in 1 day"

### TIER 3: Nice to Have (Refinement)

10. **Improve "Build My Own Plan" label** - "Customize This Plan" clearer
11. **Add DAF coordination note** - "Maria coordinating" under split

### TIER 4: Defer (Complexity vs Value)

12. **Market movement scenario planner** - Adds significant complexity, defer

---

## Proposed Modular Additions (Minimal Bloat)

### Addition 1: Execution Timeline Card (Collapsible)

**Location:** After "Fred's Plan", before buttons

```
┌─────────────────────────────────────┐
│ Execution Timeline          [▼]     │
└─────────────────────────────────────┘
```

**Collapsed (default):** Just header with caret

**Expanded (tap to reveal):**
```
┌─────────────────────────────────────┐
│ Execution Timeline          [▲]     │
├─────────────────────────────────────┤
│ Today                               │
│ Approve this plan                   │
│                                     │
│ Until Feb 13                        │
│ Modify or cancel anytime            │
│                                     │
│ Feb 6                               │
│ Vest & execute                      │
│                                     │
│ Feb 10 (T+2)                        │
│ Funds in checking                   │
└─────────────────────────────────────┘
```

**CSS:** Same pattern as "About This Plan" (progressive disclosure)

---

### Addition 2: DAF in Split (Option B - Progressive Disclosure)

**Current:**
```
┌──────────────┬──────────────┐
│ HOLD         │ SELL         │
│ 2,401 shares │ 1,029 shares │
│ → Portfolio  │ → Checking   │
└──────────────┴──────────────┘
```

**Proposed (tap "Sell" box to expand):**
```
┌──────────────┬──────────────┐
│ HOLD         │ SELL ▼       │
│ 2,401 shares │ 1,029 shares │
│ → Portfolio  │ ─────────────│
│              │ → Checking   │
│              │ → DAF (Maria)│
└──────────────┴──────────────┘
```

**Alternative (simpler):** Just add note under "Sell" box:
"Includes DAF transfer (Maria coordinating)"

---

### Addition 3: Update Vest Modal (State Tax)

**Current modal sections:**
- Estimate (shares, price, value)
- Tax Withholding (Federal, FICA, net)

**Add:**
```
Tax Withholding (Est.)
  Federal Tax (27.7%)     ~$106,583
  State Tax (11%)         ~$42,326
  FICA (1.5%)            ~$5,772
  ──────────────────────────────────
  Net After Taxes         ~$230,096

  Schwab withholds automatically at vest.
```

---

### Addition 4: Button & Subtext Change

**Current:**
```
[Review & Execute]
[Build My Own Plan]
```

**Proposed:**
```
[Approve Plan]
You can modify until Feb 13

[Customize This Plan]
```

---

### Addition 5: Fred Availability Note

**Location:** In "About This Plan" section, after meta line

**Current:**
```
About This Plan
Conversation with Fred Amsden, CFP® • Dec 18, 28 min
Hold 70% for long-term growth, sell 30% for [CORRECT SCENARIO]
Tap for notes [▼]
```

**Proposed:**
```
About This Plan
Conversation with Fred Amsden, CFP® • Dec 18, 28 min
Questions? Fred responds within 1 business day

Hold 70% for diversified portfolio, sell 30% for taxes & charitable giving
Tap for notes [▼]
```

---

## Questions Before Implementation

1. **DAF amount:** Do we have actual split (e.g., 20% checking, 10% DAF)? Or just "30% includes DAF"?

2. **Confirmation screen:** Post-tap, before final approval? Or approval is instant?

3. **Build My Own Plan:** Does it modify Fred's plan or start from scratch? Can Fred review?

4. **Market movement scenario:** Defer entirely or add simple version?

5. **Net after taxes:** Show in modal only or also somewhere on main screen?

---

## Ready to Refine/Remove?

Let me know which groups to keep, which to defer, and any questions to clarify before implementation.
