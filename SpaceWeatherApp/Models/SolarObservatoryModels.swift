import SwiftUI

// MARK: - Solar Measurement

/// Unified type for any viewable solar image. Carries everything needed to build a Helioviewer URL.
struct SolarMeasurement: Identifiable, Hashable, Sendable {
    let id: String
    let displayName: String
    let fullName: String
    let description: String
    let layerString: String
    let sourceId: Int
    let imageScale: Double
    let color: Color
    let icon: String
}

// MARK: - Solar Observatory

/// Top-level observatory selection
enum SolarObservatory: String, CaseIterable, Identifiable, Sendable {
    case sdo = "SDO"
    case soho = "SOHO"
    case stereoA = "STEREO A"
    case goes = "GOES"

    var id: String { rawValue }

    var displayName: String { rawValue }

    var icon: String {
        switch self {
        case .sdo: return "sun.max.fill"
        case .soho: return "camera.filters"
        case .stereoA: return "arrow.triangle.branch"
        case .goes: return "globe.americas.fill"
        }
    }

    var accentColor: Color {
        switch self {
        case .sdo: return .orange
        case .soho: return .blue
        case .stereoA: return .teal
        case .goes: return .indigo
        }
    }

    var description: String {
        switch self {
        case .sdo: return "Solar Dynamics Observatory — Full-disk solar images in multiple EUV wavelengths and magnetic field."
        case .soho: return "Solar and Heliospheric Observatory — EUV imaging and coronagraphs for CME detection."
        case .stereoA: return "STEREO Ahead — Off-Sun-Earth-line perspective in EUV and coronagraph."
        case .goes: return "Geostationary Operational Environmental Satellite — Real-time solar UV and coronagraph imagery."
        }
    }

    var measurements: [SolarMeasurement] {
        SolarMeasurementCatalog.measurements(for: self)
    }

    var defaultMeasurement: SolarMeasurement {
        measurements[0]
    }

    /// Suggested animation time range in hours, based on typical data cadence
    var suggestedAnimationHours: Int {
        switch self {
        case .sdo: return 24       // ~12s cadence, 24h is plenty
        case .soho: return 168     // EIT ~6-12h cadence, LASCO ~20min; 7 days works for both
        case .stereoA: return 168  // EUVI sparse (~hours), COR moderate; 7 days
        case .goes: return 24      // SUVI ~4min cadence, 24h is good
        }
    }
}

// MARK: - Solar Measurement Catalog

/// Static catalog of all measurements per observatory
enum SolarMeasurementCatalog {

    static func measurements(for observatory: SolarObservatory) -> [SolarMeasurement] {
        switch observatory {
        case .sdo: return sdo
        case .soho: return soho
        case .stereoA: return stereoA
        case .goes: return goes
        }
    }

    // MARK: SDO (10)

    static let sdo: [SolarMeasurement] = [
        SolarMeasurement(
            id: "sdo-aia-94",
            displayName: "94 \u{212B}",
            fullName: "AIA 94 \u{212B} (Fe XVIII)",
            description: "Flaring regions — 6.3 million K",
            layerString: "SDO,AIA,AIA,94,1,100",
            sourceId: 8,
            imageScale: 2.4204409,
            color: .green,
            icon: "sun.max.fill"
        ),
        SolarMeasurement(
            id: "sdo-aia-131",
            displayName: "131 \u{212B}",
            fullName: "AIA 131 \u{212B} (Fe VIII, XXI)",
            description: "Flaring regions — 400K to 16 million K",
            layerString: "SDO,AIA,AIA,131,1,100",
            sourceId: 9,
            imageScale: 2.4204409,
            color: .teal,
            icon: "sun.max.fill"
        ),
        SolarMeasurement(
            id: "sdo-aia-171",
            displayName: "171 \u{212B}",
            fullName: "AIA 171 \u{212B} (Fe IX)",
            description: "Quiet corona, upper transition region — 630,000 K",
            layerString: "SDO,AIA,AIA,171,1,100",
            sourceId: 10,
            imageScale: 2.4204409,
            color: .gold,
            icon: "sun.max.fill"
        ),
        SolarMeasurement(
            id: "sdo-aia-193",
            displayName: "193 \u{212B}",
            fullName: "AIA 193 \u{212B} (Fe XII, XXIV)",
            description: "Corona and hot flare plasma — 1.2 to 20 million K",
            layerString: "SDO,AIA,AIA,193,1,100",
            sourceId: 11,
            imageScale: 2.4204409,
            color: .orange,
            icon: "sun.max.fill"
        ),
        SolarMeasurement(
            id: "sdo-aia-211",
            displayName: "211 \u{212B}",
            fullName: "AIA 211 \u{212B} (Fe XIV)",
            description: "Active region corona — 2 million K",
            layerString: "SDO,AIA,AIA,211,1,100",
            sourceId: 12,
            imageScale: 2.4204409,
            color: .purple,
            icon: "sun.max.fill"
        ),
        SolarMeasurement(
            id: "sdo-aia-304",
            displayName: "304 \u{212B}",
            fullName: "AIA 304 \u{212B} (He II)",
            description: "Chromosphere and transition region — 50,000 K",
            layerString: "SDO,AIA,AIA,304,1,100",
            sourceId: 13,
            imageScale: 2.4204409,
            color: .red,
            icon: "sun.max.fill"
        ),
        SolarMeasurement(
            id: "sdo-aia-335",
            displayName: "335 \u{212B}",
            fullName: "AIA 335 \u{212B} (Fe XVI)",
            description: "Active region corona — 2.5 million K",
            layerString: "SDO,AIA,AIA,335,1,100",
            sourceId: 14,
            imageScale: 2.4204409,
            color: .blue,
            icon: "sun.max.fill"
        ),
        SolarMeasurement(
            id: "sdo-aia-1600",
            displayName: "1600 \u{212B}",
            fullName: "AIA 1600 \u{212B} (C IV)",
            description: "Transition region and upper photosphere — 100,000 K",
            layerString: "SDO,AIA,AIA,1600,1,100",
            sourceId: 15,
            imageScale: 2.4204409,
            color: .yellow,
            icon: "sun.max.fill"
        ),
        SolarMeasurement(
            id: "sdo-aia-1700",
            displayName: "1700 \u{212B}",
            fullName: "AIA 1700 \u{212B} (Continuum)",
            description: "Temperature minimum, photosphere — 5,000 K",
            layerString: "SDO,AIA,AIA,1700,1,100",
            sourceId: 16,
            imageScale: 2.4204409,
            color: .pink,
            icon: "sun.max.fill"
        ),
        SolarMeasurement(
            id: "sdo-hmi-mag",
            displayName: "Magnetogram",
            fullName: "HMI Magnetogram",
            description: "Photospheric magnetic field strength and polarity",
            layerString: "SDO,HMI,HMI,magnetogram,1,100",
            sourceId: 19,
            imageScale: 2.4204409,
            color: .gray,
            icon: "pencil.and.outline"
        ),
    ]

