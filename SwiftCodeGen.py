#!/usr/bin/python
# coding:utf-8
import sys

from SwiftTypeTransfer import swift_type_name, swift_base_type_name_from_idl_base_type
from antlr4.error.ErrorListener import ErrorListener
from gen.EverphotoIDL import EverphotoIDL
from gen.EverphotoIDLLexer import EverphotoIDLLexer


class AlamofireCodeGenerator:
    def alamofire_http_method(self, idl_method_name):
        map = {'GET': '.get', 'POST': '.post', 'PUT': '.put', 'DELETE': '.delete', 'PATCH': '.patch'}
        return map[idl_method_name]

    def __init__(self, output=None):
        self.output = output
        self.indent = 0

    def write_line(self, text):
        indent = reduce(lambda so_far, so_good: so_far + '    ', range(0, self.indent), '')
        print indent + text
        self.output.write((indent + text) + '\n')

    def write_blank_lines(self, count):
        if count <= 0:
            return
        blank_lines = reduce(lambda so_far, so_good: so_far + '\n', range(0, count - 1), '')
        self.write_line(blank_lines)

    def push_indent(self):
        self.indent += 1

    def pop_indent(self):
        self.indent -= 1

    def message_name_from_uri(self, uri_context):
        def uri_path_component_to_text(uri_path_component):
            if uri_path_component.parameterInUri() is not None:
                text = uri_path_component.parameterInUri().identifier().getText()
            else:
                text = uri_path_component.getText()
            return text.title()

        return ''.join(map(uri_path_component_to_text, uri_context.uriPathComponent()))

    def request_url_from_uri(self, uri_context):
        def reduceUriPathComponent(so_far, so_good):
            if isinstance(so_good, EverphotoIDL.UriPathComponentContext) and so_good.parameterInUri() is not None:
                return so_far + '\(' + so_good.parameterInUri().identifier().getText() + ')'
            return so_far + so_good.getText()

        uri = reduce(reduceUriPathComponent, uri_context.children, '"') + '"'
        url = 'baseURLString + ' + uri
        return url

    def need_multipart(self, request_context):
        params = request_context.structBody().parameterMap()
        if len(params) is 0:
            return False
        for param in params:
            t = param.paramType()[0].baseType()
            if t is None:
                continue
            file_type = t.FILE()
            if file_type is not None:
                return True
            blob_type = t.BLOB()
            if blob_type is not None:
                return True
        return False

    def multipart_params_from_request(self, request_context):
        params = request_context.structBody().parameterMap()
        if len(params) is 0:
            return None
        def filter_func(param):
            t = param.paramType()[0].baseType()
            if t is None:
                return False
            file_type = t.FILE()
            if file_type is not None:
                return True
            blob_type = t.BLOB()
            if blob_type is not None:
                return True
            return False
        return filter(filter_func, params)

    def normal_params_from_request(self, request_context):
        params = request_context.structBody().parameterMap()
        if len(params) is 0:
            return None
        def filter_func(param):
            t = param.paramType()[0].baseType()
            if t is None:
                return False
            file_type = t.FILE()
            if file_type is not None:
                return False
            blob_type = t.BLOB()
            if blob_type is not None:
                return False
            return True
        return filter(filter_func, params)

    def generate_request_send_multipart(self, request_context, message_name, uri_context):
        self.write_blank_lines(1)
        response_name = self.response_name_from_message(request_context.method().getText(), message_name)
        url = self.request_url_from_uri(uri_context)
        self.write_line(
            'func prepare(encodingCompletion: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?) {')
        self.push_indent()
        self.write_line('var dest = ' + url)
        self.write_line('if var urlComponents = URLComponents(string: dest) {')
        self.push_indent()
        self.write_line('var queryItems = urlComponents.queryItems ?? []')
        for param in self.normal_params_from_request(request_context):
            self.write_line('if let tmp = self.' + param.key().getText() + ' {')
            self.push_indent()
            self.write_line(
                'queryItems.append(URLQueryItem(name: "' + param.value().getText() + '", value: "\(tmp)"))')
            self.pop_indent()
            self.write_line('}')
        self.write_line('urlComponents.queryItems = queryItems')
        self.write_line('if let urlString = urlComponents.string {')
        self.push_indent()
        self.write_line('dest = urlString')
        self.pop_indent()
        self.write_line('}')
        self.pop_indent()
        self.write_line('}')
        self.write_line('Alamofire.upload(multipartFormData: { (multipart) in')
        self.push_indent()
        for param in self.multipart_params_from_request(request_context):
            self.write_line('if let tmp = self.' + param.key().getText() + ' {')
            self.push_indent()
            self.write_line('multipart.append(tmp, withName: "' + param.value().getText() + '")')
            self.pop_indent()
            self.write_line('}')
        self.pop_indent()
        self.write_line('}, to: dest, encodingCompletion: encodingCompletion)')
        self.pop_indent()
        self.write_line('}')
        # 生成send 方法
        self.write_line('func send(with completion: @escaping (' + response_name + ', Error?) -> Void) {')
        self.push_indent()
        self.write_line('prepare(encodingCompletion: { (encodingResult) in')
        self.push_indent()
        self.write_line('switch encodingResult {')
        self.push_indent()
        self.write_line('case .success(let upload, _, _):')
        self.push_indent()
        self.write_line('upload.responseJSON { (dataResponse) in')
        self.push_indent()
        self.write_line('switch dataResponse.result {')
        self.push_indent()
        self.write_line('case .failure(let error):')
        self.push_indent()
        self.write_line('let responseModel = ' + response_name + '(with: nil, rawResponse: dataResponse.response)')
        self.write_line('completion(responseModel, error)')
        self.pop_indent()
        self.write_line('case .success(let data):')
        self.push_indent()
        self.write_line('let responseModel = ' + response_name + '(with: data, rawResponse: dataResponse.response)')
        self.write_line('completion(responseModel, nil)')
        self.pop_indent()
        self.pop_indent()
        self.write_line('}')
        self.pop_indent()
        self.write_line('}')
        self.pop_indent()
        self.write_line('case .failure(let encodingError):')
        self.push_indent()
        self.pop_indent()
        self.write_line('let responseModel = ' + response_name + '(with: nil, rawResponse: nil)')
        self.write_line('completion(responseModel, encodingError)')
        self.pop_indent()
        self.write_line('}')
        self.pop_indent()
        self.write_line('})')
        self.pop_indent()
        self.write_line('}')

    def generate_request_send_normal(self, request_context, message_name, uri_context):
        self.write_blank_lines(1)
        response_name = self.response_name_from_message(request_context.method().getText(), message_name)
        self.write_line(
            'func send(with encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, completion: @escaping (' + response_name + ', Error?) -> Void) {')
        url = self.request_url_from_uri(uri_context)
        alamofire_method = self.alamofire_http_method(request_context.method().getText())
        self.push_indent()
        self.write_line('prepare(headers: headers).responseJSON { (dataResponse) in')
        self.push_indent()
        self.write_line('switch dataResponse.result {')
        self.push_indent()
        self.write_line('case .failure(let error):')
        self.push_indent()
        self.write_line('let responseModel = ' + response_name + '(with: nil, rawResponse: dataResponse.response)')
        self.write_line('completion(responseModel, error)')
        self.pop_indent()
        self.write_line('case .success(let data):')
        self.push_indent()
        self.write_line('let responseModel = ' + response_name + '(with: data, rawResponse: dataResponse.response)')
        self.write_line('completion(responseModel, nil)')
        self.pop_indent()
        self.pop_indent()
        self.write_line('}')
        self.pop_indent()
        self.write_line('}')
        self.pop_indent()
        self.write_line('}')
        self.write_line('func send(with completion: @escaping (' + response_name + ', Error?) -> Void) {')
        self.push_indent()
        self.write_line('send(headers: nil, completion: completion)')
        self.pop_indent()
        self.write_line('}')
        self.write_line(
            'func prepare(with encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?) -> DataRequest {')
        self.push_indent()
        self.write_line(
            'return Alamofire.request(' + url + ', method:' + alamofire_method + ', parameters: parameters(), encoding: encoding, headers: headers)')
        self.pop_indent()
        self.write_line('}')

    def generate_request_parameters(self, request_context):
        self.write_line('func parameters() -> [String: Any] {')
        self.push_indent()
        self.write_line('var result: [String: Any] = [:]')
        for parameter_map in request_context.structBody().parameterMap():
            self.write_line('if let tmp = ' + parameter_map.key().getText() + ' {')
            self.push_indent()
            self.write_line('result["' + parameter_map.value().getText() + '"] = tmp')
            self.pop_indent()
            self.write_line('}')
        self.write_line('return result')
        self.pop_indent()
        self.write_line('}')

    def generate_request_init_and_member_var(self, request_context, uri_context):
        self.write_blank_lines(1)

        def filter_param_in_uri(uri_path_component):
            return uri_path_component.parameterInUri() is not None

        params_in_uri = filter(filter_param_in_uri, uri_context.uriPathComponent())
        for param_in_uri in params_in_uri:
            self.write_line('let ' + param_in_uri.parameterInUri().identifier().getText() + ': String')
        self.write_line('var baseURLString = HTTPIDLBaseURLString')
        param_maps = request_context.structBody().parameterMap()
        for param_map in param_maps:
            param_type = param_map.paramType()[0]
            self.write_line('var ' + param_map.key().getText() + ': ' + swift_type_name(param_type) + '?')
        init_param_list = ', '.join(
            map(lambda param_in_uri: param_in_uri.parameterInUri().identifier().getText() + ': String', params_in_uri))
        if len(init_param_list) != 0:
            self.write_line('init(' + init_param_list + ') {')
            self.push_indent()
            for param_in_uri in params_in_uri:
                self.write_line(
                    'self.' + param_in_uri.parameterInUri().identifier().getText() + ' = ' + param_in_uri.parameterInUri().identifier().getText())
            self.pop_indent()
            self.write_line('}')

    def request_name_from_message(self, message_method, message_name):
        request_name = message_method.title() + message_name + 'Request'
        return request_name

    def generate_request(self, request_context, message_name, uri_context):
        self.write_blank_lines(1)
        request_name = self.request_name_from_message(request_context.method().getText(), message_name)
        self.write_line('class ' + request_name + ' {')
        self.push_indent()
        self.generate_request_init_and_member_var(request_context, uri_context)
        self.generate_request_parameters(request_context)
        if self.need_multipart(request_context):
            self.generate_request_send_multipart(request_context, message_name, uri_context)
        else:
            self.generate_request_send_normal(request_context, message_name, uri_context)
        self.pop_indent()
        self.write_line('}')

    def response_name_from_message(self, message_method, message_name):
        response_name = message_method.title() + message_name + 'Response'
        return response_name

    def generate_response_init_and_member_var(self, response_context):
        self.write_blank_lines(1)
        param_maps = response_context.structBody().parameterMap()
        for param_map in param_maps:
            param_type = param_map.paramType()[0]
            self.write_line('let ' + param_map.key().getText() + ': ' + swift_type_name(param_type) + '?')
        self.write_line('let rawResponse: HTTPURLResponse?')
        self.write_line('init(with json: Any?, rawResponse: HTTPURLResponse?) {')
        self.push_indent()
        self.write_line('self.rawResponse = rawResponse')
        self.write_line('if let json = json as? [String: Any] {')
        self.push_indent()
        for param_map in param_maps:
            param_type = param_map.paramType()[0]
            self.write_line('self.' + param_map.key().getText() + ' = ' + swift_type_name(
                param_type) + '(with: json["' + param_map.value().getText() + '"])')
        self.pop_indent()
        self.write_line('} else {')
        self.push_indent()
        for param_map in param_maps:
            self.write_line('self.' + param_map.key().getText() + ' = nil')
        self.pop_indent()
        self.write_line('}')
        self.pop_indent()
        self.write_line('}')

    def generate_response(self, response_context, message_name):
        self.write_blank_lines(1)
        response_name = self.response_name_from_message(response_context.method().getText(), message_name)
        self.write_line('struct ' + response_name + ': RawHTTPResponseWrapper {')
        self.push_indent()
        self.generate_response_init_and_member_var(response_context)
        self.pop_indent()
        self.write_line('}')

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
        self.write_blank_lines(1)
        param_maps = struct_context.structBody().parameterMap()
        for param_map in param_maps:
            param_type = param_map.paramType()[0]
            self.write_line('let ' + param_map.key().getText() + ': ' + swift_type_name(param_type) + '?')
        self.write_line('init?(with json: Any?) {')
        self.push_indent()
        self.write_line('if let json = json as? [String: Any] {')
        self.push_indent()
        for param_map in param_maps:
            param_type = param_map.paramType()[0]
            generic_type = param_type.genericType()
            if generic_type is not None:
                array_type = generic_type.arrayGenericParam()
                dict_type = generic_type.dictGenericParam()
                if array_type is not None:
                    array_element_type = array_type.baseType()
                    self.write_line('if let anyArray = json["' + param_map.value().getText() + '"] as? [Any] {')
                    self.push_indent()
                    self.write_line(
                        'self.' + param_map.key().getText() + ' = anyArray.flatMap { ' + swift_base_type_name_from_idl_base_type(
                            array_element_type.getText()) + '(with: $0) }')
                    self.pop_indent()
                    self.write_line('} else {')
                    self.push_indent()
                    self.write_line('self.' + param_map.key().getText() + ' = nil')
                    self.pop_indent()
                    self.write_line('}')
                elif dict_type is not None:
                    dict_key_type = dict_type.baseType()[0]
                    dict_value_type = dict_type.baseType()[1]
                    self.write_line('if let anyDict = json["' + param_map.value().getText() + '"] as? [String: Any] {')
                    self.push_indent()
                    self.write_line('var tmp: [String: String] = [:]')
                    self.write_line('anyDict.forEach({ (key, value) in')
                    self.push_indent()
                    self.write_line('guard let newKey = ' + swift_base_type_name_from_idl_base_type(
                        dict_key_type.getText()) + '(with: key) else {')
                    self.push_indent()
                    self.write_line('return')
                    self.pop_indent()
                    self.write_line('}')
                    self.write_line('guard let newValue = ' + swift_base_type_name_from_idl_base_type(
                        dict_value_type.getText()) + '(with: value) else {')
                    self.push_indent()
                    self.write_line('return')
                    self.pop_indent()
                    self.write_line('}')
                    self.write_line('tmp[newKey] = newValue')
                    self.pop_indent()
                    self.write_line('})')
                    self.write_line('if tmp.count > 0 {')
                    self.push_indent()
                    self.write_line('self.' + param_map.key().getText() + ' = tmp')
                    self.pop_indent()
                    self.write_line('} else {')
                    self.push_indent()
                    self.write_line('self.' + param_map.key().getText() + ' = nil')
                    self.pop_indent()
                    self.write_line('}')
                    self.pop_indent()
                    self.write_line('} else {')
                    self.push_indent()
                    self.write_line('self.' + param_map.key().getText() + ' = nil')
                    self.pop_indent()
                    self.write_line('}')
            else:
                self.write_line('self.' + param_map.key().getText() + ' = ' + swift_type_name(
                    param_type) + '(with: json["' + param_map.value().getText() + '"])')
        self.pop_indent()
        self.write_line('} else {')
        self.push_indent()
        self.write_line('return nil')
        self.pop_indent()
        self.write_line('}')
        self.pop_indent()
        self.write_line('}')

    def generate_struct(self, struct_context):
        self.write_blank_lines(1)
        self.write_line('struct ' + struct_context.structName().getText() + ': JSONObject {')
        self.push_indent()
        self.generate_struct_init_and_member_var(struct_context)
        self.pop_indent()
        self.write_line('}')

    def generate_entry(self, entry_context):
        self.write_line('//这是自动生成的代码，不要改动，否则你的改动会被覆盖！！！！！！！')
        self.write_blank_lines(1)
        self.write_line('import Foundation')
        self.write_line('import Alamofire')
        self.write_blank_lines(1)
        structs = entry_context.struct()
        for struct in structs:
            self.generate_struct(struct)
        messages = entry_context.message()
        for message in messages:
            self.generate_message(message)


class HTTPIDLErrorListener(ErrorListener):
    def syntaxError(self, recognizer, offendingSymbol, line, column, msg, e):
        print 'parser failed!!!'
        print 'error near line ' + str(line) + ':' + str(column) + ' reason:( ' + msg + ' )'
        sys.exit(1)


def __parse_tree_from_idl(idl, error_listener):
    from antlr4 import InputStream
    input_stream = InputStream(idl)
    lexer = EverphotoIDLLexer(input_stream)
    from antlr4 import CommonTokenStream
    stream = CommonTokenStream(lexer)
    parser = EverphotoIDL(stream)
    parser.addErrorListener(error_listener)
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
}

MESSAGE /filters/shinkai {
    POST REQUEST {
        FILE image = media;
    }

    POST RESPONSE {

    }
}

'''

    parse_tree = __parse_tree_from_idl(idl, HTTPIDLErrorListener())
    with open('HTTPIDLDemo/HTTPIDLDemo/APIModel.swift', 'w') as output:
        generator = AlamofireCodeGenerator(output)
        generator.generate_entry(parse_tree)
    print 'end'
