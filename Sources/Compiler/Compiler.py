import os
import sys

from antlr4.FileStream import FileStream
from SwiftCodeGen import Swift3CodeGenerator
from antlr4 import CommonTokenStream
from antlr4 import InputStream
from antlr4.error.ErrorListener import ErrorListener
from Parser.HTTPIDL import HTTPIDL
from Parser.HTTPIDLLexer import HTTPIDLLexer


class HTTPIDLErrorListener(ErrorListener):
    def syntaxError(self, recognizer, offending_symbol, line, column, msg, e):
        print 'parser failed!!!'
        print 'error near line ' + str(line) + ':' + str(column) + ' reason:( ' + msg + ' )'
        sys.exit(1)


idl_file_extension = '.http'


class HTTPIDLCompiler:
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
        parse_tree = self.parse_tree_from_file(input_file_path, 'utf-8', HTTPIDLErrorListener())
        input_file_name = os.path.splitext(os.path.basename(input_file_path))[0]
        generator = Swift3CodeGenerator(input_file_name, output_directory_path)
        generator.generate_entry(parse_tree)

    @staticmethod
    def all_files(path):
        files = []
        for f in os.listdir(path):
            file_path = os.path.join(path, f)
            if os.path.isfile(file_path) and file_path.endswith(idl_file_extension):
                print "find compile target: " + file_path
                files.append(file_path)
        return files

    @staticmethod
    def parse_tree_from_idl(input_idl, error_listener):
        input_stream = InputStream(input_idl)
        lexer = HTTPIDLLexer(input_stream)
        stream = CommonTokenStream(lexer)
        parser = HTTPIDL(stream)
        parser.addErrorListener(error_listener)
        tree = parser.entry()
        return tree

    @staticmethod
    def parse_tree_from_file(file_name, encode, error_listener):
        input_stream = FileStream(file_name, encode)
        lexer = HTTPIDLLexer(input_stream)
        stream = CommonTokenStream(lexer)
        parser = HTTPIDL(stream)
        parser.addErrorListener(error_listener)
        tree = parser.entry()
        return tree
