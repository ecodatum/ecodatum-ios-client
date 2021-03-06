import Alamofire
import Foundation

typealias Identifier = String
typealias AuthenticationToken = String
typealias Base64Encoded = String

protocol NetworkRequest: Encodable {
  
}

extension NetworkRequest {
  
  func toParameters(_ jsonEncoder: JSONEncoder) -> Parameters? {
    
    guard let data = try? jsonEncoder.encode(self) else {
      return nil
    }
    guard let jsonObject = try? JSONSerialization.jsonObject(
      with: data,
      options: .allowFragments),
      var parameters = jsonObject as? Parameters else {
      return nil
    }
    
    if let _ = self as? ProtectedNetworkRequest {
      // Token is supplied in the HTTP header, not the body.
      parameters.removeValue(forKey: "token")
    }
    
    if parameters.isEmpty {
      return nil
    } else {
      return parameters
    }
    
  }
  
}

protocol ProtectedNetworkRequest: NetworkRequest {
 
  var token: AuthenticationToken { get }
  
}

protocol NetworkResponse: Decodable {
  
}

struct HttpOKResponse: Decodable {
  
}

struct BasicAuthUserRequest: NetworkRequest {
  
  let email: String
  let password: String
  
}

struct BasicAuthUserResponse: NetworkResponse {
  
  let id: Identifier // tokenId
  let token: AuthenticationToken
  let userId: String
  let isRootUser: Bool
  
}

struct LogoutRequest: ProtectedNetworkRequest {
  
  let userId: String
  let token: AuthenticationToken
  
}

struct LogoutResponse: NetworkResponse {
  
}

struct CreateNewOrganizationUserRequest: NetworkRequest {
  
  let organizationCode: String
  let fullName: String
  let email: String
  let password: String
  
}

struct GetUserRequest: ProtectedNetworkRequest {
  
  let userId: Identifier
  let token: AuthenticationToken
  
}

struct UserResponse: NetworkResponse {
  
  let id: Identifier // userId
  let fullName: String
  let email: String
  
}

struct GetOrganizationsByUserRequest: ProtectedNetworkRequest {
  
  let token: AuthenticationToken
  
}

struct OrganizationResponse: NetworkResponse {
 
  let id : Identifier // organization id
  let code: String
  let name: String
  let description: String?
  let createdAt: Date
  let updatedAt: Date
  
}

struct GetMembersByOrganizationAndUserRequest: ProtectedNetworkRequest {

  let token: AuthenticationToken
  let organizationId: String

}

struct RoleResponse: NetworkResponse {

  let id : Identifier // role id
  let name: String

}

struct OrganizationMemberResponse: NetworkResponse {

  let user: UserResponse
  let role: RoleResponse

}

struct NewOrUpdateSiteRequest: ProtectedNetworkRequest {
  
  let token: AuthenticationToken
  let id: String? // site id
  let name: String
  let description: String?
  let latitude: Double
  let longitude: Double
  let altitude: Double?
  let horizontalAccuracy: Double?
  let verticalAccuracy: Double?
  let organizationId: String
  
}

struct GetSitesByOrganizationAndUserRequest: ProtectedNetworkRequest {
  
  let token: AuthenticationToken
  let organizationId: String
  
}

struct SiteResponse: NetworkResponse {
  
  let id: Identifier // site id
  let name: String
  let description: String?
  let latitude: Double
  let longitude: Double
  let altitude: Double?
  let horizontalAccuracy: Double?
  let verticalAccuracy: Double?
  let organizationId: String
  let userId: Identifier
  let createdAt: Date
  let updatedAt: Date
  
}

struct DeleteSiteByIdRequest: ProtectedNetworkRequest {
  
  let token: AuthenticationToken
  let siteId: String
  
}

struct NewOrUpdateSurveyRequest: ProtectedNetworkRequest {
  
  let token: AuthenticationToken
  let id: Identifier? // survey id
  let date: Date
  let description: String?
  let siteId: Identifier
  
}

struct GetSurveysBySiteAndUserRequest: ProtectedNetworkRequest {
  
  let token: AuthenticationToken
  let siteId: Identifier
  
}

struct SurveyResponse: NetworkResponse {
  
  let id: Identifier // survey id
  let date: Date
  let description: String?
  let siteId: Identifier
  let userId: Identifier
  let createdAt: Date
  let updatedAt: Date
  
}

struct DeleteSurveyByIdRequest: ProtectedNetworkRequest {

  let token: AuthenticationToken
  let surveyId: Identifier

}

struct GetMeasurementUnitsRequest: NetworkRequest {

}

struct MeasurementUnitResponse: NetworkResponse {

  struct PrimaryAbioticFactor: Decodable {

    let id: Identifier
    let name: String
    let description: String

  }

  struct SecondaryAbioticFactor: Decodable {

    let id: Identifier
    let name: String
    let label: String
    let description: String

  }

  struct MeasurementUnit: Decodable {

    let id: Identifier
    let dimension: String
    let unit: String
    let label: String
    let description: String

  }

  let primaryAbioticFactor: PrimaryAbioticFactor
  let secondaryAbioticFactor: SecondaryAbioticFactor
  let measurementUnit: MeasurementUnit

}

struct AddNewMeasurementRequest: ProtectedNetworkRequest {
  
  let token: AuthenticationToken
  let surveyId: Identifier
  let abioticFactorId: Identifier
  let measurementUnitId: Identifier
  let value: Double

}

struct GetMeasurementsBySurveyRequest: ProtectedNetworkRequest {
  
  let token: AuthenticationToken
  let surveyId: Identifier
  
}

struct MeasurementResponse: NetworkResponse {
  
  let id: Identifier // measurement id
  let surveyId: Identifier
  let abioticFactorId: Identifier
  let measurementUnitId: Identifier
  let value: Double
  let userId: Identifier
  let createdAt: Date
  let updatedAt: Date
  
}

struct GetPhotosBySurveyRequest: ProtectedNetworkRequest {
  
  let token: AuthenticationToken
  let surveyId: Identifier
  
}

struct NewOrUpdatePhotoRequest: ProtectedNetworkRequest {
  
  let token: AuthenticationToken
  let id: Identifier? // photo id
  let base64Encoded: Base64Encoded
  let description: String
  let surveyId: Identifier
  // Always set to JPEG. Hard-coded for now.
  let photoType: String = "JPEG"
  
}

struct PhotoResponse: NetworkResponse {
  
  let id: Identifier // photo id
  let userId: Identifier
  let description: String
  let imageTypeId: Identifier
  let surveyId: Identifier
  let createdAt: Date
  let updatedAt: Date
  
}

struct DeletePhotoByIdRequest: ProtectedNetworkRequest {
  
  let token: AuthenticationToken
  let photoId: Identifier
  
}

struct GetEcosystemFactorsRequest: NetworkRequest {
  
}

struct EcosystemFactorResponse: NetworkResponse {
  
  let id: Identifier
  let name: String
  
}

struct GetMediaTypesRequest: NetworkRequest {
  
}

struct MediaTypeResponse: NetworkResponse {
  
  let id: Identifier
  let name: String
  
}

struct GetQualitativeObservationTypesRequest: NetworkRequest {
  
}

struct QualitativeObservationTypeResponse: NetworkResponse {
  
  let id: Identifier
  let name: String
  
}

struct GetQuantitativeObservationTypesRequest: NetworkRequest {
  
}

struct QuantitativeObservationTypeResponse: NetworkResponse {
  
  let id: Identifier
  let name: String
  
}

