# Sprint 6: Your Schwab Advisor - Notes

## ✅ Completed
- AdvisorContactCard component (collapsible)
- Always visible: Advisor name with credentials
- Expandable: Title, company, contact buttons
  - Contact [Name] (email, blue icon)
  - Call [phone] (phone, green icon - premium tier only)
  - Book a Meeting (calendar, orange icon)

## 📝 Future Enhancement: Advisor Photo

**Current state:**
- Text-only display of advisor name and credentials

**Desired enhancement:**
- Add advisor photo to the card
- Photo should be in final placement with advisor name

**Implementation considerations:**
- Photo placement: Next to name or above contact buttons when expanded?
- Photo size: Circular avatar (medium size, ~60-80pt)
- Default/fallback: Initials in colored circle if no photo available
- Asset management: Where to store advisor photos (local assets vs remote URL)
- Data model: Add `advisorPhotoURL: String?` to AdvisorRecommendation model
- Liquid Glass treatment: Subtle border/shadow to match card aesthetic

**When to implement:**
- During polish phase after all core components complete
- When real advisor photo assets are available
- Part of overall visual refinement pass
