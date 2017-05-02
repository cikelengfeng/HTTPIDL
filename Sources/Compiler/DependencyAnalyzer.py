# coding=utf-8

request_referer = '0'
response_referer = '1'

class DependencyAnalyzer:
    def __init__(self, parse_trees):
        self.parse_trees = parse_trees
        self.dependency = {}


    def prepare(self):
        requests = []
        responses = []
        structs = []
        for parse_tree in self.parse_trees:
            for msg in parse_tree.message():
                if msg.request() is not None:
                    requests += msg.request()
                if msg.response() is not None:
                    responses += msg.response()
            for stct in parse_tree.struct():
                structs.append(stct)
        for req in requests:
            parameters = req.structBody().parameterMap()
            for parameter in parameters:
                referees = self.referees_from_parameter_context(parameter.paramType())
                self.add_refer(referees, request_referer)
        for resp in responses:
            parameters = resp.structBody().parameterMap()
            for parameter in parameters:
                referees = self.referees_from_parameter_context(parameter.paramType())
                self.add_refer(referees, response_referer)
        for stct in structs:
            parameters = stct.structBody().parameterMap()
            for parameter in parameters:
                referees = self.referees_from_parameter_context(parameter.paramType())
                referer = stct.structName().getText()
                self.add_refer(referees, referer)

    def referees_from_parameter_context(self, paramType_context):
        if paramType_context.baseType() is not None:
            return [paramType_context.baseType().getText()]
        genericType = paramType_context.genericType()
        if genericType.arrayGenericParam() is not None:
            return self.referees_from_parameter_context(genericType.arrayGenericParam().paramType())
        if genericType.dictGenericParam() is not None:
            ret = [genericType.dictGenericParam().baseType().getText()]
            ret += self.referees_from_parameter_context(genericType.dictGenericParam().paramType())
            return ret
        return []

    def add_refer(self, referees, referer):
        for referee in referees:
            exist_referers = self.dependency.get(referee, set())
            exist_referers.add(referer)
            self.dependency[referee] = exist_referers

    def is_type_refered_by_request(self, type_name):
        direct_referers = self.dependency.get(type_name, set())
        if len(direct_referers) == 0:
            # print type_name + ' has no direct request refer'
            return False
        for refer in direct_referers:
            if refer is request_referer:
                # print type_name + ' is direct refered by request'
                return True
            indirect = self.is_type_refered_by_request(refer)
            if indirect:
                return True
        return False

    def is_type_refered_by_response(self, type_name):
        direct_referers = self.dependency.get(type_name, set())
        if len(direct_referers) == 0:
            # print type_name + ' has no direct response refer'
            return False
        for refer in direct_referers:
            if refer is response_referer:
                # print type_name + ' is direct refered by ' + response_referer
                return True
            indirect = self.is_type_refered_by_response(refer)
            if indirect:
                return True
        return False