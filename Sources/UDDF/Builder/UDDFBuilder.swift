import Foundation

/// Fluent builder for creating UDDF documents
///
/// Provides a convenient, type-safe way to construct UDDF documents with method chaining.
///
/// Example:
///
/// ```swift
/// let document = UDDFBuilder()
///     .generator(name: "MyDiveApp", version: "1.0.0")
///     .addDiver(owner: owner)
///     .addDiveSite(site)
///     .addGasMix(air)
///     .addDive(dive)
///     .build()
/// ```
public class UDDFBuilder {
    private var version: String
    private var generator: UDDFGenerator?
    private var mediadata: UDDFMediaData?
    private var makers: [UDDFMaker] = []
    private var businesses: [UDDFBusiness] = []
    private var diverData: UDDFDiverData?
    private var diveSites: [UDDFDiveSite] = []
    private var gasDefinitions: UDDFGasDefinitions?
    private var decoModels: [UDDFDecoModel] = []
    private var profileData: UDDFProfileData?
    private var tableGeneration: UDDFTableGeneration?
    private var diveTrips: [UDDFDiveTrip] = []
    private var diveComputerControl: UDDFDiveComputerControl?

    /// Initialize a new UDDF builder
    ///
    /// - Parameter version: UDDF version (default: "3.2.1")
    public init(version: String = "3.2.1") {
        self.version = version
    }

    // MARK: - Generator

    /// Set the generator information (required)
    ///
    /// - Parameters:
    ///   - name: Application name
    ///   - version: Application version
    ///   - manufacturer: Manufacturer information
    ///   - datetime: Creation date/time
    /// - Returns: Self for method chaining
    @discardableResult
    public func generator(
        name: String,
        version: String? = nil,
        manufacturer: UDDFManufacturerInfo? = nil,
        datetime: Date? = nil
    ) -> Self {
        self.generator = UDDFGenerator(
            name: name,
            manufacturer: manufacturer,
            version: version,
            datetime: datetime
        )
        return self
    }

    /// Set the generator directly
    ///
    /// - Parameter generator: Generator object
    /// - Returns: Self for method chaining
    @discardableResult
    public func generator(_ generator: UDDFGenerator) -> Self {
        self.generator = generator
        return self
    }

    // MARK: - Divers

    /// Add an owner (primary diver)
    ///
    /// - Parameter owner: Owner information
    /// - Returns: Self for method chaining
    @discardableResult
    public func addOwner(_ owner: UDDFOwner) -> Self {
        if diverData == nil {
            diverData = UDDFDiverData()
        }
        if diverData?.owner == nil {
            diverData?.owner = []
        }
        diverData?.owner?.append(owner)
        return self
    }

    /// Add a buddy
    ///
    /// - Parameter buddy: Buddy information
    /// - Returns: Self for method chaining
    @discardableResult
    public func addBuddy(_ buddy: UDDFBuddy) -> Self {
        if diverData == nil {
            diverData = UDDFDiverData()
        }
        if diverData?.buddy == nil {
            diverData?.buddy = []
        }
        diverData?.buddy?.append(buddy)
        return self
    }

    // MARK: - Dive Sites

    /// Add a dive site
    ///
    /// - Parameter site: Dive site information
    /// - Returns: Self for method chaining
    @discardableResult
    public func addDiveSite(_ site: UDDFDiveSite) -> Self {
        diveSites.append(site)
        return self
    }

    // MARK: - Gas Definitions

    /// Add a gas mix
    ///
    /// - Parameter mix: Gas mixture
    /// - Returns: Self for method chaining
    @discardableResult
    public func addGasMix(_ mix: UDDFMix) -> Self {
        if gasDefinitions == nil {
            gasDefinitions = UDDFGasDefinitions()
        }
        if gasDefinitions?.mix == nil {
            gasDefinitions?.mix = []
        }
        gasDefinitions?.mix?.append(mix)
        return self
    }

    /// Add air mix (convenience method)
    ///
    /// - Parameter id: ID for the air mix
    /// - Returns: Self for method chaining
    @discardableResult
    public func addAir(id: String = "air") -> Self {
        let air = UDDFMix(id: id, name: "Air", o2: 0.21, n2: 0.79)
        return addGasMix(air)
    }

