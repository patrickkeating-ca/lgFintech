# Sprint 4: Trade Recommendation Card - Notes

## ✅ Completed
- Side-by-side layout (Hold | Sell)
- Focus on concrete numbers (shares), not percentages
- Clean destinations (Portfolio | Checking account)
- Arrow indicators for clarity
- Light backgrounds (blue for hold, green for sell)

## 📝 Future Exploration: Component Hierarchy

**Desired final order (from HTML mockup):**
1. **Upcoming Vest** (no change)
2. **Trade Plan Recommendation** ⬅️ Move up
3. **[Approval Buttons]** (not yet built - Sprint 5)
4. **Execution Timeline** ⬇️ Move down
5. **About This Plan** ⬇️ Move down
6. **Your Schwab Advisor** (not yet built - Sprint 6)

**Current order (Sprint 1-4):**
1. Upcoming Vest ✓
2. About This Plan
3. Execution Timeline
4. Trade Recommendation

**Why change later:**
- Trade recommendation is actionable info (should be high)
- About This Plan is context/reference (can be lower)
- Execution Timeline is detailed schedule (reference material)
- Natural flow: See vest → See recommendation → Take action → Review details

**When to change:**
- After Sprint 5 (approval buttons) and Sprint 6 (advisor contact) are built
- Reorder all components to match final HTML hierarchy
- Test flow with real user scenarios

**Not changing now because:**
- Still building components
- Want to see all pieces before final assembly
- Easier to reorder once than to keep shuffling

---

## Design Philosophy Maintained

✅ Side-by-side is HIG-compliant
✅ Focus on numbers over percentages (minimalist)
✅ Clear visual hierarchy (bold titles, secondary shares, tertiary arrows)
✅ No redundant info (70/30 already shown in About This Plan)
✅ Clean, glanceable layout