    // MARK: SOHO (6)

    static let soho: [SolarMeasurement] = [
        SolarMeasurement(
            id: "soho-eit-171",
            displayName: "171 \u{212B}",
            fullName: "EIT 171 \u{212B} (Fe IX/X)",
            description: "Quiet corona and coronal loops — 1 million K",
            layerString: "SOHO,EIT,EIT,171,1,100",
            sourceId: 0,
            imageScale: 2.63,
            color: .blue,
            icon: "camera.filters"
        ),
        SolarMeasurement(
            id: "soho-eit-195",
            displayName: "195 \u{212B}",
            fullName: "EIT 195 \u{212B} (Fe XII)",
            description: "Quiet corona and flare plasma — 1.5 million K",
            layerString: "SOHO,EIT,EIT,195,1,100",
            sourceId: 1,
            imageScale: 2.63,
            color: .green,
            icon: "camera.filters"
        ),
        SolarMeasurement(
            id: "soho-eit-284",
            displayName: "284 \u{212B}",
            fullName: "EIT 284 \u{212B} (Fe XV)",
            description: "Active region corona — 2 million K",
            layerString: "SOHO,EIT,EIT,284,1,100",
            sourceId: 2,
            imageScale: 2.63,
            color: .yellow,
            icon: "camera.filters"
        ),
        SolarMeasurement(
            id: "soho-eit-304",
            displayName: "304 \u{212B}",
            fullName: "EIT 304 \u{212B} (He II)",
            description: "Chromosphere and transition region — 80,000 K",
            layerString: "SOHO,EIT,EIT,304,1,100",
            sourceId: 3,
            imageScale: 2.63,
            color: .red,
            icon: "camera.filters"
        ),
        SolarMeasurement(
            id: "soho-lasco-c2",
            displayName: "LASCO C2",
            fullName: "LASCO C2 Coronagraph",
            description: "Inner corona (2–6 solar radii) — Great for CMEs",
            layerString: "SOHO,LASCO,C2,white-light,1,100",
            sourceId: 4,
            imageScale: 11.9,
            color: .red,
            icon: "camera.filters"
        ),
        SolarMeasurement(
            id: "soho-lasco-c3",
            displayName: "LASCO C3",
            fullName: "LASCO C3 Coronagraph",
            description: "Outer corona (3.7–30 solar radii) — Wide field CMEs",
            layerString: "SOHO,LASCO,C3,white-light,1,100",
            sourceId: 5,
            imageScale: 56.0,
            color: .blue,
            icon: "camera.filters"
        ),
    ]

    // MARK: STEREO A (6)

