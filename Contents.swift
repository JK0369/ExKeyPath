import UIKit

// MARK: - KVC
class Person: NSObject { // NSObject 서브클래싱
  @objc var name: String? // @objc 어노테이션
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

person[keyPath: \Person.name]
person[keyPath: \.name]

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

// MARK: - KeyPath sugar Example
struct SomeModel {
  let name: String
  let age: Int
}
let someModel1 = SomeModel(name: "jake", age: 12)
let someModel2 = SomeModel(name: "lee", age: 32)
let someModel3: SomeModel? = SomeModel(name: "han", age: 20)
let someModel4: SomeModel? = nil

let res1 = [someModel1, someModel2].map(\.name)
let res2 = [someModel3, someModel4].compactMap(\.?.name)

struct MyModel: Codable {
  let name: String
}

// MARK: - KeyPath sugar Exmaple 1
/* 예시로 사용할 json
{
  "items":[
     {
        "name":"jake",
        "age": 12
     },
     {
        "name":"jake",
        "age": 30
     },
  ]
}
*/

// 사용하는쪽에서 keyPath x
// map(MyResponseModel.self)
struct MyResponseModel: Codable {
  struct User: Codable {
    let name: String
    let age: Int
  }
  enum CodingKeys: String, CodingKey {
    case users = "items"
  }
  let users: [User]
}

// 사용하는쪽에서 keyPath o
// map([MyResponseModel2].self, atKeyPath: "items")
struct MyResponseModel2: Codable {
  let name: String
  let age: Int
}

// MARK: - KeyPath sugar Exmaple 2
/*
 {
    "profile":{
       "user_id":"abcd",
       "secret":{
          "age":12
       }
    }
 }
 */

// 사용하는쪽에서 keyPath x
// map(MyResponseModel3.self)
struct MyResponseModel3: Codable {
  struct User: Codable {
    struct Secret: Codable {
      let age: Int
    }
    enum CodingKeys: String, CodingKey {
      case userID = "user_id"
      case age
    }
    let userID: String
    let age: Int
  }
  let profile: [User]
}

// 사용하는쪽에서 keyPath o
// map([MyResponseModel4].self, atKeyPath: "profile")
struct MyResponseModel4: Codable {
  struct Secret: Codable {
    let age: Int
  }
  enum CodingKeys: String, CodingKey {
    case userID = "user_id"
    case age
  }
  let userID: String
  let age: Int
}
