import XCTest
@testable import WhatsNewKit

// MARK: - WhatsNewVersionStoreTests

/// The WhatsNewVersionStoreTests
final class WhatsNewVersionStoreTests: WhatsNewKitTestCase {
    
    func testInMemoryWhatsNewVersionStore() {
        let inMemoryWhatsNewVersionStore = InMemoryWhatsNewVersionStore()
        let version = self.executeVersionStoreTest(inMemoryWhatsNewVersionStore)
        XCTAssertEqual(
            [version],
            inMemoryWhatsNewVersionStore.versions
        )
        inMemoryWhatsNewVersionStore.removeAll()
        XCTAssert(
            inMemoryWhatsNewVersionStore.presentedVersions.isEmpty
        )
        XCTAssert(
            inMemoryWhatsNewVersionStore.versions.isEmpty
        )
    }
    
    func testUserDefaultsWhatsNewVersionStore() {
        final class FakeUserDefaults: UserDefaults {
            var store: [String: Any] = .init()
            
            override func set(_ value: Any?, forKey defaultName: String) {
                self.store[defaultName] = value
            }
            
            override func dictionaryRepresentation() -> [String: Any] {
                self.store
            }
        }
        let fakeUserDefaults = FakeUserDefaults()
        let userDefaultsWhatsNewVersionStore = UserDefaultsWhatsNewVersionStore(
            userDefaults: fakeUserDefaults
        )
        let version = self.executeVersionStoreTest(userDefaultsWhatsNewVersionStore)
        XCTAssertEqual(
            fakeUserDefaults.store.count,
            1
        )
        XCTAssertEqual(
            version,
            (fakeUserDefaults.store[version.key] as? String).flatMap(WNew.Version.init)
        )
        userDefaultsWhatsNewVersionStore.removeAll()
        XCTAssert(
            userDefaultsWhatsNewVersionStore.presentedVersions.isEmpty
        )
        XCTAssert(
            fakeUserDefaults.store.isEmpty
        )
    }
    
    func testNSUbiquitousKeyValueWhatsNewVersionStore() {
        final class FakeNSUbiquitousKeyValueStore: NSUbiquitousKeyValueStore {
            var store: [String: Any] = .init()
            
            override var dictionaryRepresentation: [String: Any] {
                self.store
            }
            
            override func set(_ value: Any?, forKey defaultName: String) {
                self.store[defaultName] = value
            }
            
            override func removeObject(forKey aKey: String) {
                self.store.removeValue(forKey: aKey)
            }
        }
        let fakeNSUbiquitousKeyValueStore = FakeNSUbiquitousKeyValueStore()
        let ubiquitousKeyValueWhatsNewVersionStore = NSUbiquitousKeyValueWhatsNewVersionStore(
            ubiquitousKeyValueStore: fakeNSUbiquitousKeyValueStore
        )
        let version = self.executeVersionStoreTest(ubiquitousKeyValueWhatsNewVersionStore)
        XCTAssertEqual(
            fakeNSUbiquitousKeyValueStore.store.count,
            1
        )
        XCTAssertEqual(
            version,
            (fakeNSUbiquitousKeyValueStore.store[version.key] as? String).flatMap(WNew.Version.init)
        )
        ubiquitousKeyValueWhatsNewVersionStore.removeAll()
        XCTAssert(
            ubiquitousKeyValueWhatsNewVersionStore.presentedVersions.isEmpty
        )
        XCTAssert(
            fakeNSUbiquitousKeyValueStore.store.isEmpty
        )
    }
    
    func testVersionStoreWithNamespace() {
        let store = InMemoryWhatsNewVersionStore()
        
        // Test versions with different namespaces
        let version1 = WNew.Version(major: 1, minor: 0, patch: 0, namespace: "feature1")
        let version2 = WNew.Version(major: 1, minor: 0, patch: 0, namespace: "feature2")
        let version3 = WNew.Version(major: 1, minor: 0, patch: 0) // global namespace
        
        store.save(presentedVersion: version1)
        store.save(presentedVersion: version2)
        store.save(presentedVersion: version3)
        
        // Verify all versions are stored
        XCTAssertTrue(store.hasPresented(version1))
        XCTAssertTrue(store.hasPresented(version2))
        XCTAssertTrue(store.hasPresented(version3))
        
        // Verify versions with different namespaces are treated as distinct
        XCTAssertEqual(store.presentedVersions.count, 3)
        
        // Test removal of specific namespaced version
        store.remove(presentedVersion: version1)
        XCTAssertFalse(store.hasPresented(version1))
        XCTAssertTrue(store.hasPresented(version2))
    }
    
}

private extension WhatsNewVersionStoreTests {
    
    func executeVersionStoreTest(
        _ versionStore: WhatsNewVersionStore
    ) -> WNew.Version {
        let version = self.makeRandomWhatsNewVersion()
        XCTAssert(versionStore.presentedVersions.isEmpty)
        XCTAssertFalse(versionStore.hasPresented(version))
        versionStore.save(
            presentedVersion: version
        )
        XCTAssertEqual([version], versionStore.presentedVersions)
        XCTAssert(versionStore.hasPresented(version))
        return version
    }
    
}