    /// Add nitrox mix (convenience method)
    ///
    /// - Parameters:
    ///   - id: ID for the nitrox mix
    ///   - oxygenPercent: Oxygen percentage (e.g., 32 for EAN32)
    /// - Returns: Self for method chaining
    @discardableResult
    public func addNitrox(id: String, oxygenPercent: Double) -> Self {
        let o2 = oxygenPercent / 100.0
        let n2 = 1.0 - o2
        let mix = UDDFMix(
            id: id,
            name: "EAN\(Int(oxygenPercent))",
            o2: o2,
            n2: n2
        )
        return addGasMix(mix)
    }

    // MARK: - Profile Data

    /// Add a repetition group
    ///
    /// - Parameter group: Repetition group
    /// - Returns: Self for method chaining
    @discardableResult
    public func addRepetitionGroup(_ group: UDDFRepetitionGroup) -> Self {
        if profileData == nil {
            profileData = UDDFProfileData()
        }
        if profileData?.repetitiongroup == nil {
            profileData?.repetitiongroup = []
        }
        profileData?.repetitiongroup?.append(group)
        return self
    }

    /// Add a dive to the first repetition group (creates one if needed)
    ///
    /// - Parameter dive: Dive information
    /// - Returns: Self for method chaining
    @discardableResult
    public func addDive(_ dive: UDDFDive) -> Self {
        if profileData == nil {
            profileData = UDDFProfileData()
        }
        if profileData?.repetitiongroup == nil {
            profileData?.repetitiongroup = [UDDFRepetitionGroup()]
        }
        if profileData?.repetitiongroup?[0].dive == nil {
            profileData?.repetitiongroup?[0].dive = []
        }
        profileData?.repetitiongroup?[0].dive?.append(dive)
        return self
    }

    // MARK: - Media

    /// Add an image
    ///
    /// - Parameter image: Image media
    /// - Returns: Self for method chaining
    @discardableResult
    public func addImage(_ image: UDDFImageMedia) -> Self {
        if mediadata == nil {
            mediadata = UDDFMediaData()
        }
        if mediadata?.image == nil {
            mediadata?.image = []
        }
        mediadata?.image?.append(image)
        return self
    }

    // MARK: - Other Sections

    /// Add a maker
    ///
    /// - Parameter maker: Maker information
    /// - Returns: Self for method chaining
    @discardableResult
    public func addMaker(_ maker: UDDFMaker) -> Self {
        makers.append(maker)
        return self
    }

    /// Add a business
    ///
    /// - Parameter business: Business information
    /// - Returns: Self for method chaining
    @discardableResult
    public func addBusiness(_ business: UDDFBusiness) -> Self {
        businesses.append(business)
        return self
    }

    /// Add a decompression model
    ///
    /// - Parameter model: Decompression model
    /// - Returns: Self for method chaining
    @discardableResult
    public func addDecoModel(_ model: UDDFDecoModel) -> Self {
        decoModels.append(model)
        return self
    }

    /// Add a dive trip
    ///
    /// - Parameter trip: Dive trip
    /// - Returns: Self for method chaining
    @discardableResult
    public func addDiveTrip(_ trip: UDDFDiveTrip) -> Self {
        diveTrips.append(trip)
        return self
    }

    // MARK: - Build

    /// Build the UDDF document
    ///
    /// - Returns: Complete UDDF document
    /// - Throws: UDDFError.missingGenerator if generator is not set
    public func build() throws -> UDDFDocument {
        guard let generator = generator else {
            throw UDDFError.missingGenerator
        }

        var document = UDDFDocument(version: version, generator: generator)
        document.mediadata = mediadata
        document.maker = makers.isEmpty ? nil : makers
        document.business = businesses.isEmpty ? nil : businesses
        document.diver = diverData
        document.divesite = diveSites.isEmpty ? nil : diveSites
        document.gasdefinitions = gasDefinitions
        document.decomodel = decoModels.isEmpty ? nil : decoModels
        document.profiledata = profileData
        document.tablegeneration = tableGeneration
        document.divetrip = diveTrips.isEmpty ? nil : diveTrips
        document.divecomputercontrol = diveComputerControl

        return document
    }
}
