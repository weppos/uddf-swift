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
    private var generator: Generator?
    private var mediadata: MediaData?
    private var makers: [Maker] = []
    private var businesses: [Business] = []
    private var diver: Diver?
    private var diveSites: [DiveSite] = []
    private var gasDefinitions: GasDefinitions?
    private var decomodel: DecoModel?
    private var profileData: ProfileData?
    private var tableGeneration: TableGeneration?
    private var diveTrips: [DiveTrip] = []
    private var diveComputerControl: DiveComputerControl?

    /// Initialize a new UDDF builder
    ///
    /// - Parameter version: UDDF version (default: "3.2.1")
    public init(version: String = "3.2.1") {
        self.version = version
    }

    // MARK: - Generator

    /// Set the generator information
    ///
    /// - Parameters:
    ///   - name: Application name (recommended)
    ///   - version: Application version
    ///   - manufacturer: Manufacturer information
    ///   - datetime: Creation date/time
    /// - Returns: Self for method chaining
    @discardableResult
    public func generator(
        name: String? = nil,
        version: String? = nil,
        manufacturer: Manufacturer? = nil,
        datetime: Date? = nil
    ) -> Self {
        self.generator = Generator(
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
    public func generator(_ generator: Generator) -> Self {
        self.generator = generator
        return self
    }

    // MARK: - Divers

    /// Add an owner (primary diver)
    ///
    /// - Parameter owner: Owner information
    /// - Returns: Self for method chaining
    @discardableResult
    public func addOwner(_ owner: Owner) -> Self {
        if diver == nil {
            diver = Diver()
        }
        diver?.owner = owner
        return self
    }

    /// Add a buddy
    ///
    /// - Parameter buddy: Buddy information
    /// - Returns: Self for method chaining
    @discardableResult
    public func addBuddy(_ buddy: Buddy) -> Self {
        if diver == nil {
            diver = Diver()
        }
        if diver?.buddy == nil {
            diver?.buddy = []
        }
        diver?.buddy?.append(buddy)
        return self
    }

    // MARK: - Dive Sites

    /// Add a dive site
    ///
    /// - Parameter site: Dive site information
    /// - Returns: Self for method chaining
    @discardableResult
    public func addDiveSite(_ site: DiveSite) -> Self {
        diveSites.append(site)
        return self
    }

    // MARK: - Gas Definitions

    /// Add a gas mix
    ///
    /// - Parameter mix: Gas mixture
    /// - Returns: Self for method chaining
    @discardableResult
    public func addGasMix(_ mix: Mix) -> Self {
        if gasDefinitions == nil {
            gasDefinitions = GasDefinitions()
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
        let air = Mix(id: id, name: "Air", o2: 0.21, n2: 0.79)
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
        let mix = Mix(
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
    public func addRepetitionGroup(_ group: RepetitionGroup) -> Self {
        if profileData == nil {
            profileData = ProfileData()
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
    public func addDive(_ dive: Dive) -> Self {
        if profileData == nil {
            profileData = ProfileData()
        }
        if profileData?.repetitiongroup == nil {
            profileData?.repetitiongroup = [RepetitionGroup()]
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
    public func addImage(_ image: ImageMedia) -> Self {
        if mediadata == nil {
            mediadata = MediaData()
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
    public func addMaker(_ maker: Maker) -> Self {
        makers.append(maker)
        return self
    }

    /// Add a business
    ///
    /// - Parameter business: Business information
    /// - Returns: Self for method chaining
    @discardableResult
    public func addBusiness(_ business: Business) -> Self {
        businesses.append(business)
        return self
    }

    /// Set the decompression model container
    ///
    /// - Parameter model: Decompression model container
    /// - Returns: Self for method chaining
    @discardableResult
    public func setDecoModel(_ model: DecoModel) -> Self {
        decomodel = model
        return self
    }

    /// Add a Bühlmann decompression model
    ///
    /// - Parameter model: Bühlmann model parameters
    /// - Returns: Self for method chaining
    @discardableResult
    public func addBuehlmann(_ model: Buehlmann) -> Self {
        if decomodel == nil {
            decomodel = DecoModel()
        }
        if decomodel?.buehlmann == nil {
            decomodel?.buehlmann = []
        }
        decomodel?.buehlmann?.append(model)
        return self
    }

    /// Add a VPM decompression model
    ///
    /// - Parameter model: VPM model parameters
    /// - Returns: Self for method chaining
    @discardableResult
    public func addVPM(_ model: VPM) -> Self {
        if decomodel == nil {
            decomodel = DecoModel()
        }
        if decomodel?.vpm == nil {
            decomodel?.vpm = []
        }
        decomodel?.vpm?.append(model)
        return self
    }

    /// Add an RGBM decompression model
    ///
    /// - Parameter model: RGBM model parameters
    /// - Returns: Self for method chaining
    @discardableResult
    public func addRGBM(_ model: RGBM) -> Self {
        if decomodel == nil {
            decomodel = DecoModel()
        }
        if decomodel?.rgbm == nil {
            decomodel?.rgbm = []
        }
        decomodel?.rgbm?.append(model)
        return self
    }

    /// Add a dive trip
    ///
    /// - Parameter trip: Dive trip
    /// - Returns: Self for method chaining
    @discardableResult
    public func addDiveTrip(_ trip: DiveTrip) -> Self {
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
        document.diver = diver
        document.divesite = diveSites.isEmpty ? nil : diveSites
        document.gasdefinitions = gasDefinitions
        document.decomodel = decomodel
        document.profiledata = profileData
        document.tablegeneration = tableGeneration
        document.divetrip = diveTrips.isEmpty ? nil : diveTrips
        document.divecomputercontrol = diveComputerControl

        return document
    }
}
