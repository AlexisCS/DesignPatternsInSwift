import Foundation

//Single responsability and Open-Close
enum Color {
    case red
    case green
    case blue
}

enum Size {
    case small
    case medium
    case large
}

class Product {
    var name: String
    var color: Color
    var size: Size
    
    init(_ name: String, _ color: Color, _ size: Size) {
        self.name = name
        self.color = color
        self.size = size
    }
}

protocol Specification {
    associatedtype T
    func isSatisfied(_ item: T) -> Bool
}

protocol Filter {
    associatedtype T
    static func filter<Spec: Specification>(_ items: [T], _ spec: Spec) -> [T] where Spec.T == T
}

class ColorSpecification: Specification {
    typealias T = Product
    let color: Color
    
    init(_ color: Color) {
        self.color = color
    }
    
    func isSatisfied(_ item: Product) -> Bool {
        return item.color == color
    }
}

class ApplyFilter: Filter {
    typealias T = Product

    static func filter<Spec>(_ items: [Product], _ spec: Spec) -> [Product] where Spec : Specification, ApplyFilter.T == Spec.T {
        var result: [Product] = []
        for product in items {
            if spec.isSatisfied(product) {
                result.append(product)
            }
        }
        return result
    }
}

let apple = Product("Apple", .green, .small)
let tree = Product("Tree", .green, .large)
let house = Product("House", .blue, .large)
let colorSpecification = ColorSpecification(.green)

let products = [apple, tree, house]
for product in ApplyFilter.filter(products, colorSpecification) {
    print("- \(product.name)")
}
