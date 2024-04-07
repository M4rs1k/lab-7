import Foundation
import CoreData

@objc(MyShift)
public class MyShift: NSManagedObject {
    @NSManaged public var checkin: String?
    @NSManaged public var checkout: String?
    @NSManaged public var date: Date?
}
