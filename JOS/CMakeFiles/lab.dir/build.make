# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.15

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/Cellar/cmake/3.15.2/bin/cmake

# The command to remove a file.
RM = /usr/local/Cellar/cmake/3.15.2/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/xujingnan/GitHub/lab

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/xujingnan/GitHub/lab

# Include any dependencies generated for this target.
include CMakeFiles/lab.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/lab.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/lab.dir/flags.make

CMakeFiles/lab.dir/boot/main.c.o: CMakeFiles/lab.dir/flags.make
CMakeFiles/lab.dir/boot/main.c.o: boot/main.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/xujingnan/GitHub/lab/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/lab.dir/boot/main.c.o"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/lab.dir/boot/main.c.o   -c /Users/xujingnan/GitHub/lab/boot/main.c

CMakeFiles/lab.dir/boot/main.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/lab.dir/boot/main.c.i"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/xujingnan/GitHub/lab/boot/main.c > CMakeFiles/lab.dir/boot/main.c.i

CMakeFiles/lab.dir/boot/main.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/lab.dir/boot/main.c.s"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/xujingnan/GitHub/lab/boot/main.c -o CMakeFiles/lab.dir/boot/main.c.s

# Object files for target lab
lab_OBJECTS = \
"CMakeFiles/lab.dir/boot/main.c.o"

# External object files for target lab
lab_EXTERNAL_OBJECTS =

lab: CMakeFiles/lab.dir/boot/main.c.o
lab: CMakeFiles/lab.dir/build.make
lab: CMakeFiles/lab.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/xujingnan/GitHub/lab/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable lab"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/lab.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/lab.dir/build: lab

.PHONY : CMakeFiles/lab.dir/build

CMakeFiles/lab.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/lab.dir/cmake_clean.cmake
.PHONY : CMakeFiles/lab.dir/clean

CMakeFiles/lab.dir/depend:
	cd /Users/xujingnan/GitHub/lab && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/xujingnan/GitHub/lab /Users/xujingnan/GitHub/lab /Users/xujingnan/GitHub/lab /Users/xujingnan/GitHub/lab /Users/xujingnan/GitHub/lab/CMakeFiles/lab.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/lab.dir/depend

