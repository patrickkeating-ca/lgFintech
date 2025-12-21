# Liquid Glass Design Reference

## Overview

Liquid Glass is a design pattern using iOS's built-in materials (`.ultraThinMaterial`, `.thinMaterial`, etc.) combined with blur effects, gradients, and animations to create depth and visual hierarchy.

---

## Core Principles

### 1. Material Hierarchy
```swift
// Background (most translucent)
.ultraThinMaterial

// Mid-layer (balanced)
.thinMaterial

// Foreground (least translucent)
.regularMaterial
```

### 2. Blur + Opacity Layering
```swift
.blur(radius: 20)
.opacity(0.7)
```

### 3. Border Highlights
```swift
.strokeBorder(
    LinearGradient(
        colors: [.white.opacity(0.3), .clear],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    ),
    lineWidth: 1
)
```

---

## Use Cases in VestToBTC

### 1. Privacy Mode Reveal

**Effect:** Frosted glass blur → smooth reveal on Face ID authentication

```swift
struct PrivacyBlur: ViewModifier {
    var isBlurred: Bool
    var intensity: CGFloat = 30

    func body(content: Content) -> some View {
        content
            .blur(radius: isBlurred ? intensity : 0)
            .overlay(
                Group {
                    if isBlurred {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.ultraThinMaterial)
                            .opacity(0.9)
                    }
                }
            )
            .animation(.easeInOut(duration: 0.3), value: isBlurred)
    }
}
```

**Usage:**
```swift
Text("$1,247,500")
    .privacyBlur(isPrivacyModeOn)
```

---

### 2. Card Backgrounds

**Effect:** Glass cards that let background show through

```swift
struct LiquidGlassCard: ViewModifier {
    var intensity: Double = 0.7
    var cornerRadius: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .opacity(intensity)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}
```

**Usage:**
```swift
VStack {
    // Card content
}
.liquidGlassCard()
```

---

### 3. BTC Price Chart with Glass Overlay

**Effect:** See chart lines through semi-transparent glass overlay showing price stats

```swift
struct BTCChartView: View {
    let priceHistory: [Double]
    @State private var showOverlay = false

    var body: some View {
        ZStack {
            // Background: Chart
            LineChart(data: priceHistory)
                .foregroundStyle(.orange)

            // Overlay: Glass info card
            if showOverlay {
                VStack(spacing: 4) {
                    Text("Current Price")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("$98,750")
                        .font(.title)
                        .bold()
                    Text("+2.34%")
                        .foregroundColor(.green)
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 10)
            }
        }
        .onTapGesture {
            withAnimation(.spring()) {
                showOverlay.toggle()
            }
        }
    }
}
```

---

### 4. Alert/Notification Overlays

**Effect:** Alert appears over content, content visible through glass

```swift
struct GlassAlert: View {
    let message: String
    let isError: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isError ? "exclamationmark.triangle" : "checkmark.circle")
                .font(.title2)
                .foregroundColor(isError ? .red : .green)

            Text(message)
                .font(.subheadline)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isError ? Color.red.opacity(0.3) : Color.green.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 10)
    }
}
```

---

### 5. Loading States

**Effect:** Pulsing glass shimmer while loading

```swift
struct GlassLoadingView: View {
    @State private var isAnimating = false

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.ultraThinMaterial)
            .overlay(
                LinearGradient(
                    colors: [
                        .clear,
                        .white.opacity(0.3),
                        .clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: isAnimating ? 300 : -300)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}
```

---

### 6. Scenario Cards (Gain/Loss Visualization)

**Effect:** Glass tint intensity = severity of gain/loss

```swift
struct ScenarioCard: View {
    let scenario: String
    let btcPrice: Double
    let gainLoss: Double

    var glassColor: Color {
        gainLoss > 0 ? .green : .red
    }

    var intensity: Double {
        min(abs(gainLoss) / 10000, 0.9) // Cap at 90% opacity
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("If BTC = \(btcPrice.asCurrency)")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(gainLoss.asCurrency)
                .font(.title)
                .bold()
                .foregroundColor(glassColor)

            Text(gainLoss > 0 ? "Gain" : "Loss")
                .font(.caption)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(glassColor.opacity(intensity * 0.3))
                )
        )
    }
}
```

