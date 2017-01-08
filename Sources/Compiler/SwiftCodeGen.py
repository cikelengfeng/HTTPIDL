#!/usr/bin/python
# coding:utf-8
import os

import errno

from SwiftTypeTransfer import swift_type_name, swift_base_type_name_from_idl_base_type
from Parser.EverphotoIDL import EverphotoIDL


class AlamofireCodeGenerator:
    def __init__(self, output_file_name, output_directory_path):
        if not os.path.exists(output_directory_path):
            try:
                os.makedirs(output_directory_path)
            except OSError as exc:  # Python >2.5
                if exc.errno == errno.EEXIST and os.path.isdir(output_directory_path):
                    pass
                else:
                    raise

        self.output_file = open(os.path.join(output_directory_path, output_file_name + '.swift'), 'w')
        self.indent = 0

    def write_line(self, text):
        # 1 indent = 4 blank space
        indent = reduce(lambda so_far, so_good: so_far + '    ', range(0, self.indent), '')
        # print indent + text
        self.output_file.write((indent + text) + '\n')

    def write_blank_lines(self, count):
        if count <= 0:
            return
        blank_lines = reduce(lambda so_far, so_good: so_far + '\n', range(0, count - 1), '')
        self.write_line(blank_lines)

    def push_indent(self):
        self.indent += 1

    def pop_indent(self):
        self.indent -= 1

    @staticmethod
    def message_name_from_uri(uri_context):
        def uri_path_component_to_text(uri_path_component):
            if uri_path_component.parameterInUri() is not None:
                text = uri_path_component.parameterInUri().identifier().getText()
            else:
                text = uri_path_component.getText()
            return text.title()

        return ''.join(map(uri_path_component_to_text, uri_context.uriPathComponent()))

    @staticmethod
    def request_url_from_uri(uri_context):
        def reduce_uri_path_component(so_far, so_good):
            if isinstance(so_good, EverphotoIDL.UriPathComponentContext) and so_good.parameterInUri() is not None:
                return so_far + '\(' + so_good.parameterInUri().identifier().getText() + ')'
            return so_far + so_good.getText()

        uri = reduce(reduce_uri_path_component, uri_context.children, '"') + '"'
        url = 'configuration.baseURLString + ' + uri
        return url

    @staticmethod
    def request_uri_from_uri(uri_context):
        def reduce_uri_path_component(so_far, so_good):
            if isinstance(so_good, EverphotoIDL.UriPathComponentContext) and so_good.parameterInUri() is not None:
                return so_far + '\(' + so_good.parameterInUri().identifier().getText() + ')'
            return so_far + so_good.getText()

        uri = reduce(reduce_uri_path_component, uri_context.children, '"') + '"'
        return uri

    def generate_request_send(self, request_context, message_name):
        request_name = self.request_name_from_message(request_context.method().getText(), message_name)
        response_name = self.response_name_from_message(request_context.method().getText(), message_name)
        self.write_line('func send(_ requestEncoder: HTTPRequestEncoder = ' + request_name + '.defaultEncoder, '
                        'completion: @escaping (' + response_name + ') -> Void, errorHandler: @escaping (Error) -> Void) {')
        self.push_indent()
        self.write_line('client.send(self, requestEncoder: requestEncoder, completion: completion, errorHandler: errorHandler)')
        self.pop_indent()
        self.write_line('}')

        self.write_line('func send(_ requestEncoder: HTTPRequestEncoder = ' + request_name + '.defaultEncoder, '
                        'completion: @escaping (HTTPResponse) -> Void, errorHandler: @escaping (Error) -> Void) {')
        self.push_indent()
        self.write_line('client.send(self, requestEncoder: requestEncoder, completion: completion, errorHandler: errorHandler)')
        self.pop_indent()
        self.write_line('}')

    def generate_request_parameters(self, request_context):
        self.write_line('var parameters: [HTTPIDLParameter] {')
        self.push_indent()
        self.write_line('var result: [HTTPIDLParameter] = []')
        for parameter_map in request_context.structBody().parameterMap():
            self.write_line('if let tmp = ' + parameter_map.key().getText() + ' {')
            self.push_indent()
            self.write_line('result.append(tmp.asHTTPIDLParameter(key: "'
                            + parameter_map.value().getText() + '"))')
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

        self.write_line('static let defaultMethod: String = "' + request_context.method().getText() + '"')
        self.write_line('var method: String = ' +
                        self.request_name_from_message(request_context.method().getText(),
                                                       self.message_name_from_uri(uri_context)) + '.defaultMethod'
                        )
        self.write_line('var configuration: HTTPIDLConfiguration = BaseHTTPIDLConfiguration.shared')
        self.write_line('var client: HTTPIDLClient = HTTPIDLBaseClient.shared')
        self.write_line('var uri: String {')
        self.push_indent()
        self.write_line('get {')
        self.push_indent()
        self.write_line('return ' + self.request_uri_from_uri(uri_context))
        self.pop_indent()
        self.write_line('}')
        self.pop_indent()
        self.write_line('}')

        param_maps = request_context.structBody().parameterMap()
        for param_map in param_maps:
            param_type = param_map.paramType()[0]
            self.write_line('var ' + param_map.key().getText() + ': ' + swift_type_name(param_type) + '?')
        init_param_list = ', '.join(
            map(lambda p: p.parameterInUri().identifier().getText() + ': String', params_in_uri))
        if len(init_param_list) != 0:
            self.write_line('init(' + init_param_list + ') {')
            self.push_indent()
            for param_in_uri in params_in_uri:
                self.write_line(
                    'self.' + param_in_uri.parameterInUri().identifier().getText() + ' = ' +
                    param_in_uri.parameterInUri().identifier().getText())
            self.pop_indent()
            self.write_line('}')

    @staticmethod
    def request_name_from_message(message_method, message_name):
        request_name = message_method.title() + message_name + 'Request'
        return request_name

    def generate_request(self, request_context, message_name, uri_context):
        self.write_blank_lines(1)
        request_name = self.request_name_from_message(request_context.method().getText(), message_name)
        self.write_line('class ' + request_name + ': HTTPIDLRequest {')
        self.push_indent()
        self.generate_request_init_and_member_var(request_context, uri_context)
        self.generate_request_parameters(request_context)
        self.generate_request_send(request_context, message_name)
        self.pop_indent()
        self.write_line('}')

    @staticmethod
    def response_name_from_message(message_method, message_name):
        response_name = message_method.title() + message_name + 'Response'
        return response_name

    def generate_response_init_and_member_var(self, response_context, message_name):
        self.write_blank_lines(1)
        param_maps = response_context.structBody().parameterMap()
        for param_map in param_maps:
            param_type = param_map.paramType()[0]
            self.write_line('let ' + param_map.key().getText() + ': ' + swift_type_name(param_type) + '?')
        self.write_line('var json: Any?')
        self.write_line('let rawResponse: HTTPResponse?')
        self.write_line('static var decoder: HTTPResponseBodyJSONDecoder = HTTPResponseBodyJSONDecoder.shared')

        # 从 HTTPResponse 初始化
        self.write_line('init(httpResponse: HTTPResponse) throws {')
        self.push_indent()
        self.write_line('guard let httpBody = httpResponse.body else {')
        self.push_indent()
        self.write_line('self.init(json: nil, rawResponse: httpResponse)')
        self.write_line('return')
        self.pop_indent()
        self.write_line('}')
        response_name = self.response_name_from_message(response_context.method().getText(), message_name)
        self.write_line('let tmp = try ' + response_name + '.decoder.decode(httpBody)')
        self.write_line('self.init(json: tmp, rawResponse: httpResponse)')
        self.pop_indent()
        self.write_line('}')

        # 从 json 或 httpResponse 初始化
        self.write_line('init(json: Any?, rawResponse: HTTPResponse?) {')
        self.push_indent()
        self.write_line('self.rawResponse = rawResponse')

        self.write_line('if let json = json as? [String: Any] {')
        self.push_indent()
        self.write_line('self.json = json')
        for param_map in param_maps:
            param_type = param_map.paramType()[0]
            self.write_line('self.' + param_map.key().getText() + ' = ' + swift_type_name(
                param_type) + '(with: json["' + param_map.value().getText() + '"])')
        self.pop_indent()
        self.write_line('} else {')
        self.push_indent()
        self.write_line('self.json = nil')
        for param_map in param_maps:
            self.write_line('self.' + param_map.key().getText() + ' = nil')
        self.pop_indent()
        self.write_line('}')
        self.pop_indent()
        self.write_line('}')

    def generate_response(self, response_context, message_name):
        self.write_blank_lines(1)
        response_name = self.response_name_from_message(response_context.method().getText(), message_name)
        self.write_line('struct ' + response_name + ': HTTPIDLResponse {')
        self.push_indent()
        self.generate_response_init_and_member_var(response_context, message_name)
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
                        'self.' + param_map.key().getText() + ' = anyArray.flatMap { ' +
                        swift_base_type_name_from_idl_base_type(array_element_type.getText()) + '(with: $0) }')
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
        self.write_line('import HTTPIDL')
        self.write_blank_lines(1)
        structs = entry_context.struct()
        for struct in structs:
            self.generate_struct(struct)
        messages = entry_context.message()
        for message in messages:
            self.generate_message(message)

