#include <iostream>
#include <string_view>

namespace {

constexpr std::string_view version{CAIPR_VERSION};

void print_usage()
{
    std::cout << "caipr " << version << '\n';
}

} // namespace

int main(int argc, char* argv[])
{
    if (argc > 1 && std::string_view{argv[1]} != "--version") {
        std::cerr << "unsupported option: " << argv[1] << '\n';
        return 2;
    }

    print_usage();
    return 0;
}

