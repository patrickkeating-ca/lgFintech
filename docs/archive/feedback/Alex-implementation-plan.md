# Alex Implementation Plan - Refined

## Clarifications Received

### 1. Execution Timeline
**Vest day = Sell day = Get funds**
- No T+2 settlement wait
- Shares that sell → funds available same day (Feb 6)
- Simplifies timeline significantly

### 2. DAF
**Omit entirely**
- Back to 2-way split: Hold 70% / Sell 30%
- Destination: Portfolio / Checking
- Remove all DAF mentions from this screen

### 3. Safety Mechanisms - Specific Language Required
**Key messaging:**
> "You are giving me authority to do this on your behalf. You still have time during the cancellation window to bail. If we see something, we can re-open and readjust, or cancel entirely the sale (in which case your vesting shares will be 100% held)."

**Visual approach:**
- Use calendar icons
- Show: Cancellation date: <date>
- Show: Vest date: <date>

### 4. State Tax
- Already in iOS app
- If easy to add to HTML mockup, do it
- Otherwise skip for mockup

### 5. Fred's Availability
**Different screen - NOT this one**
- Belongs on update/confirmation screen
- Flow: Landing → Execute → Review → Approve → Confirm → Landing (updated)
- After approval, "Execute" button changes to status text with Fred availability
- May show at top or in Message Center
- **ACTION:** Carry this thinking to app later, skip for this mockup

---

## Implementation Tasks for robinhood-mockup-alex-v2.html

### TASK 1: Fix Scenario Text
**Current (wrong):**
```
Hold 70% for long-term growth, sell 30% for house down payment and taxes
```

**Correct:**
```
Hold 70% for diversified portfolio, sell 30% for tax withholding and charitable giving
```

**Location:** Line ~487 in plan-overview div

---

### TASK 2: Remove DAF from Discussion Notes
**Current discussion points:**
- House down payment timing and cash needs ❌
- PSU risk tolerance and diversification strategy ✓
- ESPP contribution decisions for next quarter ✓
- 70/30 split balances short-term (house) and long-term goals ❌

**Update to:**
- Tax withholding strategy and timing
- Charitable giving coordination for Q1
- Diversification and concentration risk management
- 70/30 split balances tax efficiency and long-term growth

**Location:** Line ~497-501 in plan-notes-text

---

### TASK 3: Simplify Split Destinations
**Current:**
```html
<div class="split-destination">→ Your portfolio</div>
<div class="split-destination">→ Checking account</div>
```

**Keep as-is** (no DAF needed)

**Optional cleanup:** Change "Your portfolio" to just "Portfolio" (avoid possessive per earlier feedback)

---

### TASK 4: Add Execution Timeline Card (Collapsible)

**Location:** After "Fred's Plan" label, before split preview (around line 527)

**HTML Structure:**
```html
<!-- Execution Timeline (Collapsible) -->
<div class="execution-timeline" onclick="toggleExecutionTimeline()">
    <div class="timeline-header">
        <span>Execution Timeline</span>
        <div class="timeline-caret" id="timelineCaret">
            <svg width="12" height="12" viewBox="0 0 12 12" fill="#666">
                <path d="M3 5l3 3 3-3" stroke="#666" stroke-width="1.5" fill="none"/>
            </svg>
        </div>
    </div>

    <div class="timeline-details" id="timelineDetails">
        <div class="timeline-item">
            <svg class="timeline-icon" viewBox="0 0 24 24" fill="none" stroke="#00C805" stroke-width="2">
                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
                <line x1="16" y1="2" x2="16" y2="6"/>
                <line x1="8" y1="2" x2="8" y2="6"/>
                <line x1="3" y1="10" x2="21" y2="10"/>
            </svg>
            <div class="timeline-content">
                <div class="timeline-label">Vest Date</div>
                <div class="timeline-value">Feb 6, 2026</div>
                <div class="timeline-description">Shares vest & sell executes • Funds available same day</div>
            </div>
        </div>

        <div class="timeline-item">
            <svg class="timeline-icon" viewBox="0 0 24 24" fill="none" stroke="#666" stroke-width="2">
                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
                <line x1="16" y1="2" x2="16" y2="6"/>
                <line x1="8" y1="2" x2="8" y2="6"/>
                <line x1="3" y1="10" x2="21" y2="10"/>
                <path d="M8 14l2 2 4-4" stroke="#666" stroke-width="2"/>
            </svg>
            <div class="timeline-content">
                <div class="timeline-label">Cancellation Window</div>
                <div class="timeline-value">Until Feb 13, 2026</div>
                <div class="timeline-description">Modify or cancel anytime before this date</div>
            </div>
        </div>
    </div>
</div>
```

