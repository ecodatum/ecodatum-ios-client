import Alamofire
import Foundation
import Hydra

class NetworkManager {
  
  private let baseURL: URL

  private let jsonEncoder: JSONEncoder = {
    let jsonEncoder = JSONEncoder()
    jsonEncoder.dateEncodingStrategy = .customISO8601
    return jsonEncoder
  }()
  
  private var jsonDecoder: JSONDecoder = {
    let jsonDecoder = JSONDecoder()
    jsonDecoder.dateDecodingStrategy = .customISO8601
    return jsonDecoder
  }()
  
  private let emptyJsonData = "{}".data(using: String.Encoding.utf8)!

  init(baseURL: URL) {
    self.baseURL = baseURL
  }
  
  func makeImageURL(_ imageId: Identifier) -> URL {
    return baseURL
      .appendingPathComponent("public")
      .appendingPathComponent("images")
      .appendingPathComponent(imageId)
  }
  
  func call(_ request: BasicAuthUserRequest) throws -> Promise<BasicAuthUserResponse> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL.appendingPathComponent("login"),
        method: .post,
        headers: Request.basicAuthHeaders(
          email: request.email,
          password: request.password),
        request: request))
  }
  
  func call(_ request: LogoutRequest) throws -> Promise<LogoutResponse> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("protected")
          .appendingPathComponent("logout"),
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))
  }
  
  func call(_ request: CreateNewOrganizationUserRequest) throws -> Promise<UserResponse> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("public")
          .appendingPathComponent("users"),
        method: .post,
        parameters: request.toParameters(jsonEncoder),
        request: request))
  }
  
  func call(_ request: GetUserRequest) throws -> Promise<UserResponse> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("protected")
          .appendingPathComponent("users")
          .appendingPathComponent("\(request.userId)"),
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))
  }
  
  func call(_ request: GetOrganizationsByUserRequest) throws -> Promise<[OrganizationResponse]> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("protected")
          .appendingPathComponent("organizations"),
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))
  }

  func call(_ request: GetMembersByOrganizationAndUserRequest) throws -> Promise<[OrganizationMemberResponse]> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("protected")
          .appendingPathComponent("organizations")
          .appendingPathComponent("\(request.organizationId)")
          .appendingPathComponent("members"),
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))
  }
  
  func call(_ request: NewOrUpdateSiteRequest) throws -> Promise<SiteResponse> {
    
    let method: HTTPMethod = request.id == nil ? .post : .put
    var url = baseURL
      .appendingPathComponent("protected")
      .appendingPathComponent("sites")
    if method == .put,
      let id = request.id {
      url = url.appendingPathComponent("\(id)")
    }
    
    return try executeDataRequest(
      makeDataRequest(
        url,
        method: method,
        parameters: request.toParameters(jsonEncoder),
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))
  
  }
  
  func call(_ request: DeleteSiteByIdRequest) throws -> Promise<HttpOKResponse> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("protected")
          .appendingPathComponent("sites")
          .appendingPathComponent("\(request.siteId)"),
        method: .delete,
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))
  }

  func call(_ request: GetSitesByOrganizationAndUserRequest) throws -> Promise<[SiteResponse]> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("protected")
          .appendingPathComponent("organizations")
          .appendingPathComponent("\(request.organizationId)")
          .appendingPathComponent("sites"),
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))
  }
  
  func call(_ request: NewOrUpdateSurveyRequest) throws -> Promise<SurveyResponse> {

    let method: HTTPMethod = request.id == nil ? .post : .put
    var url = baseURL
      .appendingPathComponent("protected")
      .appendingPathComponent("surveys")
    if method == .put,
       let id = request.id {
      url = url.appendingPathComponent("\(id)")
    }

    return try executeDataRequest(
      makeDataRequest(
        url,
        method: method,
        parameters: request.toParameters(jsonEncoder),
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))

  }

  func call(_ request: DeleteSurveyByIdRequest) throws -> Promise<HttpOKResponse> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("protected")
          .appendingPathComponent("surveys")
          .appendingPathComponent("\(request.surveyId)"),
        method: .delete,
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))
  }

  func call(_ request: GetSurveysBySiteAndUserRequest) throws -> Promise<[SurveyResponse]> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("protected")
          .appendingPathComponent("sites")
          .appendingPathComponent("\(request.siteId)")
          .appendingPathComponent("surveys"),
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))
  }

  func call(_ request: GetMeasurementUnitsRequest) throws -> Promise<[MeasurementUnitResponse]> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("public")
          .appendingPathComponent("measurementUnits"),
        request: request))
  }

  func call(_ request: AddNewMeasurementRequest)
    throws -> Promise<MeasurementResponse> {
      return try executeDataRequest(
        makeDataRequest(
          baseURL
            .appendingPathComponent("protected")
            .appendingPathComponent("measurements"),
          method: .post,
          parameters: request.toParameters(jsonEncoder),
          headers: Request.bearerTokenAuthHeaders(request.token),
          request: request))
  }
  
  func call(_ request: GetMeasurementsBySurveyRequest) throws -> Promise<[MeasurementResponse]> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("protected")
          .appendingPathComponent("surveys")
          .appendingPathComponent("\(request.surveyId)")
          .appendingPathComponent("measurements"),
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))
  }
  
  func call(_ request: GetPhotosBySurveyRequest) throws -> Promise<[PhotoResponse]> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("protected")
          .appendingPathComponent("surveys")
          .appendingPathComponent("\(request.surveyId)")
          .appendingPathComponent("images"),
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))
  }

  func call(_ request: NewOrUpdatePhotoRequest) throws -> Promise<PhotoResponse> {

    let method: HTTPMethod = request.id == nil ? .post : .put
    var url = baseURL
      .appendingPathComponent("protected")
      .appendingPathComponent("images")
    if method == .put,
       let id = request.id {
      url = url.appendingPathComponent("\(id)")
    }

    return try executeDataRequest(
      makeDataRequest(
        url,
        method: method,
        parameters: request.toParameters(jsonEncoder),
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))

  }

  func call(_ request: DeletePhotoByIdRequest) throws -> Promise<HttpOKResponse> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("protected")
          .appendingPathComponent("images")
          .appendingPathComponent("\(request.photoId)"),
        method: .delete,
        headers: Request.bearerTokenAuthHeaders(request.token),
        request: request))
  }
  
  func call(_ request: GetEcosystemFactorsRequest) throws -> Promise<[EcosystemFactorResponse]> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("public")
          .appendingPathComponent("ecosystemFactors"),
        request: request))
  }
  
  func call(_ request: GetMediaTypesRequest) throws -> Promise<[MediaTypeResponse]> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("public")
          .appendingPathComponent("mediaTypes"),
        request: request))
  }
  
  func call(_ request: GetQualitativeObservationTypesRequest) throws -> Promise<[QualitativeObservationTypeResponse]> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("public")
          .appendingPathComponent("qualitativeObservationTypes"),
        request: request))
  }
  
  func call(_ request: GetQuantitativeObservationTypesRequest) throws -> Promise<[QuantitativeObservationTypeResponse]> {
    return try executeDataRequest(
      makeDataRequest(
        baseURL
          .appendingPathComponent("public")
          .appendingPathComponent("quantitativeObservationTypes"),
        request: request))
  }
  
  private func makeDataRequest(
    _ url: URL,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil,
    headers: HTTPHeaders? = Request.defaultHeaders(),
    request: NetworkRequest)
    -> DataRequest {
      
      return Alamofire.request(
        url,
        method: method,
        parameters: parameters,
        encoding: JSONEncoding.default,
        headers: headers)
      
  }
  
  private func executeDataRequest<T: Decodable>(
    _ dataRequest: DataRequest)
    throws -> Promise<T> {
      
      LOG.debug(dataRequest.debugDescription)
      
      return Promise<T>(in: .userInitiated) {
        
        resolve, reject, status in
        
        dataRequest.validate(statusCode: [200]).responseData {
          
          response in
          
          if let error = response.error {
            reject(error)
            
          } else if let data = response.data {
            
            var _data = data
            if data.count == 0 {
              _data = self.emptyJsonData
            }
            
            do {
            
              let response = try self.jsonDecoder.decode(
                T.self,
                from: _data)
              resolve(response)
            
            } catch let error {
          
              reject(error)
            
            }
          
          } else {
            
            reject(NetworkError.unexpectedResponse)
          
          }
          
        }
      }
  }
  
}
