import XCTest
@testable import UDDF

final class UnitTests: XCTestCase {
    // MARK: - Depth Tests

    func testDepthConversion() {
        let depth = Depth(meters: 10)
        XCTAssertEqual(depth.meters, 10.0)
        XCTAssertEqual(depth.feet, 32.8084, accuracy: 0.001)
    }

    func testDepthFromFeet() {
        let depth = Depth(feet: 33)
        XCTAssertEqual(depth.feet, 33.0, accuracy: 0.001)
        XCTAssertEqual(depth.meters, 10.0584, accuracy: 0.001)
    }

    func testDepthComparable() {
        let shallow = Depth(meters: 5)
        let deep = Depth(meters: 10)
        XCTAssertTrue(shallow < deep)
        XCTAssertFalse(deep < shallow)
    }

    // MARK: - Temperature Tests

    func testTemperatureConversion() {
        let temp = Temperature(celsius: 20)
        XCTAssertEqual(temp.celsius, 20.0, accuracy: 0.01)
        XCTAssertEqual(temp.fahrenheit, 68.0, accuracy: 0.01)
        XCTAssertEqual(temp.kelvin, 293.15, accuracy: 0.01)
    }

    func testTemperatureFromFahrenheit() {
        let temp = Temperature(fahrenheit: 68)
        XCTAssertEqual(temp.fahrenheit, 68.0, accuracy: 0.01)
        XCTAssertEqual(temp.celsius, 20.0, accuracy: 0.01)
    }

    func testTemperatureFromKelvin() {
        let temp = Temperature(kelvin: 273.15)
        XCTAssertEqual(temp.celsius, 0.0, accuracy: 0.01)
        XCTAssertEqual(temp.fahrenheit, 32.0, accuracy: 0.01)
    }

    // MARK: - Pressure Tests

    func testPressureConversion() {
        let pressure = Pressure(bar: 200)
        XCTAssertEqual(pressure.bar, 200.0)
        XCTAssertEqual(pressure.psi, 2900.76, accuracy: 0.01)
        XCTAssertEqual(pressure.atmospheres, 197.38, accuracy: 0.01)
    }

    func testPressureFromPSI() {
        let pressure = Pressure(psi: 3000)
        XCTAssertEqual(pressure.psi, 3000.0, accuracy: 0.01)
        XCTAssertEqual(pressure.bar, 206.84, accuracy: 0.01)
    }

    // MARK: - Duration Tests

    func testDurationConversion() {
        let duration = Duration(minutes: 45)
        XCTAssertEqual(duration.seconds, 2700.0)
        XCTAssertEqual(duration.minutes, 45.0)
        XCTAssertEqual(duration.hours, 0.75)
    }

    func testDurationFromHours() {
        let duration = Duration(hours: 1.5)
        XCTAssertEqual(duration.hours, 1.5)
        XCTAssertEqual(duration.minutes, 90.0)
        XCTAssertEqual(duration.seconds, 5400.0)
    }

    // MARK: - Volume Tests

    func testVolumeConversion() {
        let volume = Volume(liters: 12)
        XCTAssertEqual(volume.liters, 12.0, accuracy: 0.01)
        XCTAssertEqual(volume.cubicMeters, 0.012, accuracy: 0.0001)
        XCTAssertEqual(volume.cubicFeet, 0.4238, accuracy: 0.001)
    }

    func testVolumeFromCubicMeters() {
        let volume = Volume(cubicMeters: 0.012)
        XCTAssertEqual(volume.cubicMeters, 0.012, accuracy: 0.0001)
        XCTAssertEqual(volume.liters, 12.0, accuracy: 0.01)
    }

    func testVolumeFromCubicFeet() {
        let volume = Volume(cubicFeet: 80)
        XCTAssertEqual(volume.cubicFeet, 80.0, accuracy: 0.01)
        XCTAssertEqual(volume.liters, 2265.35, accuracy: 0.1)
    }

    func testVolumeComparable() {
        let small = Volume(liters: 7)
        let large = Volume(liters: 12)
        XCTAssertTrue(small < large)
        XCTAssertFalse(large < small)
    }

    func testVolumeCodable() throws {
        // Volume encodes as cubic meters (SI unit)
        let volume = Volume(liters: 12)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(volume)
        let decoded = try decoder.decode(Volume.self, from: data)

        XCTAssertEqual(decoded.cubicMeters, volume.cubicMeters, accuracy: 0.0001)
        XCTAssertEqual(decoded.liters, 12.0, accuracy: 0.01)
    }

    // MARK: - Altitude Tests

    func testAltitudeConversion() {
        let altitude = Altitude(meters: 1000)
        XCTAssertEqual(altitude.meters, 1000.0)
        XCTAssertEqual(altitude.feet, 3280.84, accuracy: 0.01)
    }

    func testAltitudeFromFeet() {
        let altitude = Altitude(feet: 5000)
        XCTAssertEqual(altitude.feet, 5000.0, accuracy: 0.01)
        XCTAssertEqual(altitude.meters, 1524.0, accuracy: 0.1)
    }

    func testAltitudeComparable() {
        let low = Altitude(meters: 500)
        let high = Altitude(meters: 1500)
        XCTAssertTrue(low < high)
        XCTAssertFalse(high < low)
    }

    func testAltitudeCodable() throws {
        let altitude = Altitude(meters: 1200)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(altitude)
        let decoded = try decoder.decode(Altitude.self, from: data)

        XCTAssertEqual(decoded.meters, altitude.meters)
    }

    // MARK: - Codable Tests

    func testDepthCodable() throws {
        let depth = Depth(meters: 15.5)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(depth)
        let decoded = try decoder.decode(Depth.self, from: data)

        XCTAssertEqual(decoded.meters, depth.meters)
    }

    func testTemperatureCodable() throws {
        let temp = Temperature(celsius: 25)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(temp)
        let decoded = try decoder.decode(Temperature.self, from: data)

        XCTAssertEqual(decoded.kelvin, temp.kelvin, accuracy: 0.01)
    }
}
