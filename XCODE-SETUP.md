# Xcode Setup Instructions

## Step 1: Create Xcode Project

1. Open Xcode
2. File → New → Project
3. Select **iOS** → **App**
4. Click **Next**

5. Configure project:
   - **Product Name**: `EquityGlass`
   - **Team**: (Select your team or leave as "None")
   - **Organization Identifier**: `com.yourname` (or your domain)
   - **Interface**: **SwiftUI**
   - **Language**: **Swift**
   - **Storage**: (leave unchecked)
   - **Include Tests**: (unchecked for now)
   - Click **Next**

6. Save location:
   - Navigate to: `/Users/patrickkeating/Projects/LGFinapp/`
   - **IMPORTANT**: Uncheck "Create Git repository" (we already have one)
   - Click **Create**

## Step 2: Delete Default Files

Xcode creates some default files we don't need:

1. In the Project Navigator (left sidebar), find these files:
   - `ContentView.swift` (in root, not in Views folder)
   - `EquityGlassApp.swift` (in root, not our custom one)
   - Any `Assets.xcassets` if you want to use default

2. **Right-click** each → **Delete** → Select **Move to Trash**

## Step 3: Add Our Swift Files

1. In Project Navigator, right-click on **EquityGlass** (blue project icon) → **Add Files to "EquityGlass"...**

2. Navigate to: `/Users/patrickkeating/Projects/LGFinapp/EquityGlass/EquityGlass/`

3. Select the entire **EquityGlass** folder

4. Make sure these options are checked:
   - ✅ **Copy items if needed**
   - ✅ **Create groups**
   - ✅ **Add to targets: EquityGlass**

5. Click **Add**

## Step 4: Verify File Structure

Your Project Navigator should now show:

```
EquityGlass/
├── EquityGlassApp.swift
├── Views/
│   └── ContentView.swift
├── Components/
│   ├── VestCard.swift
│   ├── SplitVisualization.swift
│   └── AdvisorConversationView.swift
├── Models/
│   ├── VestEvent.swift
│   ├── AdvisorRecommendation.swift
│   └── TaxEstimate.swift
├── Services/
│   └── DataStore.swift
└── Resources/
    └── Data/
        └── vest-event.json
```

## Step 5: Configure Build Settings

1. Click on the **EquityGlass project** (blue icon at top of navigator)
2. Select **EquityGlass** target (under TARGETS)
3. Click **General** tab
4. Set **Minimum Deployments** → **iOS 17.0**
5. Under **Frameworks, Libraries, and Embedded Content**, verify it's empty (we're using system frameworks only)

## Step 6: Add Privacy Description (for Face ID)

1. In Project Navigator, find **Info.plist**
   - If you don't see it, click the **EquityGlass project** → **Info** tab

2. Hover over any row and click the **+** button

3. Add this key:
   - **Key**: `Privacy - Face ID Usage Description`
   - **Type**: String
   - **Value**: `We use Face ID to reveal sensitive financial information`

4. If using the Info tab instead of Info.plist file:
   - Click **+** under "Custom iOS Target Properties"
   - Type: `NSFaceIDUsageDescription`
   - Value: `We use Face ID to reveal sensitive financial information`

## Step 7: Build and Run

1. Select a simulator:
   - Top toolbar → Click device menu → **iPhone 15 Pro** (or any iOS 17+ device)

2. Build the project:
   - Press **⌘ + B** (Command + B)
   - Wait for build to complete
   - Check for errors in the Issue Navigator (⌘ + 5)

3. Fix common errors:
   - If "Cannot find 'Bundle' in scope": Make sure all files are added to target
   - If JSON not found: Right-click `vest-event.json` → **Show File Inspector** (⌘ + Option + 1) → Check **Target Membership → EquityGlass**

4. Run the app:
   - Press **⌘ + R** (Command + R)
   - Simulator should launch and show the app

## Step 8: Test Face ID in Simulator

1. With app running, tap the dollar amount on the vest card
2. Face ID prompt will appear
3. To approve Face ID:
   - **Menu**: Features → Face ID → **Matching Face**
   - **Keyboard**: Press **⌘ + ⇧ + M** (Command + Shift + M)
4. Amount should reveal
5. Wait 10 seconds → amount should blur again

## Step 9: Test Features

**Privacy Blur**:
- ✅ Dollar amount blurred on launch
- ✅ Tap triggers Face ID
- ✅ Successful auth reveals amount
- ✅ Auto-hides after 10 seconds

**Split Visualization**:
- ✅ Tap card to expand
- ✅ Shows 70% / 30% split
- ✅ Math correct (1,750 + 750 = 2,500)
- ✅ Green/orange glass tint visible

**Advisor Conversation**:
- ✅ Tap "From your call with Fred" opens modal
- ✅ Discussion points visible
- ✅ "Fred's recommendation" (not "We recommend")
- ✅ Modal dismisses on "Close"

## Troubleshooting

### Build Fails: "Cannot find type 'VestEvent'"
**Fix**: Make sure all Model files are in the target
- Right-click each .swift file → **Show File Inspector**
- Check **Target Membership → EquityGlass**

### JSON Not Loading: "vest-event.json not found"
**Fix**: Add JSON to target
- Right-click `vest-event.json` → **Show File Inspector**
- Check **Target Membership → EquityGlass**

### Face ID Doesn't Work
**Fix**: Check Info.plist
- Verify `NSFaceIDUsageDescription` key exists
- Rebuild project

### Simulator Crash on Launch
**Fix**: Check iOS version
- Simulator must be iOS 17.0 or later
- Top menu → File → Open Simulator → iOS 17.2 → iPhone 15 Pro

### Preview Doesn't Work
**Fix**: Previews require macOS 14+ and Xcode 15+
- If on older Mac, use simulator instead (⌘ + R)

## Next Steps

Once app is running:

1. **Test dark mode**: Settings app in simulator → Developer → Dark Appearance
2. **Test dynamic type**: Settings → Accessibility → Display & Text Size → Larger Text
3. **Take screenshots** for demo
4. **Note any bugs** to fix

## Ready to Code More Features?

Check `docs/PRD.md` for next features to implement:
- Tax Withholding Layers
- Multiple Vests Timeline
- Action Confirmation

---

**Setup complete!** You now have a working Liquid Glass demo app.
