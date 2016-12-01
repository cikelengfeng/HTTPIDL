from SwiftTypeTransfer import swift_type_name, swift_base_type_name_from_idl_base_type
from gen.EverphotoIDL import EverphotoIDL
from gen.EverphotoIDLLexer import EverphotoIDLLexer

class AlamofireCodeGenerator:

    def alamofire_http_method(self, idl_method_name):
        map = { 'GET': '.get', 'POST': '.post', 'PUT': '.put', 'DELETE': '.delete' , 'PATCH': '.patch'}
        return map[idl_method_name]

    def __init__(self, output=None):
        self.output = output
        self.indent = 0

    def writeLine(self, text):
        indent = reduce(lambda so_far, so_good: so_far + '    ', range(0, self.indent), '')
        print indent + text
        self.output.write((indent + text).encode('utf-8') + '\n')

    def pushIndent(self):
        self.indent += 1

    def popIndent(self):
        self.indent -= 1

    def message_name_from_uri(self, uri_context):
        def uri_path_component_to_text(uri_path_component):
            if uri_path_component.parameterInUri() is not None:
                return uri_path_component.parameterInUri().identifier().getText()
            return uri_path_component.getText()
        return ''.join(map(uri_path_component_to_text, uri_context.uriPathComponent()))

    def request_url_from_uri(self, uri_context):
        def reduceUriPathComponent(so_far, so_good):
            if isinstance(so_good, EverphotoIDL.UriPathComponentContext) and so_good.parameterInUri() is not None:
                return so_far + '\(' + so_good.parameterInUri().identifier().getText() + ')'
            return so_far + so_good.getText()
        uri = reduce(reduceUriPathComponent, uri_context.children, '"') + '"'
        url = 'baseURLString + ' + uri
        return url


    def generate_request_send(self, request_context, message_name, uri_context):
        response_name = self.response_name_from_message(request_context.method().getText(), message_name)
        self.writeLine('func send(with encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, completion: @escaping (' + response_name +', Error?) -> Void) {')
        url = self.request_url_from_uri(uri_context)
        alamofire_method = self.alamofire_http_method(request_context.method().getText())
        self.pushIndent()
        self.writeLine('prepare(headers: headers).responseJSON { (dataResponse) in')
        self.pushIndent()
        self.writeLine('switch dataResponse.result {')
        self.pushIndent()
        self.writeLine('case .failure(let error):')
        self.pushIndent()
        self.writeLine('let responseModel = ' + response_name + '(with: nil, rawResponse: dataResponse.response)')
        self.writeLine('completion(responseModel, error)')
        self.popIndent()
        self.writeLine('case .success(let data):')
        self.pushIndent()
        self.writeLine('let responseModel = ' + response_name + '(with: data, rawResponse: dataResponse.response)')
        self.writeLine('completion(responseModel, nil)')
        self.popIndent()
        self.popIndent()
        self.writeLine('}')
        self.popIndent()
        self.writeLine('}')
        self.popIndent()
        self.writeLine('}')
        self.writeLine('func send(with completion: @escaping (' + response_name +', Error?) -> Void) {')
        self.pushIndent()
        self.writeLine('send(headers: nil, completion: completion)')
        self.popIndent()
        self.writeLine('}')
        self.writeLine('func prepare(with encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?) -> DataRequest {')
        self.pushIndent()
        self.writeLine('return Alamofire.request(' + url +', method:' + alamofire_method + ', parameters: parameters(), encoding: encoding, headers: headers)')
        self.popIndent()
        self.writeLine('}')


    def generate_request_parameters(self, request_context):
        self.writeLine('func parameters() -> [String: Any] {')
        self.pushIndent()
        self.writeLine('var result: [String: Any] = [:]')
        for parameter_map in request_context.structBody().parameterMap():
            self.writeLine('if let tmp = ' + parameter_map.key().getText() + ' {')
            self.pushIndent()
            self.writeLine('result["' + parameter_map.value().getText() + '"] = tmp')
            self.popIndent()
            self.writeLine('}')
        self.writeLine('return result')
        self.popIndent()
        self.writeLine('}')

    def generate_request_init_and_member_var(self, request_context, uri_context):
        def filter_param_in_uri(uri_path_component):
            return uri_path_component.parameterInUri() is not None
        params_in_uri = filter(filter_param_in_uri, uri_context.uriPathComponent())
        for param_in_uri in params_in_uri:
            self.writeLine('let ' + param_in_uri.parameterInUri().identifier().getText() + ': String')
        self.writeLine('var baseURLString = HTTPIDLBaseURLString')
        param_maps = request_context.structBody().parameterMap()
        for param_map in param_maps:
            param_type = param_map.paramType()[0]
            self.writeLine('var ' + param_map.key().getText() + ': ' + swift_type_name(param_type) + '?')
        init_param_list = ', '.join(map(lambda param_in_uri: param_in_uri.parameterInUri().identifier().getText() + ': String', params_in_uri))
        if len(init_param_list) != 0:
            self.writeLine('init(' + init_param_list + ') {')
            self.pushIndent()
            for param_in_uri in params_in_uri:
                self.writeLine('self.' + param_in_uri.parameterInUri().identifier().getText() + ' = ' + param_in_uri.parameterInUri().identifier().getText())
            self.popIndent()
            self.writeLine('}')

    def request_name_from_message(self, message_method, message_name):
        request_name = message_method + message_name + 'Request'
        return request_name

    def generate_request(self, request_context, message_name, uri_context):
        request_name = self.request_name_from_message(request_context.method().getText(), message_name)
        self.writeLine('class ' + request_name + ' {')
        self.pushIndent()
        self.generate_request_init_and_member_var(request_context, uri_context)
        self.generate_request_parameters(request_context)
        self.generate_request_send(request_context, message_name, uri_context)
        self.popIndent()
        self.writeLine('}')

    def response_name_from_message(self, message_method, message_name):
        response_name = message_method + message_name + 'Response'
        return response_name

    def generate_response_init_and_member_var(self, response_context):
        param_maps = response_context.structBody().parameterMap()
        for param_map in param_maps:
            param_type = param_map.paramType()[0]
            self.writeLine('let ' + param_map.key().getText() + ': ' + swift_type_name(param_type) + '?')
        self.writeLine('let rawResponse: HTTPURLResponse?')
        self.writeLine('init(with json: Any?, rawResponse: HTTPURLResponse?) {')
        self.pushIndent()
        self.writeLine('self.rawResponse = rawResponse')
        self.writeLine('if let json = json as? [String: Any] {')
        self.pushIndent()
        for param_map in param_maps:
            param_type = param_map.paramType()[0]
            self.writeLine('self.' + param_map.key().getText() + ' = ' + swift_type_name(param_type) + '(with: json["' + param_map.value().getText() + '"])')
        self.popIndent()
        self.writeLine('} else {')
        self.pushIndent()
        for param_map in param_maps:
            param_type = param_map.paramType()[0]
            self.writeLine('self.' + param_map.key().getText() + ' = nil')
        self.popIndent()
        self.writeLine('}')
        self.popIndent()
        self.writeLine('}')

    def generate_response(self, response_context, message_name):
        response_name = self.response_name_from_message(response_context.method().getText(), message_name)
        self.writeLine('struct ' + response_name + ': RawHTTPResponseWrapper {')
        self.pushIndent()
        self.generate_response_init_and_member_var(response_context)
        self.popIndent()
        self.writeLine('}')

    def generate_message(self, message_context):
        uri = message_context.uri()
        message_name = self.message_name_from_uri(uri)
        requests = message_context.request()
        for request in requests:
            self.generate_request(request, message_name, uri)

        responses = message_context.response()
        for response in responses:
            self.generate_response(response, message_name)

    def generate_struct_init_and_member_var(self, struct_context):
        param_maps = struct_context.structBody().parameterMap()
        for param_map in param_maps:
            param_type = param_map.paramType()[0]
            self.writeLine('let ' + param_map.key().getText() + ': ' + swift_type_name(param_type) + '?')
        self.writeLine('init?(with json: Any?) {')
        self.pushIndent()
        self.writeLine('if let json = json as? [String: Any] {')
        self.pushIndent()
        for param_map in param_maps:
            param_type = param_map.paramType()[0]
            generic_type = param_type.genericType()
            if generic_type is not None:
                array_type = generic_type.arrayGenericParam()
                dict_type = generic_type.dictGenericParam()
                if array_type is not None:
                    array_element_type = array_type.baseType()
                    self.writeLine('if let anyArray = json["' + param_map.value().getText() + '"] as? [Any] {')
                    self.pushIndent()
                    self.writeLine('self.' + param_map.key().getText() + ' = anyArray.flatMap { ' + swift_base_type_name_from_idl_base_type(array_element_type.getText()) + '(with: $0) }')
                    self.popIndent()
                    self.writeLine('} else {')
                    self.pushIndent()
                    self.writeLine('self.' + param_map.key().getText() + ' = nil')
                    self.popIndent()
                    self.writeLine('}')
                elif dict_type is not None:
                    dict_key_type = dict_type.baseType()[0]
                    dict_value_type = dict_type.baseType()[1]
                    self.writeLine('if let anyDict = json["' + param_map.value().getText() + '"] as? [String: Any] {')
                    self.pushIndent()
                    self.writeLine('var tmp: [String: String] = [:]')
                    self.writeLine('anyDict.forEach({ (key, value) in')
                    self.pushIndent()
                    self.writeLine('guard let newKey = ' + swift_base_type_name_from_idl_base_type(dict_key_type.getText()) + '(with: key) else {')
                    self.pushIndent()
                    self.writeLine('return')
                    self.popIndent()
                    self.writeLine('}')
                    self.writeLine('guard let newValue = ' + swift_base_type_name_from_idl_base_type(dict_value_type.getText()) + '(with: value) else {')
                    self.pushIndent()
                    self.writeLine('return')
                    self.popIndent()
                    self.writeLine('}')
                    self.writeLine('tmp[newKey] = newValue')
                    self.popIndent()
                    self.writeLine('})')
                    self.writeLine('if tmp.count > 0 {')
                    self.pushIndent()
                    self.writeLine('self.' + param_map.key().getText() + ' = tmp')
                    self.popIndent()
                    self.writeLine('} else {')
                    self.pushIndent()
                    self.writeLine('self.' + param_map.key().getText() + ' = nil')
                    self.popIndent()
                    self.writeLine('}')
                    self.popIndent()
                    self.writeLine('} else {')
                    self.pushIndent()
                    self.writeLine('self.' + param_map.key().getText() + ' = nil')
                    self.popIndent()
                    self.writeLine('}')
            else:
                self.writeLine('self.' + param_map.key().getText() + ' = ' + swift_type_name(param_type) + '(with: json["' + param_map.value().getText() + '"])')
        self.popIndent()
        self.writeLine('} else {')
        self.pushIndent()
        self.writeLine('return nil')
        self.popIndent()
        self.writeLine('}')
        self.popIndent()
        self.writeLine('}')

    def generate_struct(self, struct_context):
        self.writeLine('struct ' + struct_context.structName().getText() + ': JSONObject {')
        self.pushIndent()
        self.generate_struct_init_and_member_var(struct_context)
        self.popIndent()
        self.writeLine('}')

    def generate_entry(self, entry_context):
        self.writeLine('import Foundation')
        self.writeLine('import Alamofire')
        structs = entry_context.struct()
        for struct in structs:
            self.generate_struct(struct)
        messages = entry_context.message()
        for message in messages:
            self.generate_message(message)