    static let stereoA: [SolarMeasurement] = [
        SolarMeasurement(
            id: "stereo-a-euvi-171",
            displayName: "171 \u{212B}",
            fullName: "EUVI 171 \u{212B} (Fe IX)",
            description: "Quiet corona from STEREO Ahead perspective — 1 million K",
            layerString: "STEREO_A,SECCHI,EUVI,171,1,100",
            sourceId: 20,
            imageScale: 2.4,
            color: .blue,
            icon: "arrow.triangle.branch"
        ),
        SolarMeasurement(
            id: "stereo-a-euvi-195",
            displayName: "195 \u{212B}",
            fullName: "EUVI 195 \u{212B} (Fe XII)",
            description: "Corona and flare plasma from STEREO Ahead — 1.5 million K",
            layerString: "STEREO_A,SECCHI,EUVI,195,1,100",
            sourceId: 21,
            imageScale: 2.4,
            color: .green,
            icon: "arrow.triangle.branch"
        ),
        SolarMeasurement(
            id: "stereo-a-euvi-284",
            displayName: "284 \u{212B}",
            fullName: "EUVI 284 \u{212B} (Fe XV)",
            description: "Active region corona from STEREO Ahead — 2 million K",
            layerString: "STEREO_A,SECCHI,EUVI,284,1,100",
            sourceId: 22,
            imageScale: 2.4,
            color: .yellow,
            icon: "arrow.triangle.branch"
        ),
        SolarMeasurement(
            id: "stereo-a-euvi-304",
            displayName: "304 \u{212B}",
            fullName: "EUVI 304 \u{212B} (He II)",
            description: "Chromosphere from STEREO Ahead — 80,000 K",
            layerString: "STEREO_A,SECCHI,EUVI,304,1,100",
            sourceId: 23,
            imageScale: 2.4,
            color: .red,
            icon: "arrow.triangle.branch"
        ),
        SolarMeasurement(
            id: "stereo-a-cor1",
            displayName: "COR1",
            fullName: "SECCHI COR1 Coronagraph",
            description: "Inner coronagraph from STEREO Ahead (1.4–4 solar radii)",
            layerString: "STEREO_A,SECCHI,COR1,white-light,1,100",
            sourceId: 28,
            imageScale: 12.0,
            color: .solarCyan,
            icon: "arrow.triangle.branch"
        ),
        SolarMeasurement(
            id: "stereo-a-cor2",
            displayName: "COR2",
            fullName: "SECCHI COR2 Coronagraph",
            description: "Outer coronagraph from STEREO Ahead (2.5–15 solar radii)",
            layerString: "STEREO_A,SECCHI,COR2,white-light,1,100",
            sourceId: 29,
            imageScale: 30.0,
            color: .red,
            icon: "arrow.triangle.branch"
        ),
    ]

    // MARK: GOES (6)

    static let goes: [SolarMeasurement] = [
        SolarMeasurement(
            id: "goes-suvi-94",
            displayName: "94 \u{212B}",
            fullName: "SUVI 94 \u{212B} (Fe XVIII)",
            description: "Flaring regions from GOES — 6.3 million K",
            layerString: "GOES,SUVI,94,94,1,100",
            sourceId: 2000,
            imageScale: 2.4,
            color: .green,
            icon: "globe.americas.fill"
        ),
        SolarMeasurement(
            id: "goes-suvi-131",
            displayName: "131 \u{212B}",
            fullName: "SUVI 131 \u{212B} (Fe VIII, XXI)",
            description: "Flaring regions from GOES — 400K to 16 million K",
            layerString: "GOES,SUVI,131,131,1,100",
            sourceId: 2001,
            imageScale: 2.4,
            color: .teal,
            icon: "globe.americas.fill"
        ),
        SolarMeasurement(
            id: "goes-suvi-171",
            displayName: "171 \u{212B}",
            fullName: "SUVI 171 \u{212B} (Fe IX)",
            description: "Quiet corona from GOES — 630,000 K",
            layerString: "GOES,SUVI,171,171,1,100",
            sourceId: 2002,
            imageScale: 2.4,
            color: .gold,
            icon: "globe.americas.fill"
        ),
        SolarMeasurement(
            id: "goes-suvi-195",
            displayName: "195 \u{212B}",
            fullName: "SUVI 195 \u{212B} (Fe XII)",
            description: "Corona and hot flare plasma from GOES — 1.5 million K",
            layerString: "GOES,SUVI,195,195,1,100",
            sourceId: 2003,
            imageScale: 2.4,
            color: .orange,
            icon: "globe.americas.fill"
        ),
        SolarMeasurement(
            id: "goes-suvi-284",
            displayName: "284 \u{212B}",
            fullName: "SUVI 284 \u{212B} (Fe XV)",
            description: "Active region corona from GOES — 2 million K",
            layerString: "GOES,SUVI,284,284,1,100",
            sourceId: 2004,
            imageScale: 2.4,
            color: .blue,
            icon: "globe.americas.fill"
        ),
        SolarMeasurement(
            id: "goes-suvi-304",
            displayName: "304 \u{212B}",
            fullName: "SUVI 304 \u{212B} (He II)",
            description: "Chromosphere from GOES — 50,000 K",
            layerString: "GOES,SUVI,304,304,1,100",
            sourceId: 2005,
            imageScale: 2.4,
            color: .red,
            icon: "globe.americas.fill"
        ),
    ]
}
