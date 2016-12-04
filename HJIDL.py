# coding=utf-8
"""HTTP-JSON IDL.

Usage:
  HJIDL.py [-d inputDirectory| -f inputFile] -o outputDirectory
  HJIDL.py (-h | --help)
  HJIDL.py --version

Options:
  -h --help             Show this screen.
  -d inputDirectory     扫描并编译文件夹内所有.hjidl文件
  -f inputFile          编译指定文件
  -o outputDirectory    输出文件夹


"""
from docopt import docopt

from Compiler import HJCompiler

if __name__ == '__main__':
    arguments = docopt(__doc__, version='0.1.0')
    print(arguments)
    output_directory_path = arguments['-o']
    compiler = HJCompiler()
    if '-d' in arguments:
        input_directory_path = arguments['-d']
        compiler.assemble_dir(input_directory_path, output_directory_path)
    elif '-f' in arguments:
        input_file_paths = arguments['-f']
        compiler.assemble_file(input_file_paths, output_directory_path)