---

## Advanced Techniques

### Depth Layering

Create sense of depth by stacking glass layers:

```swift
ZStack {
    // Back layer (most blurred)
    BackgroundContent()

    // Mid layer
    MidContent()
        .background(.ultraThinMaterial)
        .blur(radius: 5)

    // Front layer (sharpest)
    ForegroundContent()
        .background(.thinMaterial)
}
```

### Interactive Glass

Glass that responds to gestures:

```swift
.scaleEffect(isPressed ? 0.98 : 1.0)
.opacity(isPressed ? 0.9 : 1.0)
.animation(.spring(response: 0.3), value: isPressed)
```

### Contextual Blur

Blur based on content importance:

```swift
var blurAmount: CGFloat {
    switch priority {
    case .high: return 0
    case .medium: return 10
    case .low: return 20
    }
}
```

---

## Performance Tips

1. **Limit layers** - Too many `.ultraThinMaterial` views = slow scrolling
2. **Cache gradients** - Reuse gradient definitions
3. **Reduce blur on scroll** - Temporarily reduce blur radius during scroll
4. **Use `.drawingGroup()`** - For complex layered effects

```swift
.drawingGroup() // Renders to offscreen buffer (faster)
```

---

## Accessibility Considerations

1. **Reduce transparency** - Respect system setting
```swift
@Environment(\.accessibilityReduceTransparency) var reduceTransparency

var material: Material {
    reduceTransparency ? .regular : .ultraThin
}
```

2. **Contrast ratios** - Ensure text remains readable
3. **Motion** - Respect reduced motion preference
```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

var animation: Animation {
    reduceMotion ? .none : .spring()
}
```

---

## Example: Full Glass Card Implementation

```swift
struct VestEventCard: View {
    let event: VestEvent
    let isPrivacyOn: Bool
    @State private var isPressed = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text(event.vestDate.formattedVestDate)
                    .font(.headline)
                Spacer()
                Image(systemName: "bitcoinsign.circle.fill")
                    .foregroundColor(.orange)
            }

            // Details
            VStack(alignment: .leading, spacing: 4) {
                Text("\(event.sharesVesting) shares")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(event.estimatedValue.asCurrency)
                    .font(.title2)
                    .bold()
                    .privacyBlur(isPrivacyOn)
            }

            Divider()
                .background(.white.opacity(0.2))

            // BTC Equivalent
            HStack {
                Text("≈")
                    .foregroundStyle(.secondary)
                Text("\(event.estimatedBTC.asBTC) BTC")
                    .font(.subheadline)
                    .bold()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .opacity(0.8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    LinearGradient(
                        colors: [.white.opacity(0.3), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3), value: isPressed)
        .onTapGesture {
            // Navigate to detail
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}
```

---

## Charting Libraries Compatible with Liquid Glass

### Swift Charts (Built-in, iOS 16+)

```swift
import Charts

struct BTCPriceChart: View {
    let history: [PricePoint]

    var body: some View {
        Chart(history) { point in
            LineMark(
                x: .value("Date", point.date),
                y: .value("Price", point.price)
            )
            .foregroundStyle(.orange)
            .lineStyle(StrokeStyle(lineWidth: 2))
        }
        .chartYScale(domain: .automatic)
        .frame(height: 200)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
```

---

## Final Tips

1. **Start subtle** - Too much glass = busy/hard to read
2. **Test on device** - Simulator doesn't show true material rendering
3. **Dark mode matters** - Glass looks different in dark/light mode
4. **Animation timing** - 0.3s is sweet spot for glass transitions
5. **Layer intentionally** - Every glass layer should have a purpose

---

**Next Steps:**
1. Implement basic cards with `liquidGlassCard()` modifier
2. Add privacy blur to dollar values
3. Create BTC chart with glass overlay
4. Build interactive loading states
5. Test on physical device for true effect
