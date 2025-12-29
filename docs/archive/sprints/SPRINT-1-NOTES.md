# Sprint 1: Hero Feature - Notes & Future Changes

## ✅ Completed (Committed)
- `AboutThisPlanCard.swift` - Collapsible advisor conversation card
- `VestExecutionDemoView.swift` - Demo view for testing
- Uses existing `AdvisorConversationView.swift` modal

## 📝 Future Changes (Post-Commit Notes)

### Redundant Contact Info in Modal
**Issue:** `AdvisorConversationView` currently shows contact buttons (Call Fred, Message Fred) at the bottom of the modal. This is redundant because:
- HTML mockup doesn't have contact info in conversation modal
- Contact buttons belong in the separate "Your Advisor" card (bottom of main screen)
- Modal should focus purely on conversation context (what was discussed, Fred's recommendation)

**Future Fix (Sprint 6 - Advisor Contact Card):**
- Remove "Call Fred" and "Message Fred" buttons from `AdvisorConversationView`
- Keep only "Close" button
- All contact actions move to `AdvisorContactCard` component (collapsible card at bottom of screen)

**Why commit now despite redundancy:**
- Feature works and demonstrates the Disney differentiator (advisor attribution)
- Not breaking, just not ideal UX
- Clean separation of concerns comes in Sprint 6 refactor

---

## Design Philosophy Confirmation

✅ HTML = Hierarchy reference (what goes where, what's tappable)
✅ Apple HIG + Liquid Glass = Visual aesthetic
✅ Robinhood minimalism = UX flow (lean, fast, glanceable)
❌ No copying of HTML colors, fonts, or spacing

Sprint 1 follows this correctly - native iOS components, system fonts, Liquid Glass materials.

---

**Next Sprint:** Build VestDetailsSheet (tax breakdown modal)
