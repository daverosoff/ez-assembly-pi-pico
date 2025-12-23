cmake_minimum_required(VERSION 3.13)

# Pull in SDK (everything is already in the environment)
include($ENV{PICO_SDK_PATH}/external/pico_sdk_import.cmake)

project(assembly_lab C CXX ASM)
pico_sdk_init()

# This is the line they care about:
add_executable(main_task
    main.S
)

# Pull in standard libraries
target_link_libraries(main_task pico_stdlib)

# Enable usb output, disable uart output
pico_enable_stdio_usb(main_task 1)
pico_enable_stdio_uart(main_task 0)

# Create the .uf2 file for dragging and dropping
pico_add_extra_outputs(main_task)
