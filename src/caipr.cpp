#include <iostream>
#include <string_view>

#ifndef CAIPR_VERSION
#error "CAIPR_VERSION must be defined"
#endif

namespace {

constexpr std::string_view version{CAIPR_VERSION};

void print_version()
{
    std::cout << "caipr " << version << '\n';
}

} // namespace

int main(int argc, char* argv[])
{
    if (argc > 2) {
        std::cerr << "caipr: expected at most one argument; usage: caipr [--version]\n";
        return 2;
    }

    if (argc > 1 && std::string_view{argv[1]} != "--version") {
        std::cerr << "caipr: unsupported option '" << argv[1] << "'; usage: caipr [--version]\n";
        return 2;
    }

    print_version();
    return 0;
}
