import XCTest
@testable import UDDF

final class EquipmentTests: XCTestCase {

    // MARK: - TankMaterial Tests

    func testTankMaterialRawValues() {
        XCTAssertEqual(TankMaterial.aluminium.rawValue, "aluminium")
        XCTAssertEqual(TankMaterial.carbon.rawValue, "carbon")
        XCTAssertEqual(TankMaterial.steel.rawValue, "steel")
        XCTAssertEqual(TankMaterial.unknown("titanium").rawValue, "titanium")
    }

    func testTankMaterialInitFromRawValue() {
        XCTAssertEqual(TankMaterial(rawValue: "aluminium"), .aluminium)
        XCTAssertEqual(TankMaterial(rawValue: "aluminum"), .aluminium) // US spelling
        XCTAssertEqual(TankMaterial(rawValue: "carbon"), .carbon)
        XCTAssertEqual(TankMaterial(rawValue: "steel"), .steel)
        XCTAssertEqual(TankMaterial(rawValue: "titanium"), .unknown("titanium"))
    }

    func testTankMaterialIsStandard() {
        XCTAssertTrue(TankMaterial.aluminium.isStandard)
        XCTAssertTrue(TankMaterial.carbon.isStandard)
        XCTAssertTrue(TankMaterial.steel.isStandard)
        XCTAssertFalse(TankMaterial.unknown("titanium").isStandard)
    }

    // MARK: - SuitType Tests

    func testSuitTypeRawValues() {
        XCTAssertEqual(SuitType.diveSkin.rawValue, "dive-skin")
        XCTAssertEqual(SuitType.wetSuit.rawValue, "wet-suit")
        XCTAssertEqual(SuitType.drySuit.rawValue, "dry-suit")
        XCTAssertEqual(SuitType.hotWaterSuit.rawValue, "hot-water-suit")
        XCTAssertEqual(SuitType.other.rawValue, "other")
        XCTAssertEqual(SuitType.unknown("semi-dry").rawValue, "semi-dry")
    }

    func testSuitTypeInitFromRawValue() {
        XCTAssertEqual(SuitType(rawValue: "dive-skin"), .diveSkin)
        XCTAssertEqual(SuitType(rawValue: "wet-suit"), .wetSuit)
        XCTAssertEqual(SuitType(rawValue: "dry-suit"), .drySuit)
        XCTAssertEqual(SuitType(rawValue: "hot-water-suit"), .hotWaterSuit)
        XCTAssertEqual(SuitType(rawValue: "other"), .other)
        XCTAssertEqual(SuitType(rawValue: "semi-dry"), .unknown("semi-dry"))
    }

    func testSuitTypeIsStandard() {
        XCTAssertTrue(SuitType.diveSkin.isStandard)
        XCTAssertTrue(SuitType.wetSuit.isStandard)
        XCTAssertTrue(SuitType.drySuit.isStandard)
        XCTAssertTrue(SuitType.hotWaterSuit.isStandard)
        XCTAssertTrue(SuitType.other.isStandard)
        XCTAssertFalse(SuitType.unknown("semi-dry").isStandard)
    }

    // MARK: - Equipment Container Tests

    func testEquipmentContainerInit() {
        let diveComputer = DiveComputer(id: "dc1", name: "Perdix AI")
        let tank = Tank(id: "tank1", tankmaterial: .steel, tankvolume: Volume(liters: 12))
        let suit = Suit(id: "suit1", suittype: .drySuit)

        let equipment = Equipment(
            divecomputer: [diveComputer],
            suit: [suit],
            tank: [tank]
        )

        XCTAssertEqual(equipment.divecomputer?.count, 1)
        XCTAssertEqual(equipment.divecomputer?.first?.id, "dc1")
        XCTAssertEqual(equipment.tank?.count, 1)
        XCTAssertEqual(equipment.tank?.first?.tankmaterial, .steel)
        XCTAssertEqual(equipment.suit?.count, 1)
        XCTAssertEqual(equipment.suit?.first?.suittype, .drySuit)
    }

    // MARK: - Price Tests

    func testPriceInit() {
        let price = Price(value: 499.99, currency: "EUR")
        XCTAssertEqual(price.value, 499.99)
        XCTAssertEqual(price.currency, "EUR")
    }

    // MARK: - Shop Tests

    func testShopInit() {
        let shop = Shop(
            id: "shop1",
            name: "Dive Center",
            address: Address(city: "Miami", country: "USA"),
            contact: Contact(email: "info@divecenter.com")
        )
        XCTAssertEqual(shop.id, "shop1")
        XCTAssertEqual(shop.name, "Dive Center")
        XCTAssertEqual(shop.address?.city, "Miami")
        XCTAssertEqual(shop.contact?.email, "info@divecenter.com")
    }

    // MARK: - Purchase Tests

    func testPurchaseInit() {
        let purchase = Purchase(
            datetime: Date(),
            price: Price(value: 299.00, currency: "USD"),
            shop: Shop(id: "shop1", name: "Local Dive Shop")
        )
        XCTAssertNotNil(purchase.datetime)
        XCTAssertEqual(purchase.price?.value, 299.00)
        XCTAssertEqual(purchase.shop?.name, "Local Dive Shop")
    }
}
