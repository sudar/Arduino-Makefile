#!/usr/bin/env python

import os
import re
import sys

# Set variables
USER_LIB_PATH = sys.argv[1]
USER_LIBS = [] ;

includeRegex = re.compile("(?<=^\#include\s[\<\"])(.*)(?=\.h[\>\"])", re.DOTALL|re.M)

MAIN_SRCS = [] ;
MAIN_LIBS = [] ;

LIBS_DEPS = [] ;
LIBS_DEPS_STACK = [] ;

# Find local sources .ino, .c or .cpp
for file in os.listdir(os.curdir):
	if file.endswith((".c", ".cpp", ".ino")):
		MAIN_SRCS.append(file)

# Find all USER_LIBS
for path, dirs, files in os.walk(USER_LIB_PATH):
	for d in dirs:
		USER_LIBS.append(d)

# Find MAIN_LIBS included in MAIN_SRCS
for src in MAIN_SRCS:
	currentFile = open(src)
	includes = []

	for line in currentFile:
		match = includeRegex.search(line)
		if match:
			if match.group(1) in USER_LIBS:
				MAIN_LIBS.append(match.group(1))

MAIN_LIBS = list(sorted(MAIN_LIBS))

# Find LIBS_DEPS includes in MAIN_LIBS
for lib in MAIN_LIBS:
	if lib in USER_LIBS:
		currentFile = open(USER_LIB_PATH + "/" + lib + "/" + lib + ".h")

		for line in currentFile:
			match = includeRegex.search(line)
			if match:
				if match.group(1) in USER_LIBS and match.group(1) not in MAIN_LIBS:
					LIBS_DEPS_STACK.append(match.group(1))

LIBS_DEPS_STACK = sorted(set(LIBS_DEPS_STACK))

# Recursively find all dependencies of every libraries in USER_LIB_PATH
while LIBS_DEPS_STACK:
	for lib in LIBS_DEPS_STACK:
		if lib in USER_LIBS:
			currentFile = open(USER_LIB_PATH + "/" + lib + "/" + lib + ".h")

			for line in currentFile:
				match = includeRegex.search(line)
				if match:
					if match.group(1) in USER_LIBS and match.group(1) not in LIBS_DEPS_STACK or match.group(1) in LIBS_DEPS and match.group(1) not in MAIN_LIBS:
						LIBS_DEPS_STACK.append(match.group(1))

				else:
					LIBS_DEPS.append(lib)
					if lib in LIBS_DEPS_STACK:
						LIBS_DEPS_STACK.remove(lib)

	LIBS_DEPS_STACK = sorted(set(LIBS_DEPS_STACK))
	# print(LIBS_DEPS_STACK)

LIBS_DEPS = sorted(set(LIBS_DEPS))

# print("Main libraries: ")
# print(MAIN_LIBS);
# print("")
# print("Dependencies stack: ")
# print(LIBS_DEPS_STACK)
# print("")
# print("Libraries dependencies: ")
# print(LIBS_DEPS);

def outputLibs(libArray):
	for lib in libArray:
		print(lib),
	print("")

print("MAIN_LIBS"),
outputLibs(MAIN_LIBS)

print("LIBS_DEPS"),
outputLibs(LIBS_DEPS)
