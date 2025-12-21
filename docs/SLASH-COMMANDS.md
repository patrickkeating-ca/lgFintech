# VestToBTC - Slash Command Agents

Three specialized AI agents to help you build a compliant, delightful, visually stunning app.

---

## Available Agents

### 1. `/content-strategist` - Intuit Methodology Expert

**Use when:** Writing copy, designing flows, creating onboarding

**Expertise:**
- Intuit's Design for Delight (D4D) methodology
- Customer-driven language
- Progressive disclosure
- Anxiety reduction
- Moment of delight creation

**Example Usage:**
```
/content-strategist

Review this empty state screen:

Title: "No Vests Added"
Body: "You haven't added any vest events yet."
CTA: "Add Vest"
```

**Expected Output:**
- Assessment through Intuit lens
- Rewrite suggestions (benefit-driven)
- Delight opportunities
- Simplified flow recommendations

---

### 2. `/compliance-check` - FinTech Compliance Specialist

**Use when:** Writing any financial content, CTAs, notifications, or feature descriptions

**Expertise:**
- Avoiding unlicensed financial advice
- Investment Advisers Act compliance
- Consumer protection best practices
- Safe harbor language
- Required disclaimers

**Example Usage:**
```
/compliance-check

Review this notification:

"Your RSUs vest today! Convert to BTC now while the price is low.
Bitcoin is trending up, so this is a great opportunity to maximize returns."
```

**Expected Output:**
- Risk level (🟢 Low / 🟡 Medium / 🔴 High)
- Problematic language flagged
- Regulatory concerns explained
- Compliant rewrites provided
- Disclaimer recommendations

---

### 3. `/liquid-glass-expert` - iOS Design Specialist

**Use when:** Building UI, adding animations, polishing interactions

**Expertise:**
- Apple's material design system
- Liquid Glass effects (blur, translucency, depth)
- Interactive animations
- Performance optimization
- Accessibility considerations

**Example Usage:**
```
/liquid-glass-expert

I'm building a BTC price card. It shows:
- Current price (large)
- 24h change (green/red)
- Last updated timestamp

How can I make it feel more premium with Liquid Glass?
```

**Expected Output:**
- Specific glass effects to add
- Code snippets (SwiftUI)
- Interactive enhancement ideas
- Performance notes
- Visual descriptions

---

## How to Use Slash Commands

### Basic Syntax
```
/command-name

[Your question or content to review]
```

### Pro Tips

1. **Be Specific**: Include exact copy, UI descriptions, or code
2. **Provide Context**: "This is for the home screen" vs "This is a notification"
3. **Ask for Examples**: "Show me 3 variations" or "Rewrite this"
4. **Combine Agents**: Run multiple reviews on the same feature

---

## Common Workflows

### Workflow 1: Writing a New Feature

1. **Design the UI** (your draft)
2. `/liquid-glass-expert` - Get design enhancements
3. **Write the copy** (based on design)
4. `/content-strategist` - Improve messaging
5. **Finalize content** (with rewrites)
6. `/compliance-check` - Ensure it's safe
7. **Ship it!**

### Workflow 2: Reviewing Existing Screen

```
/content-strategist
/compliance-check
/liquid-glass-expert

Review the HomeView.swift screen:
- BTC price card at top
- Next vest countdown (prominent)
- List of upcoming vests
- Privacy toggle (eye icon)
```

All three agents will review simultaneously and provide feedback from their perspectives.

### Workflow 3: Quick Copy Check

```
/compliance-check

Quick review:
CTA button text: "Buy Bitcoin Now"
```

Fast risk assessment before you commit code.

---

## Agent Personalities

### Content Strategist
- **Tone:** Encouraging, Intuit-methodology-focused
- **Output:** Rewrites, not just critique
- **Focus:** Customer empathy, simplicity, delight

### Compliance Specialist
- **Tone:** Cautious, protective, clear
- **Output:** Risk flags, safer alternatives
- **Focus:** Legal safety, consumer protection

### Liquid Glass Expert
- **Tone:** Enthusiastic, design-forward
- **Output:** Code snippets, visual descriptions
- **Focus:** Apple HIG, performance, accessibility

---

## Example Agent Interactions

### Example 1: Empty State Review

**You:**
```
/content-strategist

Empty state when user has no vests:
Title: "No Vests Found"
CTA: "Add Vest Event"
```

**Agent Response:**
```
Quick Take: Too transactional, no value proposition

What's Working:
- Clear CTA

Opportunities:
- "No vests found" is system language, not user language
- No motivation to add a vest
- Missing the "why this matters"

Rewrite Examples:

Title: "Track your first vest date"
Body: "Never miss an RSU vest again. We'll remind you when it's time."
CTA: "Add Vest Date"

Delight Idea:
When they add their first vest, show a mini-celebration:
"Great start! We'll remind you 77 days before your vest."
(with confetti animation)
```

---

### Example 2: Compliance Review