def __parse_tree_from_idl(idl):
    from antlr4 import InputStream
    input_stream = InputStream(idl)

    lexer = EverphotoIDLLexer(input_stream)
    from antlr4 import CommonTokenStream
    stream = CommonTokenStream(lexer)

    parser = EverphotoIDL(stream)
    tree = parser.entry()
    return tree

if __name__ == '__main__':
    uri_template = '''STRUCT SettingsURITemplate {
    STRING avatar = avatar;
    STRING thumbnail = s240;
    STRING origin = origin;
}'''
    idl = '''MESSAGE /application/settings {
    GET REQUEST {
        INT32 test = test;
    }

    GET RESPONSE {
        ApplicationSettingsStruct settings = data;
    }
}

STRUCT SettingsURITemplate {
    STRING avatar = avatar;
    STRING thumbnail = s240;
    STRING origin = origin;
}

STRUCT SettingsOnlineFilter {
    STRING name = name;
    STRING displayName = display_name;
}

STRUCT ApplicationSettingsStruct {
    INT32 tagVersion = system_tag_version;
    STRING smsCode = sms_code_number;
    DICT<STRING, STRING> uriTemplateDict = uri_template;
    SettingsURITemplate uriTemplate = uri_template;
    ARRAY<SettingsOnlineFilter> onlineFilter = filters;
}'''
    parse_tree = __parse_tree_from_idl(idl)
    with open('HTTPIDLDemo/HTTPIDLDemo/APIModel.swift', 'w') as output:
        generator = AlamofireCodeGenerator(output)
        generator.generate_entry(parse_tree)
    print 'end'
