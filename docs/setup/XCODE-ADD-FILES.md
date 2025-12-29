# Add New Files to Xcode Project

## New Files to Add

You need to add these new files to your Xcode project:

### 1. Models Folder
- `Scenario.swift`

### 2. Components Folder
- `ScenarioPicker.swift`

### 3. Resources/Data Folder
- `scenario-marcus.json`
- `scenario-alex.json`

### 4. Already Updated (just needs rebuild)
- `DataStore.swift` (updated)
- `ContentView.swift` (updated)

## How to Add

**Option A: Add Files Individually**

1. In Xcode Project Navigator, right-click **Models** folder
2. Select **Add Files to "EquityGlassXcode"...**
3. Navigate to: `/Users/patrickkeating/Projects/LGFinapp/EquityGlassXcode/EquityGlassXcode/EquityGlass/Models/`
4. Select `Scenario.swift`
5. Make sure "Add to targets: EquityGlassXcode" is checked
6. Click **Add**

7. Repeat for **Components** folder → `ScenarioPicker.swift`

8. Repeat for **Resources/Data** folder → `scenario-marcus.json` and `scenario-alex.json`

**Option B: Add All at Once**

1. Right-click **EquityGlass** (the folder, not project)
2. Select **Add Files to "EquityGlassXcode"...**
3. Hold Command and select:
   - `Models/Scenario.swift`
   - `Components/ScenarioPicker.swift`
   - `Resources/Data/scenario-marcus.json`
   - `Resources/Data/scenario-alex.json`
4. Check "Add to targets: EquityGlassXcode"
5. Click **Add**

## Verify Target Membership

For each new file, select it and check **File Inspector** (⌘ + Option + 1):
- ✅ Target Membership → EquityGlassXcode (should be checked)

## Build and Test

1. Press **⌘ + B** to build
2. If build succeeds, press **⌘ + R** to run
3. You should see a dropdown at the top with "Alex Chen"
4. Tap it to switch to "Marcus Rodriguez"

## What Changed

**Scenario Picker:**
- Dropdown menu below "Equity Vest" title
- Shows current scenario name and subtitle
- Tap to switch between Alex and Marcus

**Data Differences:**
- **Alex Chen**: $175k vest, VP level, CA tax (state+federal), wealth management tone
- **Marcus Rodriguez**: $30.6k vest, IT manager, TX tax (no state), educational tone

**Everything else stays the same** - same UI, same Liquid Glass, just different content.