**CSS (add to style section):**
```css
.execution-timeline {
    background: #0d0d0d;
    border-radius: 8px;
    padding: 12px;
    margin-bottom: 16px;
    cursor: pointer;
}

.timeline-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 13px;
    color: #999;
    font-weight: 600;
}

.timeline-caret {
    color: #666;
    transition: transform 0.2s ease;
}

.timeline-caret.rotate {
    transform: rotate(180deg);
}

.timeline-details {
    display: none;
    margin-top: 16px;
}

.timeline-details.show {
    display: block;
}

.timeline-item {
    display: flex;
    gap: 12px;
    margin-bottom: 16px;
}

.timeline-item:last-child {
    margin-bottom: 0;
}

.timeline-icon {
    width: 20px;
    height: 20px;
    flex-shrink: 0;
    margin-top: 2px;
}

.timeline-content {
    flex: 1;
}

.timeline-label {
    font-size: 11px;
    color: #666;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 4px;
}

.timeline-value {
    font-size: 15px;
    font-weight: 700;
    color: #fff;
    margin-bottom: 4px;
}

.timeline-description {
    font-size: 12px;
    color: #999;
    line-height: 1.3;
}
```

**JavaScript (add to script section):**
```javascript
function toggleExecutionTimeline() {
    const details = document.getElementById('timelineDetails');
    const caret = document.getElementById('timelineCaret');
    details.classList.toggle('show');
    caret.classList.toggle('rotate');
}
```

---

### TASK 5: Update Button Text & Add Safety Language

**Current:**
```html
<button class="execute-btn" onclick="executeVest()">Review & Execute</button>
```

**Update to:**
```html
<div class="authority-notice">
    You are authorizing Fred to execute this plan on your behalf on Feb 6. You can modify or cancel until Feb 13.
</div>
<button class="execute-btn" onclick="executeVest()">Approve Plan</button>
```

**CSS (add):**
```css
.authority-notice {
    font-size: 12px;
    color: #999;
    line-height: 1.4;
    margin-bottom: 12px;
    padding: 10px;
    background: #0d0d0d;
    border-radius: 6px;
    border-left: 2px solid #00C805;
}
```

---

### TASK 6: Add State Tax to Modal (If Easy)

**Current modal tax section (lines ~586-602):**
```html
<div class="modal-section">
    <div class="modal-section-title">Tax Withholding (Est.)</div>
    <div class="modal-item">
        <div class="modal-item-label">Federal Tax (24%)</div>
        <div class="modal-item-value">~$92,346</div>
    </div>
    <div class="modal-item">
        <div class="modal-item-label">FICA (1.5%)</div>
        <div class="modal-item-value">~$5,772</div>
    </div>
    <div class="modal-item">
        <div class="modal-item-label">Net After Taxes</div>
        <div class="modal-item-value">~$286,659</div>
    </div>
    ...
</div>
```

**Update to (using Alex's taxEstimate data):**
```html
<div class="modal-section">
    <div class="modal-section-title">Tax Withholding (Est.)</div>
    <div class="modal-item">
        <div class="modal-item-label">Federal Tax (27.7%)</div>
        <div class="modal-item-value">~$106,583</div>
    </div>
    <div class="modal-item">
        <div class="modal-item-label">State Tax (11%)</div>
        <div class="modal-item-value">~$42,326</div>
    </div>
    <div class="modal-item">
        <div class="modal-item-label">FICA (1.5%)</div>
        <div class="modal-item-value">~$5,772</div>
    </div>
    <div class="modal-divider"></div>
    <div class="modal-item">
        <div class="modal-item-label">Net After Taxes</div>
        <div class="modal-item-value">~$230,096</div>
    </div>
    <div class="modal-disclaimer">
        Tax withholding automatically deducted at vest. Consult tax advisor for specific situation.
    </div>
</div>
```

**Add CSS for divider:**
```css
.modal-divider {
    height: 1px;
    background: #2a2a2a;
    margin: 8px 0;
}
```

---

### TASK 7: Update executeVest() Alert (Reflect New Flow)

**Current:**
```javascript
function executeVest() {
    alert('Review Screen:\n\n✓ 70% (2,401 shares) → Hold in portfolio\n✓ 30% (1,029 shares) → Sell to checking\n✓ Est. proceeds: $115,433\n\n[Confirm] [Cancel]\n\nSafety: Review before final confirmation');
}
```

**Update to:**
```javascript
function executeVest() {
    alert('Confirm Authorization:\n\n✓ Fred will execute on Feb 6, 2026\n✓ Hold: 2,401 shares → Portfolio\n✓ Sell: 1,029 shares → Checking\n✓ Est. net proceeds: ~$115,433\n\nYou can modify or cancel until Feb 13.\n\nIf cancelled, all 3,430 shares will be held (100%).\n\n[Confirm Authorization] [Go Back]');
}
```

---

## Implementation Order

1. ✅ Fix scenario text (line ~487)
2. ✅ Update discussion notes (lines ~497-501)
3. ✅ Clean up split destination ("Your portfolio" → "Portfolio")
4. ✅ Add execution timeline card (CSS, HTML, JS)
5. ✅ Update button text + add authority notice
6. ✅ Add state tax to modal (if easy)
7. ✅ Update executeVest() alert

---

## Deferred to App Implementation

- Fred's availability messaging (post-approval screen)
- Message Center integration
- Landing screen status updates
- Execute button → status text transition

---

## Ready to Implement?

All tasks are modular and follow the progressive disclosure pattern established in the mockup. Each addition is collapsible or clearly separated to avoid bloat.

ACQ when ready to proceed.
