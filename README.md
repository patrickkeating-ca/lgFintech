# Equity Glass

iOS app showcasing Liquid Glass design patterns for equity compensation management.

## Project Goal

Demonstrate working code (not Figma mockups) for $1B entertainment client pitch. Mobile-first experience for busy professionals managing RSU vests.

## What's Built

### Core Features (Phase 1)
✅ **Privacy Blur** - Face ID reveal of dollar amounts
✅ **70/30 Split Visualization** - Interactive glass morph showing hold/sell breakdown
✅ **Advisor Conversation Context** - Compliance-safe recommendation display

### Tech Stack
- Swift + SwiftUI
- iOS 17.0+
- Observation framework
- LocalAuthentication (Face ID)

## Quick Start

1. **Read setup instructions**: `XCODE-SETUP.md`
2. **Create Xcode project**: Follow Step 1-6
3. **Build and run**: ⌘ + R
4. **Test in simulator**: Face ID simulation with ⌘ + Shift + M

## Demo Flow (90 seconds)

1. Launch app → Privacy blur visible
2. Tap dollar amount → Face ID → reveals value
3. Tap split card → Glass morphs to 70/30 breakdown
4. Tap "From Fred" → Modal shows conversation context
5. Show dark mode + dynamic type

## Documentation

- **PRD**: `docs/PRD.md` - Full product requirements with acceptance criteria
- **Liquid Glass Showcase**: `docs/LIQUID-GLASS-SHOWCASE.md` - 10 LG interaction moments
- **Liquid Glass Reference**: `docs/LIQUID-GLASS-REFERENCE.md` - General patterns
- **Xcode Setup**: `XCODE-SETUP.md` - Step-by-step build instructions

## Project Structure

```
LGFinapp/
├── EquityGlass/
│   └── EquityGlass/
│       ├── EquityGlassApp.swift
│       ├── Models/                    # Data models
│       ├── Views/                     # Main views
│       ├── Components/                # Reusable UI components
│       ├── Services/                  # Data loading
│       └── Resources/Data/            # Sample JSON
├── docs/                              # All documentation
├── XCODE-SETUP.md                     # Build instructions
└── README.md                          # This file
```

## Client Context

- **Target**: Entertainment conglomerate ($1B AUM)
- **Users**: VPs, directors, engineers (mobile-first workers)
- **Demo Date**: Mid-January 2025
- **Schwab Offering**: Equity comp management + advisor access
- **Key Differentiator**: Working code showcasing modern iOS patterns

## Compliance Notes

- Never says "We recommend" or "Schwab suggests"
- Always attributes to advisor: "Fred's recommendation"
- Shows full conversation context (date, discussion points)
- No algorithmic advice

## What's Next

Phase 2 features (see PRD.md):
- Tax Withholding Layers
- Multiple Vests Timeline
- Action Confirmation
- Loading States
- Countdown Progress Ring

## Sample Data

Entertainment company: **Steamboat Co.**
Vest date: **Feb 6, 2026** (47 days from Dec 21, 2025)
Shares: **2,500**
Value: **$127,450**
Advisor: **Fred**

---

**Built to win business by showing what's possible, not what's mediocre.**
