---
date: 2023-05-29 12:05
description: Use dyanmic coding keys in your app
tags: Feature, SwiftUI, Codable
featuredDescription: Use dyanmic coding keys in your app!
---
# Learn how to use dynamic coding keys in your app

<div class="post-tags" markdown="1">
    <a class="post-category post-category-feature" href="/tags/feature">Feature</a>
    <a class="post-category post-category-swiftui" href="/tags/swiftui">SwiftUI</a>
    <a class="post-category post-category-codable" href="/tags/appicon">Codable</a>
</div>

### Introduction
In mobile development, one common task is fetching data from a server and displaying it in your app. In iOS development using Swift, this often involves decoding JSON data and presenting it to users. While it's relatively straightforward to decode JSON and display the data, there are scenarios where the code can become less scalable and more difficult to maintain. This tutorial will address one such scenario by introducing dynamic coding keys, which provide a flexible approach to handling JSON data with varying keys. By leveraging dynamic coding keys, you can make your code more readable and adaptable to changes in the backend data.

### Getting Started
To follow along with this tutorial, you can download the starter project [here](https://github.com/thomaskellough/iOS-Tutorials-SwiftUI/tree/main/How-To-Use-Dynamic-Coding-Keys-Starter).

### Problem
The starter project is a simple app that decodes a list of homes for sale and displays some data about the homes to the user. Let's take a look at an example home from the [JSON](https://github.com/thomaskellough/iOS-Tutorials-SwiftUI/blob/main/How-To-Use-Dynamic-Coding-Keys-Starter/How-To-Use-Dynamic-Coding-Keys/homesData.json) data:

```
{
    "id": 1,
    "address": "123 Main St",
    "city": "Exampleville",
    "state": "Exampshire",
    "zip": "12345",
    "price": 250000,
    "bedrooms": 3,
    "bathrooms": 2,
    "description": "This beautiful home features a spacious living room, modern kitchen, and a backyard garden.",
    "amenity1": "Swimming Pool",
    "amenity2": "Fireplace",
    "amenity3": "Garage",
    "amenity4": "Garden",
    "amenity5": "",
    "amenity6": "",
    "amenity7": "",
    "amenity8": "",
    "amenity9": "",
    "amenity10": "",
    "photos": [
        "https://example.com/photos/1.jpg",
        "https://example.com/photos/2.jpg",
        "https://example.com/photos/3.jpg"
    ]
}
```

At first glance, this JSON seems straightforward. You might be tempted to write code to fetch and decode this data, and display it to the user. However, there is a problem with the way this JSON is formatted. Notice the amenities section with keys like "amenity1", "amenity2", and so on. This solution requires hard-coding each amenity as a separate property in the Home struct. But what happens when new amenities are added? We would need to update our code and release a new version of the app. This is not ideal, as it introduces more room for errors and makes our code less adaptable to changes in the backend data. A naive solution may look something like this:

```
struct Home: Codable {
    let id: Int
    let address: String
    let city: String
    let state: String
    let zip: String
    let price: Int
    let bedrooms: Int
    let bathrooms: Int
    let description: String
    
    private let amenity1: String
    private let amenity2: String
    private let amenity3: String
    private let amenity4: String
    private let amenity5: String
    private let amenity6: String
    private let amenity7: String
    private let amenity8: String
    private let amenity9: String
    private let amenity10: String
    
    init(id: Int, address: String, city: String, state: String, zip: String, price: Int, bedrooms: Int, bathrooms: Int, description: String, photos: [String], amenity1: String, amenity2: String, amenity3: String, amenity4: String, amenity5: String, amenity6: String, amenity7: String, amenity8: String, amenity9: String, amenity10: String) {
        self.id = id
        self.address = address
        self.city = city
        self.state = state
        self.zip = zip
        self.price = price
        self.bedrooms = bedrooms
        self.bathrooms = bathrooms
        self.description = description
        self.amenity1 = amenity1
        self.amenity2 = amenity2
        self.amenity3 = amenity3
        self.amenity4 = amenity4
        self.amenity5 = amenity5
        self.amenity6 = amenity6
        self.amenity7 = amenity7
        self.amenity8 = amenity8
        self.amenity9 = amenity9
        self.amenity10 = amenity10
    }
    
    func getAmenities() -> [String] {
        return [amenity1, amenity2, amenity3, amenity4, amenity5, amenity6, amenity7, amenity8, amenity9, amenity10].filter { !$0.isEmpty }
    }
}
```

### Solution Approach

To address the limitations of the current solution, we will leverage dynamic coding keys. Dynamic coding keys allow us to handle varying keys in the JSON data without the need for hard-coding each property. With this approach, our code can gracefully handle new amenities being added without requiring manual updates and releases.

#### Step 1: Refining the Data Model
First, we will enhance the data model to effectively handle the dynamic nature of amenities. We'll introduce a new property, amenities, as a list to store all the amenities associated with a home. This modification allows for seamless expansion of amenity options without the need to modify the codebase. Here's an updated version of the Home struct:


```
struct Home: Codable {
    let id: Int
    let address: String
    let city: String
    let state: String
    let zip: String
    let price: Int
    let bedrooms: Int
    let bathrooms: Int
    let description: String

    private var amenities: [String] = []

    func getAmenities() -> [String] {
        return amenities
    }
}
```

#### Step 2: Implementing Dynamic Coding Keys
To support dynamic decoding, we will introduce a new `DynamicKey` struct that conforms to the CodingKey protocol. This struct enables us to handle the variable nature of the keys in the JSON data. Here's an example implementation:

```
struct DynamicKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
}
```

#### Step 3: Updating the Decoding Process
Next, we will update the decoding process to utilize dynamic coding keys instead of the default coding keys. This change ensures that our code can adapt to varying key names in the JSON data. Here's the updated decoding logic:


```
struct Home: Codable {
    // ...

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)

        // Handle decoding for each property
        if let idKey = DynamicKey(stringValue: "id"), let id = try container.decodeIfPresent(Int.self, forKey: idKey) {
            self.id = id
        } else {
            throw DecodingError.keyNotFound(DynamicKey(stringValue: "id")!, DecodingError.Context(codingPath: [], debugDescription: "Required property 'id' is missing"))
        }

        // Repeat the above decoding process for other properties

        // Handling amenities decoding dynamically
        var amenitiesArr: [String] = []
        for key in container.allKeys {
            if key.stringValue.hasPrefix("amenity"), let amenity = try container.decodeIfPresent(String.self, forKey: key) {
                if amenity.isEmpty { continue }
                amenitiesArr.append(amenity)
            }
        }
        self.amenities = amenitiesArr
    }

    // ...
}

```

That means, after updating everything, you should see something very similar to this.

```
struct DynamicKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
}

struct Home: Codable {
    let id: Int
    let address: String
    let city: String
    let state: String
    let zip: String
    let price: Int
    let bedrooms: Int
    let bathrooms: Int
    let description: String

    private var amenities: [String] = []

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)

        if let idKey = DynamicKey(stringValue: "id"), let id = try container.decodeIfPresent(Int.self, forKey: idKey) {
            self.id = id
        } else {
            throw DecodingError.keyNotFound(DynamicKey(stringValue: "id")!, DecodingError.Context(codingPath: [], debugDescription: "Required property 'id' is missing"))
        }

        if let addressKey = DynamicKey(stringValue: "address"), let address = try container.decodeIfPresent(String.self, forKey: addressKey) {
            self.address = address
        } else {
            throw DecodingError.keyNotFound(DynamicKey(stringValue: "address")!, DecodingError.Context(codingPath: [], debugDescription: "Required property 'address' is missing"))
        }

        if let cityKey = DynamicKey(stringValue: "city"), let city = try container.decodeIfPresent(String.self, forKey: cityKey) {
            self.city = city
        } else {
            throw DecodingError.keyNotFound(DynamicKey(stringValue: "city")!, DecodingError.Context(codingPath: [], debugDescription: "Required property 'city' is missing"))
        }

        if let stateKey = DynamicKey(stringValue: "state"), let state = try container.decodeIfPresent(String.self, forKey: stateKey) {
            self.state = state
        } else {
            throw DecodingError.keyNotFound(DynamicKey(stringValue: "state")!, DecodingError.Context(codingPath: [], debugDescription: "Required property 'state' is missing"))
        }

        if let zipKey = DynamicKey(stringValue: "zip"), let zip = try container.decodeIfPresent(String.self, forKey: zipKey) {
            self.zip = zip
        } else {
            throw DecodingError.keyNotFound(DynamicKey(stringValue: "zip")!, DecodingError.Context(codingPath: [], debugDescription: "Required property 'zip' is missing"))
        }

        if let priceKey = DynamicKey(stringValue: "price"), let price = try container.decodeIfPresent(Int.self, forKey: priceKey) {
            self.price = price
        } else {
            throw DecodingError.keyNotFound(DynamicKey(stringValue: "price")!, DecodingError.Context(codingPath: [], debugDescription: "Required property 'price' is missing"))
        }

        if let bedroomsKey = DynamicKey(stringValue: "bedrooms"), let bedrooms = try container.decodeIfPresent(Int.self, forKey: bedroomsKey) {
            self.bedrooms = bedrooms
        } else {
            throw DecodingError.keyNotFound(DynamicKey(stringValue: "bedrooms")!, DecodingError.Context(codingPath: [], debugDescription: "Required property 'bedrooms' is missing"))
        }

        if let bathroomsKey = DynamicKey(stringValue: "bathrooms"), let bathrooms = try container.decodeIfPresent(Int.self, forKey: bathroomsKey) {
            self.bathrooms = bathrooms
        } else {
            throw DecodingError.keyNotFound(DynamicKey(stringValue: "bathrooms")!, DecodingError.Context(codingPath: [], debugDescription: "Required property 'bathrooms' is missing"))
        }

        if let descriptionKey = DynamicKey(stringValue: "description"), let description = try container.decodeIfPresent(String.self, forKey: descriptionKey) {
            self.description = description
        } else {
            throw DecodingError.keyNotFound(DynamicKey(stringValue: "bathrooms")!, DecodingError.Context(codingPath: [], debugDescription: "Required property 'bathrooms' is missing"))
        }

        var amenitiesArr: [String] = []
        for key in container.allKeys {
            if key.stringValue.hasPrefix("amenity"), let amenity = try container.decodeIfPresent(String.self, forKey: key) {
                if amenity.isEmpty { continue }
                amenitiesArr.append(amenity)
            }
        }
        self.amenities = amenitiesArr
    }

    func getAmenities() -> [String] {
        return amenities
    }
}
```

With this updated decoding logic, we can successfully decode all the properties, including the dynamically named amenities.

By incorporating dynamic coding keys, we have improved the flexibility and adaptability of our codebase. The updated solution gracefully handles varying keys in the JSON data, allowing for the addition of new amenities without manual code modifications. This approach ensures a robust and future-proof implementation, enabling smooth integration with the evolving data structure.

One more thing to note here. You may be thinking that the JSON is formatted poorly and it should be updated to just have a list of amenities instead of listing them one-by-one. Honestly, you're right. However, you may not have the power to change this depending on where you work. So it's important that you understand how to handle whatever is thrown at you, just in case your recommendations go unnoticed.

#### Final Solution
This is already a great solution, but let's make it even better by improving the code readability and reducing redundancy.

Currently, each required property is individually decoded and checked for presence. We can simplify this process by creating a helper function that handles the decoding and error throwing for us.

We'll add a private function called `decodeRequiredWithKey` that takes the type of the property, the key name, and the decoding container. This function will attempt to decode the value for the given key and throw an error if the value is missing.

```
private func decodeRequiredWithKey<T: Decodable>(_ type: T.Type, key: String, container: KeyedDecodingContainer<DynamicKey>) throws -> T {
    guard let dynamicKey = DynamicKey(stringValue: key) else {
        throw DynamicKeyError.dynamicKeyNotFound
    }
    
    do {
        return try container.decode(type, forKey: dynamicKey)
    } catch DecodingError.keyNotFound {
        throw DecodingError.keyNotFound(dynamicKey, DecodingError.Context(codingPath: [], debugDescription: "Required property '\(key)' is missing"))
    } catch {
        throw DynamicKeyError.valueNotFound
    }
}
```

Now, instead of individually decoding and checking each property, we can use the decodeRequiredWithKey function for each required property. This makes the code more concise and improves maintainability.

```
self.id = try decodeRequiredWithKey(Int.self, key: "id", container: container)
self.address = try decodeRequiredWithKey(String.self, key: "address", container: container)
self.city = try decodeRequiredWithKey(String.self, key: "city", container: container)
self.state = try decodeRequiredWithKey(String.self, key: "state", container: container)
self.zip = try decodeRequiredWithKey(String.self, key: "zip", container: container)
self.price = try decodeRequiredWithKey(Int.self, key: "price", container: container)
self.bedrooms = try decodeRequiredWithKey(Int.self, key: "bedrooms", container: container)
self.bathrooms = try decodeRequiredWithKey(Int.self, key: "bathrooms", container: container)
self.description = try decodeRequiredWithKey(String.self, key: "description", container: container)
```

This means you'll neeed to set some default values for all properites of your code, but I still think it makes it cleaner. The final solution is:

```
struct DynamicKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
}

enum DynamicKeyError: Error {
    case dynamicKeyNotFound
    case valueNotFound
}

struct Home: Codable {
    var id: Int = 0
    var address: String = ""
    var city: String = ""
    var state: String = ""
    var zip: String = ""
    var price: Int = 0
    var bedrooms: Int = 0
    var bathrooms: Int = 0
    var description: String = ""

    private var amenities: [String] = []
    
    private func decodeRequiredWithKey<T: Decodable>(_ type: T.Type, key: String, container: KeyedDecodingContainer<DynamicKey>) throws -> T {
        guard let dynamicKey = DynamicKey(stringValue: key) else {
            throw DynamicKeyError.dynamicKeyNotFound
        }
        
        do {
            return try container.decode(type, forKey: dynamicKey)
        } catch DecodingError.keyNotFound {
            throw DecodingError.keyNotFound(dynamicKey, DecodingError.Context(codingPath: [], debugDescription: "Required property '\(key)' is missing"))
        } catch {
            throw DynamicKeyError.valueNotFound
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        
        self.id = try decodeRequiredWithKey(Int.self, key: "id", container: container)
        self.address = try decodeRequiredWithKey(String.self, key: "address", container: container)
        self.city = try decodeRequiredWithKey(String.self, key: "city", container: container)
        self.state = try decodeRequiredWithKey(String.self, key: "state", container: container)
        self.zip = try decodeRequiredWithKey(String.self, key: "zip", container: container)
        self.price = try decodeRequiredWithKey(Int.self, key: "price", container: container)
        self.bedrooms = try decodeRequiredWithKey(Int.self, key: "bedrooms", container: container)
        self.bathrooms = try decodeRequiredWithKey(Int.self, key: "bathrooms", container: container)
        self.description = try decodeRequiredWithKey(String.self, key: "description", container: container)
        
        var amenitiesArr: [String] = []
        for key in container.allKeys {
            if key.stringValue.hasPrefix("amenity"), let amenity = try container.decodeIfPresent(String.self, forKey: key) {
                if amenity.isEmpty { continue }
                amenitiesArr.append(amenity)
            }
        }
        self.amenities = amenitiesArr
    }

    func getAmenities() -> [String] {
        return amenities
    }
}
```

### Conclusion
I hope all your decoding is clean and easy, but if not, I hope you're a bit more prepard on how to tackle whatever is thrown your way. If you'd like to find the source code for this project you can do so [here](https://github.com/thomaskellough/iOS-Tutorials-SwiftUI).