**You:**
```
/compliance-check

Notification text:
"Bitcoin is down 5% today - great time to buy! Your vest is ready to convert."
```

**Agent Response:**
```
Risk Assessment: 🔴 HIGH RISK

Issues Found:
1. "Great time to buy" - Investment timing advice
2. Implies we're recommending action based on price movement
3. Creates urgency/FOMO

Regulatory Concern:
Violates Investment Advisers Act - providing personalized investment advice
without registration. Suggesting "when to buy" = securities advice.

Compliant Rewrite:

"Your RSUs vest today. Tap to view conversion options."

Alternative (if you want to show price):
"Your RSUs vest today. Current BTC price: $93,250 (-5% today)"

Disclaimer Recommendation:
Add to notification settings screen:
"Price notifications are informational only, not investment advice."
```

---

### Example 3: Liquid Glass Enhancement

**You:**
```
/liquid-glass-expert

I have a countdown card showing days until next vest.
Currently it's just a white rectangle with text.
How can I make it pop?
```

**Agent Response:**
```
Quick Wins:

1. Add glass background:
```swift
.background(.ultraThinMaterial)
.overlay(
    RoundedRectangle(cornerRadius: 20)
        .strokeBorder(
            LinearGradient(
                colors: [.white.opacity(0.5), .clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            lineWidth: 1.5
        )
)
```

2. Interactive press state:
```swift
.scaleEffect(isPressed ? 0.98 : 1.0)
.animation(.spring(response: 0.3), value: isPressed)
```

Delight Moments:

3. Pulse effect as vest date approaches:
```swift
.scaleEffect(daysUntil < 7 ? 1.02 : 1.0)
.animation(
    daysUntil < 7 ? .easeInOut(duration: 2).repeatForever(autoreverses: true) : .default,
    value: daysUntil
)
```

Visual Description:
The card now has a frosted glass background that lets the home screen gradient
show through. A subtle white border highlights the top-left edge (light source).
When you tap, it compresses slightly with a spring animation. When < 7 days remain,
it gently breathes (1.02x scale) to build anticipation.

Performance Notes:
All effects are GPU-accelerated. Test on device to ensure 60fps during scroll.
```

---

## When to Use Each Agent

| Scenario | Agent | Why |
|----------|-------|-----|
| Writing button text | Content Strategist | Customer-focused copy |
| Reviewing CTA language | Compliance Check | Avoid "buy now" advice |
| Adding card animation | Liquid Glass Expert | Visual polish |
| Empty state design | Content Strategist | Motivation + clarity |
| Error message copy | Content Strategist | Anxiety reduction |
| Price alert notification | Compliance Check | No investment timing |
| Chart overlay design | Liquid Glass Expert | Glass + data viz |
| Onboarding flow | Content Strategist | Progressive disclosure |
| "What if" scenarios | Compliance Check | Hypothetical disclaimers |
| Privacy blur effect | Liquid Glass Expert | Face ID reveal animation |

---

## Testing Your Agents

Try these examples to see each agent in action:

### Test Content Strategist
```
/content-strategist

Settings screen title: "Application Settings"
Toggle label: "Enable Privacy Protection Mode"
```

### Test Compliance Check
```
/compliance-check

Feature description:
"VestToBTC automatically converts your RSUs to Bitcoin at the optimal price point."
```

### Test Liquid Glass Expert
```
/liquid-glass-expert

I want to add a loading spinner while fetching BTC prices.
Currently it's just a default ProgressView().
```

---

## Agent Limitations

### What Agents CAN Do
✅ Review copy, UI, code snippets
✅ Provide specific rewrites
✅ Suggest alternatives
✅ Explain reasoning (why it's better)
✅ Give code examples

### What Agents CANNOT Do
❌ Directly edit your code files
❌ Run your app or test features
❌ Access external legal databases
❌ Guarantee regulatory compliance (consult real lawyer!)
❌ Design entire screens from scratch (they enhance your work)

---

## Best Practices

1. **Review Early**: Catch issues before you write code
2. **Iterate**: Run the same content through multiple times
3. **Combine Perspectives**: Use all 3 agents on critical features
4. **Save Good Examples**: Build your own library of approved copy
5. **Trust but Verify**: Agents are smart, but you're the decision-maker

---

## Quick Reference

```bash
# Intuit methodology + customer-driven copy
/content-strategist

# FinTech compliance + legal safety
/compliance-check

# Liquid Glass effects + iOS design
/liquid-glass-expert
```

---

## Next Steps

1. Try each agent with the test examples above
2. Review your current HomeView.swift with all 3 agents
3. Use `/compliance-check` on ALL user-facing copy before shipping
4. Keep this reference open while building features

---

**Pro Tip:** You can invoke multiple agents in one message by using multiple slash commands:

```
/content-strategist
/compliance-check

Review this vest day notification:
"Your shares vest today! Time to convert to BTC and secure your future."
```

Both agents will review and provide their specialized feedback.
