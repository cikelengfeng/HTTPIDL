#!/usr/bin/python
# coding:utf-8
import os

import errno
import sys

from SwiftTypeTransfer import swift_type_name, swift_base_type_name_from_idl_base_type
from Parser.HTTPIDL import HTTPIDL
from NameMethod import underline_to_upper_camel_case

reload(sys)
sys.setdefaultencoding('utf8')

httpidl_content_type = 'RequestContent'


class Swift3CodeGenerator:
    def __init__(self, output_file_name, output_directory_path, dependency_analyzer):
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
        self.dependency_analyzer = dependency_analyzer

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
    def message_name(message_context):
        if message_context.messageName() is not None:
            return message_context.messageName().identifier().getText()
        uri_context = message_context.uri()

        def uri_path_component_to_text(uri_path_component):
            if uri_path_component.parameterInUri() is not None:
                text = uri_path_component.parameterInUri().identifier().getText()
            else:
                text = uri_path_component.getText()
            return underline_to_upper_camel_case(text)

        return ''.join(map(uri_path_component_to_text, uri_context.uriPathComponent()))

    @staticmethod
    def string_from_string_context(string_context):
        def reduce_string_element_context(so_far, so_good):
            if so_good.escaped() is not None:
                return so_far + so_good.escaped().children[1].getText()
            return so_far + so_good.getText()
        return reduce(reduce_string_element_context, string_context.stringElement(), '')

    def request_url_from_uri(self, uri_context):
        url = 'configuration.baseURLString + ' + self.request_uri_from_uri(uri_context)
        return url

    def request_uri_from_uri(self, uri_context):
        def reduce_uri_path_component(so_far, so_good):
            if isinstance(so_good, HTTPIDL.UriPathComponentContext):
                if so_good.parameterInUri() is not None:
                    return so_far + '\(' + so_good.parameterInUri().identifier().getText() + ')'
                else:
                    return so_far + self.string_from_string_context(so_good.string())
            return so_far + so_good.getText()

        uri = reduce(reduce_uri_path_component, uri_context.children, '"') + '"'
        return uri

    def generate_request_send(self, request_context, message_name):
        response_name = self.response_name_from_message(request_context.method().getText(), message_name)
        self.write_blank_lines(1)
        self.write_line('@discardableResult')
        self.write_line('func send(completion: @escaping (' + response_name + ') -> Void, errorHandler: @escaping ('
                                                                                'HIError) -> Void) -> RequestFuture<'
                        + response_name + '> {')
        self.push_indent()
        self.write_line('let future: RequestFuture<' + response_name + '> = client.send(self)')
        self.write_line('future.responseHandler = completion')
        self.write_line('future.errorHandler = errorHandler')
        self.write_line('return future')
        self.pop_indent()
        self.write_line('}')

        self.write_blank_lines(1)
        self.write_line('@discardableResult')
        self.write_line('func send(rawResponseHandler: @escaping (HTTPResponse) -> Void, errorHandler: '
                        '@escaping (HIError) -> Void) -> RequestFuture<HTTPResponse> {')
        self.push_indent()
        self.write_line('let future = client.send(self)')
        self.write_line('future.responseHandler = rawResponseHandler')
        self.write_line('future.errorHandler = errorHandler')
        self.write_line('return future')
        self.pop_indent()
        self.write_line('}')

    def generate_request_user_defined_member_var(self, request_context):
        single_param = request_context.structBody().singleParameter()
        param_maps = request_context.structBody().parameterMap()
        if single_param is not None:
            self.generate_request_single_param_member_var(request_context)
        elif len(param_maps) != 0:
            self.generate_request_param_map_member_var(request_context)
        else:
            self.generate_request_no_param_member_var()

    def generate_request_no_param_member_var(self):
        self.write_line('var content: %s?' % httpidl_content_type)

    def generate_request_single_param_member_var(self, request_context):
        single_param = request_context.structBody().singleParameter()
        self.write_line('var content: %s? {' % httpidl_content_type)
        self.push_indent()
        self.write_line('if let body = body {')
        self.push_indent()
        generic_type = single_param.paramType().genericType()
        if generic_type is not None:
            array_type = generic_type.arrayGenericParam()
            dict_type = generic_type.dictGenericParam()
            if array_type is not None:
                self.generate_array_from_req_assignment(array_type, 'body')
            else:
                self.generate_dict_from_req_assignment(dict_type, 'body')
            self.write_line('return tmp')
        else:
            self.write_line('return body.as%s()' % httpidl_content_type)
        self.pop_indent()
        self.write_line('} else {')
        self.push_indent()
        self.write_line(' return .dictionary(value: [:])')
        self.pop_indent()
        self.write_line('}')
        self.pop_indent()
        self.write_line('}')

    def generate_request_param_map_member_var(self, request_context):
        parameter_maps = request_context.structBody().parameterMap()
        self.write_line('var content: %s? {' % httpidl_content_type)
        self.push_indent()
        self.write_line('var result = [String: %s]()' % httpidl_content_type)
        for parameter_map in parameter_maps:
            param_value = parameter_map.value()
            param_value_name = self.string_from_string_context(param_value.string()) if param_value is not None else parameter_map.key().getText()
            self.write_line('if let tmp = ' + parameter_map.key().getText() + ' {')
            self.push_indent()
            generic_type = parameter_map.paramType().genericType()
            if generic_type is not None:
                array_type = generic_type.arrayGenericParam()
                dict_type = generic_type.dictGenericParam()
                if array_type is not None:
                    self.generate_array_from_req_assignment(array_type, 'tmp')
                else:
                    self.generate_dict_from_req_assignment(dict_type, 'tmp')
                self.write_line('result["'
                                + param_value_name + '"] = tmp')
            else:
                self.write_line('result["'
                                + param_value_name + '"] = tmp.as%s()' % httpidl_content_type)
            self.pop_indent()
            self.write_line('}')
        self.write_line('return .dictionary(value: result)')
        self.pop_indent()
        self.write_line('}')

    def generate_array_from_req_assignment(self, array_context, container_name):
        array_element_type = array_context.paramType()
        nested_type = array_element_type.genericType()
        if nested_type is not None:
            self.write_line(
                'let tmp = ' + container_name + '.reduce(.array(value: []), { (soFar, soGood) -> RequestContent in')
            self.push_indent()
            self.write_line('guard case .array(var content) = soFar else {')
            self.push_indent()
            self.write_line('return soFar')
            self.pop_indent()
            self.write_line('}')
            array_type = nested_type.arrayGenericParam()
            dict_type = nested_type.dictGenericParam()
            if array_type is not None:
                self.generate_array_from_req_assignment(array_type, 'soGood')
            else:
                self.generate_dict_from_req_assignment(dict_type, 'soGood')
            self.write_line('content.append(tmp)')
            self.write_line('return .array(value: content)')
            self.pop_indent()
            self.write_line('})')
        else:
            self.write_line('let tmp = ' + container_name + '.asRequestContent()')

    def generate_dict_from_req_assignment(self, dict_context, container_name):
        value_type = dict_context.paramType()
        nested_value_type = value_type.genericType()
        if nested_value_type is not None:
            self.write_line(
                'let tmp = ' + container_name + '.reduce(.dictionary(value: [:]), { (soFar, soGood) -> RequestContent '
                                                'in')
            self.push_indent()
            self.write_line('guard case .dictionary(var content) = soFar else {')
            self.push_indent()
            self.write_line('return soFar')
            self.pop_indent()
            self.write_line('}')
            array_type = nested_value_type.arrayGenericParam()
            dict_type = nested_value_type.dictGenericParam()
            if array_type is not None:
                self.generate_array_from_req_assignment(array_type, 'soGood.value')
            else:
                self.generate_dict_from_req_assignment(dict_type, 'soGood.value')
            self.write_line('content[soGood.key.asHTTPParamterKey()] = tmp')
            self.write_line('return .dictionary(value: content)')
            self.pop_indent()
            self.write_line('})')
        else:
            self.write_line('let tmp = ' + container_name + '.asRequestContent()')

    def generate_request_init_and_default_member_var(self, request_context, uri_context):
        self.write_blank_lines(1)

        def filter_param_in_uri(uri_path_component):
            return uri_path_component.parameterInUri() is not None

        params_in_uri = filter(filter_param_in_uri, uri_context.uriPathComponent())
        for param_in_uri in params_in_uri:
            self.write_line('let ' + param_in_uri.parameterInUri().identifier().getText() + ': String')
        self.write_line('var method: String = "' + request_context.method().getText() + '"')
        self.write_line('private var _configuration: Configuration?')
        self.write_line('var configuration: Configuration {')
        self.push_indent()
        self.write_line('get {')
        self.push_indent()
        self.write_line('guard let config = _configuration else {')
        self.push_indent()
        self.write_line('return client.configuration')
        self.pop_indent()
        self.write_line('}')
        self.write_line('return config')
        self.pop_indent()
        self.write_line('}')
        self.write_line('set {')
        self.push_indent()
        self.write_line('_configuration = newValue')
        self.pop_indent()
        self.write_line('}')
        self.pop_indent()
        self.write_line('}')
        self.write_line('var client: Client = BaseClient.shared')
        self.write_line('var uri: String {')
        self.push_indent()
        self.write_line('return ' + self.request_uri_from_uri(uri_context))
        self.pop_indent()
        self.write_line('}')
        self.write_blank_lines(1)
        single_param = request_context.structBody().singleParameter()
        if single_param is not None:
            self.write_line('var body: ' + swift_type_name(single_param.paramType()) + '?')
        else:
            param_maps = request_context.structBody().parameterMap()
            for param_map in param_maps:
                param_type = param_map.paramType()
                self.write_line('var ' + param_map.key().getText() + ': ' + swift_type_name(param_type) + '?')
            self.write_blank_lines(1)
            for param_map in param_maps:
                param_value_name = self.string_from_string_context(
                    param_map.value().string()) if param_map.value() is not None else param_map.key().getText()
                self.write_line('let keyOf' + underline_to_upper_camel_case(param_map.key().getText()) + ' = "'
                            + param_value_name + '"')
        init_param_list = ', '.join(
            map(lambda p: p.parameterInUri().identifier().getText() + ': String', params_in_uri))
        if len(init_param_list) != 0:
            self.write_blank_lines(1)
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
        self.write_line('class ' + request_name + ': Request {')
        self.push_indent()
        self.generate_request_init_and_default_member_var(request_context, uri_context)
        self.generate_request_user_defined_member_var(request_context)
        self.generate_request_send(request_context, message_name)
        self.pop_indent()
        self.write_line('}')

    @staticmethod
    def response_name_from_message(message_method, message_name):
        response_name = message_method.title() + message_name + 'Response'
        return response_name

    def generate_response_single_param_init_and_member_var(self, response_context):
        single_param = response_context.structBody().singleParameter()
        self.write_line('let body: ' + swift_type_name(single_param.paramType()) + '?')
        self.write_line('let rawResponse: HTTPResponse')
        self.write_line('init(content: ResponseContent?, rawResponse: HTTPResponse) throws {')
        self.push_indent()
        self.write_line('self.rawResponse = rawResponse')
        self.write_line('guard let content = content else {')
        self.push_indent()
        self.write_line('self.body = nil')
        self.write_line('return')
        self.pop_indent()
        self.write_line('}')
        param_type = single_param.paramType()
        generic_type = param_type.genericType()
        if generic_type is not None:
            array_type = generic_type.arrayGenericParam()
            dict_type = generic_type.dictGenericParam()
            if array_type is not None:
                self.generate_array_from_resp_assignment(array_type, 'body')
            elif dict_type is not None:
                self.generate_dict_from_resp_assignment(dict_type, 'body')
            self.write_line('self.body = body')
        else:
            self.write_line('self.body = ' + swift_type_name(
                param_type) + '(content: content)')
        self.pop_indent()
        self.write_line('}')

    def generate_response_param_map_init_and_member_var(self, response_context):
        param_maps = response_context.structBody().parameterMap()
        for param_map in param_maps:
            param_type = param_map.paramType()
            self.write_line('let ' + param_map.key().getText() + ': ' + swift_type_name(param_type) + '?')
        self.write_line('let rawResponse: HTTPResponse')
        self.write_line('init(content: ResponseContent?, rawResponse: HTTPResponse) throws {')
        self.push_indent()
        self.write_line('self.rawResponse = rawResponse')
        self.write_line('guard let content = content, case .dictionary(let value) = content else {')
        self.push_indent()
        for param_map in param_maps:
            self.write_line('self.' + param_map.key().getText() + ' = nil')
        self.write_line('return')
        self.pop_indent()
        self.write_line('}')
        for param_map in param_maps:
            param_type = param_map.paramType()
            generic_type = param_type.genericType()
            param_value_name = self.string_from_string_context(
                param_map.value().string()) if param_map.value() is not None else param_map.key().getText()
            if generic_type is not None:
                array_type = generic_type.arrayGenericParam()
                dict_type = generic_type.dictGenericParam()
                self.write_line('if let content = value["' + param_value_name + '"] {')
                self.push_indent()
                if array_type is not None:
                    self.generate_array_from_resp_assignment(array_type, param_map.key().getText())
                elif dict_type is not None:
                    self.generate_dict_from_resp_assignment(dict_type, param_map.key().getText())
                self.write_line('self.' + param_map.key().getText() + ' = ' + param_map.key().getText())
                self.pop_indent()
                self.write_line('} else {')
                self.push_indent()
                self.write_line('self.' + param_map.key().getText() + ' = nil')
                self.pop_indent()
                self.write_line('}')
            else:
                self.write_line('self.' + param_map.key().getText() + ' = ' + swift_type_name(
                    param_type) + '(content: value["' + param_value_name + '"])')
        self.pop_indent()
        self.write_line('}')

    def generate_response_no_param_init_and_member_var(self):
        self.write_line('let rawResponse: HTTPResponse')
        self.write_line('init(content: ResponseContent?, rawResponse: HTTPResponse) throws {')
        self.push_indent()
        self.write_line('self.rawResponse = rawResponse')
        self.pop_indent()
        self.write_line('}')

    def generate_response_init_and_member_var(self, response_context):
        self.write_blank_lines(1)
        single_param = response_context.structBody().singleParameter()
        param_maps = response_context.structBody().parameterMap()
        if single_param is not None:
            self.generate_response_single_param_init_and_member_var(response_context)
        elif len(param_maps) != 0:
            self.generate_response_param_map_init_and_member_var(response_context)
        else:
            self.generate_response_no_param_init_and_member_var()

    def generate_response(self, response_context, message_name):
        self.write_blank_lines(1)
        response_name = self.response_name_from_message(response_context.method().getText(), message_name)
        self.write_line('struct ' + response_name + ': Response {')
        self.push_indent()
        self.generate_response_init_and_member_var(response_context)
        self.pop_indent()
        self.write_line('}')

    def generate_message(self, message_context):
        uri = message_context.uri()
        message_name = self.message_name(message_context)
        requests = message_context.request()
        for request in requests:
            self.generate_request(request, message_name, uri)

        responses = message_context.response()
        for response in responses:
            self.generate_response(response, message_name)

    def generate_struct_member_var(self, struct_context):
        self.write_blank_lines(1)
        single_param = struct_context.structBody().singleParameter()
        param_maps = struct_context.structBody().parameterMap()
        if single_param is not None:
            self.write_line('var body: ' + swift_type_name(single_param.paramType()) + '?')
        else:
            for param_map in param_maps:
                param_type = param_map.paramType()
                self.write_line('var ' + param_map.key().getText() + ': ' + swift_type_name(param_type) + '?')

    def generate_struct_response_content_impl(self, struct_context):
        single_param = struct_context.structBody().singleParameter()
        param_maps = struct_context.structBody().parameterMap()
        if single_param is not None:
            self.generate_struct_single_param_response_content_impl(struct_context)
        elif len(param_maps) != 0:
            self.generate_struct_param_map_response_content_impl(struct_context)
        else:
            self.generate_struct_no_param_response_content_impl(struct_context)

    def generate_struct_no_param_response_content_impl(self, struct_context):
        self.write_line('extension %s: ResponseContentConvertible {' % struct_context.structName().getText())
        self.push_indent()
        self.write_blank_lines(1)
        self.write_line('init?(content: ResponseContent?) {')
        self.push_indent()
        self.write_line('guard let content = content else {')
        self.push_indent()
        self.write_line('return nil')
        self.pop_indent()
        self.write_line('}')
        self.pop_indent()
        self.write_line('}')

    def generate_struct_single_param_response_content_impl(self, struct_context):
        single_param = struct_context.structBody().singleParameter()
        self.write_line('extension %s: ResponseContentConvertible {' % struct_context.structName().getText())
        self.push_indent()
        self.write_blank_lines(1)
        self.write_line('init?(content: ResponseContent?) {')
        self.push_indent()
        self.write_line('guard let content = content else {')
        self.push_indent()
        self.write_line('return nil')
        self.pop_indent()
        self.write_line('}')
        param_type = single_param.paramType()
        generic_type = param_type.genericType()
        if generic_type is not None:
            array_type = generic_type.arrayGenericParam()
            dict_type = generic_type.dictGenericParam()
            if array_type is not None:
                self.generate_array_from_resp_assignment(array_type, 'body')
            elif dict_type is not None:
                self.generate_dict_from_resp_assignment(dict_type, 'body')
            self.write_line('self.body = body')
        else:
            self.write_line('self.body = ' + swift_type_name(
                param_type) + '(content: content)')
        self.pop_indent()
        self.write_line('}')
        self.pop_indent()
        self.write_line('}')

    def generate_struct_param_map_response_content_impl(self, struct_context):
        param_maps = struct_context.structBody().parameterMap()
        self.write_line('extension %s: ResponseContentConvertible {' % struct_context.structName().getText())
        self.push_indent()
        self.write_blank_lines(1)
        self.write_line('init?(content: ResponseContent?) {')
        self.push_indent()
        self.write_line('guard let content = content, case .dictionary(let value) = content else {')
        self.push_indent()
        self.write_line('return nil')
        self.pop_indent()
        self.write_line('}')
        for param_map in param_maps:
            param_type = param_map.paramType()
            generic_type = param_type.genericType()
            param_value = param_map.value()
            param_value_name = self.string_from_string_context(param_value.string()) if param_value is not None else param_map.key().getText()
            if generic_type is not None:
                array_type = generic_type.arrayGenericParam()
                dict_type = generic_type.dictGenericParam()
                self.write_line('if let content = value["' + param_value_name + '"] {')
                self.push_indent()
                if array_type is not None:
                    self.generate_array_from_resp_assignment(array_type, param_map.key().getText())
                elif dict_type is not None:
                    self.generate_dict_from_resp_assignment(dict_type, param_map.key().getText())
                self.write_line('self.' + param_map.key().getText() + ' = ' + param_map.key().getText())
                self.pop_indent()
                self.write_line('} else {')
                self.push_indent()
                self.write_line('self.' + param_map.key().getText() + ' = nil')
                self.pop_indent()
                self.write_line('}')
            else:
                self.write_line('self.' + param_map.key().getText() + ' = ' + swift_type_name(
                    param_type) + '(content: value["' + param_value_name + '"])')
        self.pop_indent()
        self.write_line('}')
        self.pop_indent()
        self.write_line('}')

    def generate_array_from_resp_assignment(self, array_context, container_name):
        array_element_type = array_context.paramType()
        nested_type = array_element_type.genericType()
        type_name = '[' + swift_type_name(array_element_type) + ']'
        if nested_type is not None:
            self.write_line('var ' + container_name + ': ' + type_name + '? = nil')
            self.write_line('if case .array(let value) = content {')
            self.push_indent()
            self.write_line(container_name + ' = ' + type_name + '()')
            self.write_line('value.forEach { (content) in')
            self.push_indent()
            array_type = nested_type.arrayGenericParam()
            dict_type = nested_type.dictGenericParam()
            if array_type is not None:
                self.generate_array_from_resp_assignment(array_type, '_' + container_name)
            else:
                self.generate_dict_from_resp_assignment(dict_type, '_' + container_name)
            self.write_line('if let tmp = ' + '_' + container_name + ' {')
            self.push_indent()
            self.write_line(container_name + '!.append(tmp)')
            self.pop_indent()
            self.write_line('}')
            self.pop_indent()
            self.write_line('}')
            self.pop_indent()
            self.write_line('}')
        else:
            self.write_line('let ' + container_name + ' = ' + type_name + '(content: content)')

    def generate_dict_from_resp_assignment(self, dict_context, container_name):
        value_type = dict_context.paramType()
        key_type = dict_context.baseType()
        nested_value_type = value_type.genericType()
        type_name = '[' + swift_base_type_name_from_idl_base_type(key_type.getText()) + ': ' + swift_type_name(
            value_type) + ']'
        if nested_value_type is not None:
            self.write_line('var ' + container_name + ': ' + type_name + '? = nil')
            self.write_line('if case .dictionary(let value) = content {')
            self.push_indent()
            self.write_line(container_name + ' = ' + type_name + '()')
            self.write_line('value.forEach { (kv) in')
            self.push_indent()
            self.write_line('let content = kv.value')
            array_type = nested_value_type.arrayGenericParam()
            dict_type = nested_value_type.dictGenericParam()
            if array_type is not None:
                self.generate_array_from_resp_assignment(array_type, '_' + container_name)
            else:
                self.generate_dict_from_resp_assignment(dict_type, '_' + container_name)
            self.write_line('if let tmp = ' + '_' + container_name + ' {')
            self.push_indent()
            self.write_line(container_name + '!.updateValue(tmp, forKey: kv.key)')
            self.pop_indent()
            self.write_line('}')
            self.pop_indent()
            self.write_line('}')
            self.pop_indent()
            self.write_line('}')
        else:
            self.write_line('let ' + container_name + ' = ' + type_name + '(content: content)')

    def generate_struct_request_content_impl(self, struct_context):
        single_param = struct_context.structBody().singleParameter()
        param_maps = struct_context.structBody().parameterMap()
        if single_param is not None:
            self.generate_struct_single_param_request_content_impl(struct_context)
        elif len(param_maps) != 0:
            self.generate_struct_param_map_request_content_impl(struct_context)
        else:
            self.generate_struct_no_param_request_content_impl(struct_context)

    def generate_struct_no_param_request_content_impl(self, struct_context):
        self.write_line('extension %s: RequestContentConvertible {' % struct_context.structName().getText())
        self.push_indent()
        self.write_blank_lines(1)
        self.write_line('func asRequestContent() -> %s {' % httpidl_content_type)
        self.push_indent()
        self.write_line('return .dictionary(value: [:])')
        self.pop_indent()
        self.write_line('}')
        self.pop_indent()
        self.write_line('}')

    def generate_struct_single_param_request_content_impl(self, struct_context):
        single_param = struct_context.structBody().singleParameter()
        self.write_line('extension %s: RequestContentConvertible {' % struct_context.structName().getText())
        self.push_indent()
        self.write_blank_lines(1)
        self.write_line('func asRequestContent() -> %s {' % httpidl_content_type)
        self.push_indent()
        self.write_line('if let body = body {')
        self.push_indent()
        generic_type = single_param.paramType().genericType()
        if generic_type is not None:
            array_type = generic_type.arrayGenericParam()
            dict_type = generic_type.dictGenericParam()
            if array_type is not None:
                self.generate_array_from_req_assignment(array_type, 'body')
            else:
                self.generate_dict_from_req_assignment(dict_type, 'body')
            self.write_line('return tmp')
        else:
            self.write_line('return body.as%s()' % httpidl_content_type)
        self.pop_indent()
        self.write_line('} else {')
        self.push_indent()
        self.write_line('return .dictionary(value: [:])')
        self.pop_indent()
        self.write_line('}')
        self.pop_indent()
        self.write_line('}')
        self.pop_indent()
        self.write_line('}')

    def generate_struct_param_map_request_content_impl(self, struct_context):
        parameter_maps = struct_context.structBody().parameterMap()
        self.write_line('extension %s: RequestContentConvertible {' % struct_context.structName().getText())
        self.push_indent()
        self.write_blank_lines(1)
        self.write_line('func asRequestContent() -> %s {' % httpidl_content_type)
        self.push_indent()
        self.write_line('var result = [String: %s]()' % httpidl_content_type)
        for parameter_map in parameter_maps:
            param_value = parameter_map.value()
            param_value_name = self.string_from_string_context(
                param_value.string()) if param_value is not None else parameter_map.key().getText()
            self.write_line('if let tmp = ' + parameter_map.key().getText() + ' {')
            self.push_indent()
            generic_type = parameter_map.paramType().genericType()
            if generic_type is not None:
                array_type = generic_type.arrayGenericParam()
                dict_type = generic_type.dictGenericParam()
                if array_type is not None:
                    self.generate_array_from_req_assignment(array_type, 'tmp')
                else:
                    self.generate_dict_from_req_assignment(dict_type, 'tmp')
                self.write_line('result["'
                                + param_value_name + '"] = tmp')
            else:
                self.write_line('result["'
                                + param_value_name + '"] = tmp.as%s()' % httpidl_content_type)
            self.pop_indent()
            self.write_line('}')
        self.write_line('return .dictionary(value: result)')
        self.pop_indent()
        self.write_line('}')
        self.pop_indent()
        self.write_line('}')

    def generate_struct(self, struct_context):
        self.write_blank_lines(1)
        self.write_line('struct ' + struct_context.structName().getText() + ' {')
        self.push_indent()
        self.generate_struct_member_var(struct_context)
        self.pop_indent()
        self.write_line('}')
        if self.dependency_analyzer.is_type_refered_by_response(struct_context.structName().getText()):
            self.write_blank_lines(1)
            self.generate_struct_response_content_impl(struct_context)
        if self.dependency_analyzer.is_type_refered_by_request(struct_context.structName().getText()):
            self.write_blank_lines(1)
            self.generate_struct_request_content_impl(struct_context)

    def generate_entry(self, entry_context):
        self.write_line('//这是自动生成的代码，不要改动，否则你的改动会被覆盖！！！！！！！')
        self.write_blank_lines(1)
        self.write_line('import Foundation')
        self.write_line('import HTTPIDL')
        structs = entry_context.struct()
        for struct in structs:
            self.generate_struct(struct)
        messages = entry_context.message()
        for message in messages:
            self.generate_message(message)
