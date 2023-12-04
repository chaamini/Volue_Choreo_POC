import ballerina/ftp;
import ballerina/http;
import ballerina/io;
import ballerina/lang.'string as strings;

// configurable string host = ?;
// configurable string username = ?;
// configurable string password = ?;
// configurable int port = ?;

ftp:ClientConfiguration ftpConfig = {
        protocol: ftp:SFTP,
        host: "ftp.support.wso2.com",
        port: 22,
        auth: {credentials: {username: "voluepoc", password: "kSKY8Ecx*lfHuKHnWrEs"}}
};

final ftp:Client clientEp = check new(ftpConfig);


service /processEDI on new http:Listener(5050) {
    resource isolated function get .(string edifilePath) returns json|error? {
      string ediMultipleText = check readFile(edifilePath);
      Metered_services_consumption_report_message mscons = check fromEdiString(ediMultipleText);
      return mscons.toJsonString();
    }
}

isolated function readFile(string filePath) returns string|error {
    stream<byte[], io:Error?> str = check clientEp -> get("/voluepoc/EDIFiles/" + filePath);
    byte[] bArray = [];
    check from byte[] content in str
    do {
        bArray.push(...content);
    };
    string fileContent = check strings:fromBytes(bArray);
    return fileContent;
}