# class HTTPIDLErrorListener(ErrorListener):
#     def syntaxError(self, recognizer, offending_symbol, line, column, msg, e):
#         print 'parser failed!!!'
#         print 'error near line ' + str(line) + ':' + str(column) + ' reason:( ' + msg + ' )'
#         sys.exit(1)
#
#
# def __parse_tree_from_idl(input_idl, error_listener):
#     from antlr4 import InputStream
#     input_stream = InputStream(input_idl)
#     lexer = EverphotoIDLLexer(input_stream)
#     from antlr4 import CommonTokenStream
#     stream = CommonTokenStream(lexer)
#     parser = EverphotoIDL(stream)
#     parser.addErrorListener(error_listener)
#     tree = parser.entry()
#     return tree
#
#
# if __name__ == '__main__':
#     uri_template = '''STRUCT SettingsURITemplate {
#     STRING avatar = avatar;
#     STRING thumbnail = s240;
#     STRING origin = origin;
# }'''
#     idl = '''MESSAGE /application/settings {
#     GET REQUEST {
#         ARRAY<INT32> test = hahahah;
#     }
#
#     GET RESPONSE {
#         ApplicationSettingsStruct settings = data;
#     }
# }
#
# STRUCT SettingsURITemplate {
#     STRING avatar = avatar;
#     STRING thumbnail = s240;
#     STRING origin = origin;
# }
#
# STRUCT SettingsOnlineFilter {
#     STRING name = name;
#     STRING displayName = display_name;
# }
#
# STRUCT ApplicationSettingsStruct {
#     INT32 tagVersion = system_tag_version;
#     STRING smsCode = sms_code_number;
#     DICT<STRING, STRING> uriTemplateDict = uri_template;
#     SettingsURITemplate uriTemplate = uri_template;
#     ARRAY<SettingsOnlineFilter> onlineFilter = filters;
# }
#
# MESSAGE /filters/shinkai {
#     POST REQUEST {
#         FILE image = media;
#         INT32 test = tt;
#     }
#
#     POST RESPONSE {
#
#     }
# }
#
# '''
#
#     parse_tree = __parse_tree_from_idl(idl, HTTPIDLErrorListener())
#     with open('HTTPIDLDemo/HTTPIDLDemo/APIModel.swift', 'w') as output:
#         generator = AlamofireCodeGenerator(output)
#         generator.generate_entry(parse_tree)
#     print 'end'
