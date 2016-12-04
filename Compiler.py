import os
import sys

from SwiftCodeGen import AlamofireCodeGenerator
from antlr4 import CommonTokenStream
from antlr4 import InputStream
from antlr4.error.ErrorListener import ErrorListener
from HJIDLParser.EverphotoIDL import EverphotoIDL
from HJIDLParser.EverphotoIDLLexer import EverphotoIDLLexer


class HTTPIDLErrorListener(ErrorListener):
    def syntaxError(self, recognizer, offending_symbol, line, column, msg, e):
        print 'parser failed!!!'
        print 'error near line ' + str(line) + ':' + str(column) + ' reason:( ' + msg + ' )'
        sys.exit(1)


class HJCompiler:
    def __init__(self):
        pass

    def assemble_file(self, input_file_paths, output_directory_path):
        for input_file_path in input_file_paths:
            print 'start compile ' + input_file_path
            self.compile(input_file_path, output_directory_path)

    def assemble_dir(self, input_directory_path, output_directory_path):
        input_file_paths = self.all_files(input_directory_path)
        self.assemble_file(input_file_paths, output_directory_path)

    def compile(self, input_file_path, output_directory_path):
        with open(input_file_path, 'r') as input_file:
            idl = ''.join(input_file.readlines())
        # print 'compile idl:'
        # print idl
        parse_tree = self.parse_tree_from_idl(idl, HTTPIDLErrorListener())
        input_file_name = os.path.splitext(os.path.basename(input_file_path))[0]
        generator = AlamofireCodeGenerator(input_file_name, output_directory_path)
        generator.generate_entry(parse_tree)

    @staticmethod
    def all_files(path):
        hjidl_files = []
        for f in os.listdir(path):
            file_path = os.path.join(path, f)
            if os.path.isfile(file_path) and file_path.endswith('.hjidl'):
                print "find compile target: " + file_path
                hjidl_files.append(file_path)
        return hjidl_files

    @staticmethod
    def parse_tree_from_idl(input_idl, error_listener):
        input_stream = InputStream(input_idl)
        lexer = EverphotoIDLLexer(input_stream)
        stream = CommonTokenStream(lexer)
        parser = EverphotoIDL(stream)
        parser.addErrorListener(error_listener)
        tree = parser.entry()
        return tree
