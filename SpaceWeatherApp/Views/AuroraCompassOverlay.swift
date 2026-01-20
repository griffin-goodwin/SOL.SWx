import SwiftUI
import CoreLocation

/// Result of look-direction geometry computation plus the point metadata
struct GeoLookResultWithPoint {
    let point: AuroraPoint
    let geometry: GeoLookResult
}

struct AuroraCompassOverlay: View {
    @StateObject private var loc = LocationHeadingManager()
    private let auroraService = AuroraService()
    var auroraPoints: [AuroraPoint]
    var selectedHemisphere: Hemisphere
    var auroraAltitudeMeters: Double = 110_000.0
    var onClose: () -> Void

    // Current continuous rotation for smooth UI (avoids 0/360 spin)
    @State private var continuousRotation: Double = 0
    @State private var lastRawHeading: Double? = nil
    @State private var geocodedBestPoint: AuroraPoint? = nil

    var body: some View {
        Group {
            if let observer = loc.location {
                if let bestResult = bestLook(for: observer) {
                    let best = bestResult.geometry
                    let point = geocodedBestPoint ?? bestResult.point
                    
                    VStack(spacing: 12) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(point.locationName?.uppercased() ?? "AURORA TARGET")
                                    .font(Theme.mono(14, weight: .bold))
                                    .foregroundStyle(Theme.auroraGreen)
                                
                                Text(String(format: "%.1f°%@, %.1f°%@", 
                                            abs(point.latitude), point.latitude >= 0 ? "N" : "S",
                                            abs(point.longitude), point.longitude >= 0 ? "E" : "W"))
                                    .font(Theme.mono(10))
                                    .foregroundStyle(Theme.secondaryText)
                            }
                            
                            Spacer()
                            
                            Button(action: onClose) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Color.white.opacity(0.4))
                                    .font(.system(size: 22))
                            }
                        }
                        .padding(.bottom, 4)

                        // Compass circle with arrow
                        ZStack {
                            Circle()
                                .fill(Color.black.opacity(0.4))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Circle()
                                        .stroke(Theme.auroraGreen.opacity(0.2), lineWidth: 1)
                                )
                            
                            // Tick marks
                            ForEach(0..<8) { i in
                                Rectangle()
                                    .fill(Color.white.opacity(0.15))
                                    .frame(width: 1, height: 6)
                                    .offset(y: -44)
                                    .rotationEffect(.degrees(Double(i) * 45))
                            }

