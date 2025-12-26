# Execution Timeline & Approval Model

## The Core Question

**Does Alex/Marcus REVIEW & APPROVE or REVIEW & EXECUTE?**

This determines:
- What information must be visible
- Who pulls the trigger
- Where complexity lives (UI vs Fred's back-office)
- Trust model (advisor-as-guide vs advisor-as-manager)

---

## Alex's Missing Pieces (From Critique)

1. **Post-execution timeline** - What happens after I hit the button?
2. **Settlement timing** - When do funds hit my checking?
3. **DAF coordination** - Where's Maria in this flow?
4. **Tax withholding** - Automatic or manual setup?
5. **Build My Own Plan** - What does it do? Does Fred review?
6. **Cancellation window** - Can I change my mind? Until when?
7. **Market movement scenarios** - What if price changes significantly?

---

## Timeline Elements (Apply to Both Personas)

### Shared Timeline Milestones:

**Today → Vest Date:**
- **Approve Plan** (Today) - Alex/Marcus reviews and authorizes
- **Modification Window** (e.g., up to 7 days before vest) - Can change/cancel
- **Modification Deadline** (e.g., Feb 13 in Alex's data) - Last chance to change
- **Blackout Period** (if applicable) - No changes allowed
- **Vest Date** (Feb 6) - Shares become yours
- **Execution Date** (Same as vest? Day after?) - Trades execute
- **Settlement Date** (T+2 after execution) - Funds hit checking account

### Questions to Answer:

1. **Who can modify during the modification window?**
   - Alex/Marcus can cancel online?
   - Must call Fred to modify?
   - Fred can modify if Alex approves via message?

2. **Build My Own Plan - does it reset the timeline?**
   - Same modification deadline?
   - Does custom plan need Fred's review?
   - Can Marcus (non-premium) even build custom?

3. **Execution timing:**
   - Does Fred execute at market open on Feb 6?
   - Does Alex approve a specific execution window?
   - Limit order vs market order - who decides?

4. **DAF coordination (Alex-specific):**
   - Does Fred handle the DAF transfer to Maria?
   - Does Alex need to approve DAF separately?
   - Is DAF part of the 30% sell or separate?

---

## Two Possible Models

### Model A: Review & Approve (White-Glove)

**Alex's action:** "Yes, execute this plan on Feb 6"

**What happens:**
1. Alex approves plan today
2. Fred schedules execution for Feb 6
3. Modification window open until Feb 13
4. Fred executes trades on Feb 6 at market open
5. Fred coordinates DAF with Maria
6. Settlement T+2 (Feb 10) - funds in checking
7. Fred sends confirmation: "Plan executed, funds settling Feb 10"

**UI shows:**
```
┌─────────────────────────────────────┐
│ Execution Timeline                  │
├─────────────────────────────────────┤
│ Today: Approve Plan                 │
│ Until Feb 13: Modify or cancel      │
│ Feb 6: Vest & execute (Fred)        │
│ Feb 10: Funds in checking (T+2)     │
└─────────────────────────────────────┘

Button: "Approve Plan"
Secondary: "Modify Plan" (available until Feb 13)
```

**Pros:**
- Clean, simple for Alex
- Fred handles execution complexity
- Matches premium white-glove expectation

**Cons:**
- Less control for Alex
- What if Alex wants to change execution timing?

---

### Model B: Review & Execute (Self-Directed)

**Alex's action:** "I'll execute this on Feb 6 when shares vest"

**What happens:**
1. Alex reviews plan today
2. Alex logs in on Feb 6
3. Alex clicks "Execute Trades"
4. Alex reviews trade ticket (market order, limit order, etc.)
5. Alex confirms execution
6. Schwab executes trades
7. Settlement T+2 (Feb 10)
8. Alex coordinates with Maria for DAF separately

**UI shows:**
```
┌─────────────────────────────────────┐
│ Execution Details                   │
├─────────────────────────────────────┤
│ Feb 6: Shares vest at market open   │
│ Feb 6: You execute trades (window)  │
│ Feb 10: Settlement (T+2)            │
│ Feb 10: Funds available             │
├─────────────────────────────────────┤
│ Order Type: Market (editable)       │
│ Tax Withholding: Auto (24% Fed)     │
│ Settlement Account: Checking (...42)│
└─────────────────────────────────────┘

Button: "Review Trade Ticket"
(On Feb 6: "Execute Trades")
```

**Pros:**
- Full control and transparency
- Alex chooses exact execution moment
- Clear mechanics

**Cons:**
- Alex must log in on Feb 6
- More cognitive load
- Doesn't match "Fred handles it" premium expectation

---

## Hybrid Model (Most Likely)?

**Default: Fred executes (Model A)**
**Option: Alex can choose to self-execute (Model B)**

**UI:**
```
┌─────────────────────────────────────┐
│ How to Execute                      │
├─────────────────────────────────────┤
│ ○ Fred executes on Feb 6 (recommended)
│   Timeline: Approve → Feb 13 modify deadline →
│   Feb 6 execution → Feb 10 settlement
│
│ ○ I'll execute on Feb 6
│   You'll receive a reminder. Execute trades
│   yourself on vest date.
└─────────────────────────────────────┘
```

---

## What to Show in Current Prototype (Minimal Bloat)

### Option 1: Execution Timeline Card (Collapsible)

Add after "Fred's Plan", before buttons:

```
┌─────────────────────────────────────┐
│ Execution Timeline          [v]      │
├─────────────────────────────────────┤
│ Feb 6: Vest & execute               │
│ Feb 10: Funds in checking (T+2)     │
│ Modify until: Feb 13                │
└─────────────────────────────────────┘
```

Tappable for expansion:
- Today: Approve plan
- Feb 6: Fred executes at market open
- Feb 10: Settlement complete
- Can modify/cancel until Feb 13

### Option 2: Just Change Button Text

**From:** "Review & Execute"
**To:** "Approve Plan" or "Authorize Execution"

Add subtext:
"Fred will execute on Feb 6. Funds settle Feb 10."

### Option 3: Post-Tap Confirmation Screen

Don't show timeline upfront. When Alex taps "Review & Execute":

**Confirmation screen shows:**
- Plan summary (70/30 split)
- Execution timeline
- Settlement date
- Modification window
- "Confirm Authorization" button

---

## DAF Question (Alex-Specific)

**Current:** "Sell 30% → Checking account"

**Reality:** Some of that 30% goes to DAF, coordinated with Maria

**Options:**

1. **Show 3-way split:**
   ```
   Hold: 2,401 shares → Portfolio
   Sell: 800 shares → Checking
   Donate: 229 shares → DAF (via Maria)
   ```

2. **Keep 2-way, clarify in notes:**
   ```
   Sell: 1,029 shares → Checking & DAF
   (Fred coordinates DAF with Maria)
   ```

3. **Progressive disclosure:**
   Tap "Sell 1,029 shares" shows breakdown:
   - 800 shares → Checking
   - 229 shares → DAF (Maria coordinating)

---

## Build My Own Plan - Clarification Needed

**If Marcus taps "Build My Own Plan":**
- Does he get a slider (0-100% split)?
- Can he still get Fred's input?
- Same timeline/execution model?
- Does it save as "pending" until approved?

**Likely behavior:**
1. Opens custom plan builder
2. Adjusts split, destinations
3. Sees updated tax impact
4. Can save as draft
5. Can send to Fred for review (Premium only?)
6. Approves final version
7. Same execution timeline as Fred's plan

---

## Recommendation: Start with Model A (Approve)

**Reasoning:**
- Matches premium expectation
- Fred/Maria coordination requires it
- Reduces Alex's burden
- Marcus can have same model (Fred optional)

**Minimal additions to current prototype:**

1. **Change button:** "Review & Execute" → "Approve Plan"
2. **Add timeline card (collapsible):**
   - Feb 6: Vest & execute
   - Feb 10: Funds available
   - Modify until Feb 13
3. **Change advisor note:** "Fred will execute this plan on Feb 6"
4. **Confirmation screen (post-tap):**
   - Full timeline
   - Settlement details
   - "Confirm" creates authorization

**Next iteration:**
- Add "Build My Own Plan" flow
- Add DAF 3-way split for Alex
- Add state tax to modal
- Add modification/cancellation UI

---

## Open Questions for Business Decision:

1. **Does Schwab Premium currently offer trade execution on behalf of clients?**
   - Or is it advice-only, client executes?

2. **What's the legal/compliance model?**
   - Discretionary management (Fred can trade)?
   - Advisory only (Alex must click)?

3. **For DIFM (Done-For-Me) tier:**
   - Is execution included?
   - Or just planning/coordination?

4. **Marcus (Standard) vs Alex (Premium):**
   - Same execution model?
   - Or Marcus must self-execute, Alex gets Fred's execution?

---

**This changes everything about the UI. Need business answer before finalizing.**
