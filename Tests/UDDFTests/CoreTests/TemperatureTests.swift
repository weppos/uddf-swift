import XCTest
@testable import UDDF

final class TemperatureTests: XCTestCase {
    func testCelsiusConversion() {
        let temperature = Temperature(celsius: 20)

        XCTAssertEqual(temperature.kelvin, 293.15)
        XCTAssertEqual(temperature.celsius, 20.0)
        XCTAssertEqual(temperature.fahrenheit, 68.0)
    }

    func testFahrenheitInitializer() {
        let temperature = Temperature(fahrenheit: 68)

        XCTAssertEqual(temperature.kelvin, 293.15)
        XCTAssertEqual(temperature.fahrenheit, 68.0)
        XCTAssertEqual(temperature.celsius, 20.0)
    }

    func testKelvinInitializer() {
        let temperature = Temperature(kelvin: 273.15)

        XCTAssertEqual(temperature.kelvin, 273.15)
        XCTAssertEqual(temperature.celsius, 0.0)
        XCTAssertEqual(temperature.fahrenheit, 32.0)
    }

    func testComparable() {
        XCTAssertLessThan(Temperature(celsius: 10), Temperature(celsius: 20))
    }

    func testCodableRoundTrip() throws {
        let temperature = Temperature(celsius: 25)
        let data = try JSONEncoder().encode(temperature)
        let decoded = try JSONDecoder().decode(Temperature.self, from: data)

        XCTAssertEqual(decoded.kelvin, temperature.kelvin)
    }
}