                            Image(systemName: "location.north.line.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(auroraColor(for: point.probability))
                                .rotationEffect(.degrees(continuousRotation))
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: continuousRotation)
                                .onChange(of: loc.heading?.trueHeading ?? loc.heading?.magneticHeading ?? 0) { newHeading in
                                    updateRotation(newHeading: newHeading, targetAzimuth: best.azimuthDegrees)
                                }
                        }
                        .padding(.vertical, 4)

                        VStack(spacing: 8) {
                            HStack {
                                Label {
                                    Text(String(format: "%.0f°", best.azimuthDegrees))
                                        .font(Theme.mono(13, weight: .medium))
                                } icon: {
                                    Image(systemName: "safari")
                                        .font(.caption)
                                }
                                .foregroundStyle(Theme.primaryText)
                                
                                Spacer()
                                
                                Label {
                                    Text(String(format: "%.1f° Elev", best.elevationDegrees))
                                        .font(Theme.mono(13, weight: .medium))
                                } icon: {
                                    Image(systemName: "scope")
                                        .font(.caption)
                                }
                                .foregroundStyle(Theme.primaryText)
                            }

                            HStack {
                                Text(String(format: "%.0f km away", best.surfaceDistanceMeters / 1000.0))
                                    .font(Theme.mono(11))
                                    .foregroundStyle(Theme.secondaryText)
                                
                                Spacer()
                                
                                Text("\(Int(point.probability))% PROBABILITY")
                                    .font(Theme.mono(11, weight: .bold))
                                    .foregroundStyle(auroraColor(for: point.probability))
                            }
                        }
                    }
                    .padding(16)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .frame(width: 260)
                    .onAppear {
                        updateGeocoding(for: bestResult.point)
                    }
                    .onChange(of: bestResult.point.id) { _ in
                        updateGeocoding(for: bestResult.point)
                    }
                } else {
                    Text("No aurora data")
                        .font(.caption)
                        .foregroundStyle(Color.white.opacity(0.9))
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            } else {
                Button(action: { loc.requestAuthorization() }) {
                    Text("Enable Location")
                        .font(.caption)
                        .foregroundStyle(Color.white)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }

    private func updateRotation(newHeading: Double, targetAzimuth: Double) {
        // Relative angle: target - observer
        let targetRotation = targetAzimuth - newHeading

        if lastRawHeading == nil {
            // First time: normalize targetRotation to [0, 360) for a clean start
            continuousRotation = (targetRotation.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)
        } else {
            // Find shortest delta to avoid 0/360 spin
            // We want (continuousRotation + delta) % 360 to equal targetRotation % 360
            let currentMod = continuousRotation.truncatingRemainder(dividingBy: 360)
            let targetMod = targetRotation.truncatingRemainder(dividingBy: 360)

            var delta = targetMod - currentMod

            // Normalize delta to [-180, 180]
            if delta > 180 {
                delta -= 360
            } else if delta < -180 {
                delta += 360
            }

            continuousRotation += delta
        }
        lastRawHeading = newHeading
    }

    private func updateGeocoding(for point: AuroraPoint) {
        // If we already have the geocoded version of THIS point (same ID), don't clear it.
        if geocodedBestPoint?.id == point.id && geocodedBestPoint?.locationName != nil {
            return
        }
        
        // If it's a truly different point, we can clear it to avoid showing wrong name
        // but only if the coordinates are significantly different.
        if let current = geocodedBestPoint {
            let dist = abs(current.latitude - point.latitude) + abs(current.longitude - point.longitude)
            if dist > 0.1 {
                geocodedBestPoint = nil
            }
        }
        
        Task {
            let updated = await auroraService.geocodePoints([point])
            if let first = updated.first {
                await MainActor.run {
                    // Only update if it's still the point we're interested in
                    self.geocodedBestPoint = first
                }
            }
        }
    }

    private func bestLook(for observer: CLLocation) -> GeoLookResultWithPoint? {
        let obsLat = observer.coordinate.latitude
        let obsLon = observer.coordinate.longitude
        let obsAlt = observer.altitude

        // Filter points by hemisphere
        let points = auroraPoints.filter { selectedHemisphere == .north ? $0.latitude >= 0 : $0.latitude < 0 }
        guard !points.isEmpty else { return nil }

        var best: (point: AuroraPoint, score: Double, result: GeoLookResult)? = nil

        for p in points {
            let geo = computeLookGeometry(observerLat: obsLat, observerLon: obsLon, observerAltMeters: obsAlt, targetLat: p.latitude, targetLon: p.longitude, auroraAltitudeMeters: auroraAltitudeMeters)
            // Score: probability * elevation factor (prefer positive elevation)
            let elevFactor = max(0.0, geo.elevationDegrees + 5.0) // bias slightly upward
            let score = p.probability * elevFactor
            if best == nil || score > best!.score {
                best = (p, score, geo)
            }
        }

        if let best = best {
            return GeoLookResultWithPoint(point: best.point, geometry: best.result)
        }
        return nil
    }

}

struct AuroraCompassOverlay_Previews: PreviewProvider {
    static var previews: some View {
        AuroraCompassOverlay(auroraPoints: [AuroraPoint(longitude: -149, latitude: 64.5, probability: 80)], selectedHemisphere: .north, onClose: {})
            .preferredColorScheme(.dark)
            .padding()
            .background(Color.black)
    }
}
