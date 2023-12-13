import ballerina/http;

service /processEDI on new http:Listener(5050) {
    resource isolated function post .(http:Request request) returns json|error? {
      string payload = check request.getTextPayload();
      Metered_services_consumption_report_message mscons = check fromEdiString(payload);
      return mscons.toJson();
    }
}
