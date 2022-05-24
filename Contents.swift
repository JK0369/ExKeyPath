import UIKit

// MARK: - KVC
class Person: NSObject { // NSObject 서브클래싱
  @objc var name: String? // @objc 어노테이션
  var age = 1 {
    willSet { print(newValue) }
    didSet { print(oldValue) }
  }
}

let person = Person()
person.value(forKey: "name") // nil
person.setValue("jake", forKey: "name")
person.value(forKey: "name") // "jake"

// MARK: - KVO
class Person2: NSObject { // NSObject 서브클래싱
  @objc dynamic var name: String? // @objc dynamic 어노테이션
}
let person2 = Person2()
person2.observe(\.name, options: [.old, .new]) { instance, change in
  print(change.oldValue, change.newValue)
}
person2.name = "fix" // 위에서 Optional(nil) Optional(Optional("fix")) 출력

// MARK: - KeyPath

var greeting = "Hello, playground"
// 값을 참조하는게 아닌 프로퍼티를 참조하는 방법
// 인스턴스의 값을 참조하는게 아니라 인스턴스의 프로퍼티 참조

struct PersonInfo {
  var name: String
  var age: Int
}

struct School {
  var kim: PersonInfo
  var han: PersonInfo
  
  func getKim() -> PersonInfo {
    return self.kim
  }
  func getHan() -> PersonInfo {
    return self.han
  }
}

let kim = PersonInfo(name: "jake", age: 12)
let han = PersonInfo(name: "jack", age: 13)
let school = School(kim: kim, han: han)

print(school.getKim())
print(school.getHan())

extension School {
  func getSchool(keyPath: KeyPath<Self, PersonInfo>) -> PersonInfo {
    self[keyPath: keyPath]
  }
}

print(school.getSchool(keyPath: \.kim))
print(school.getSchool(keyPath: \.han))

// ex2)
let res1 = [kim, han].map(\.name)
