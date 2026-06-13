# Justfile for shell implementations
# Usage: just <recipe>
# Assumes folder structure: shell-cpp/, shell-c/, shell-zig/

# Default: list recipes
default:
    @just --list

# ── C++ ──────────────────────────────────────────────────────────────────────
ABSL_PREFIX := `brew --prefix abseil`

cpp-build:
    c++ -std=c++23 -O2 -Wall -Wextra \
        -I{{ABSL_PREFIX}}/include \
        -L{{ABSL_PREFIX}}/lib \
        -labsl_str_format_internal \
        -o shell-cpp/shell shell-cpp/src/*.cpp

cpp-run: cpp-build
    ./shell-cpp/shell

cpp-asan:
    c++ -std=c++23 -O0 -g -fsanitize=address,undefined -Wall -Wextra \
        -o shell-cpp/shell_asan shell-cpp/src/*.cpp

cpp-run-asan: cpp-asan
    ./shell-cpp/shell_asan

cpp-clean:
    rm -f shell-cpp/shell shell-cpp/shell_asan

# ── C ────────────────────────────────────────────────────────────────────────

c-build:
    cc -std=c11 -O2 -Wall -Wextra -o shell-c/shell shell-c/src/*.c

c-run: c-build
    ./shell-c/shell

c-asan:
    cc -std=c11 -O0 -g -fsanitize=address,undefined -Wall -Wextra \
        -o shell-c/shell_asan shell-c/src/*.c

c-run-asan: c-asan
    ./shell-c/shell_asan

c-clean:
    rm -f shell-c/shell shell-c/shell_asan

# ── Zig ──────────────────────────────────────────────────────────────────────

zig-build:
    cd shell-zig && zig build

zig-run:
    cd shell-zig && zig build run

zig-run-safe:
    cd shell-zig && zig build run -Doptimize=Debug

zig-clean:
    rm -rf shell-zig/zig-out shell-zig/.zig-cache

# ── All ──────────────────────────────────────────────────────────────────────

build-all: cpp-build c-build zig-build

clean-all: cpp-clean c-clean zig-clean
