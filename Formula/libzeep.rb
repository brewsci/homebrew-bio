class Libzeep < Formula
  desc "Web application framework written in C++"
  homepage "https://github.com/mhekkel/libzeep"
  url "https://github.com/mhekkel/libzeep/archive/refs/tags/v7.3.2.tar.gz"
  sha256 "e794589ef8aad5bd4d7bf674ca0dfa2a4027b3bcc966496490ba18d8908cd080"
  license "BSL-1.0"
  head "https://github.com/mhekkel/libzeep.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2a5d0bc040b5bcfdf3d6e48d06e3f24167c8303e63f40423adc4c6d2a5657b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e589c65dd923914def1bca945ab595b10bb94b0e0afede7878ae2111c0075bd"
    sha256 cellar: :any_skip_relocation, ventura:       "d3c1d42711c371aa895a2d1279e864242f65a8ceddf795d781f82b4b954052be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afb6e8c7475e6582a18fa7ff983964ef4e9e804344926c3ca09c48edb35eb746"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "howard-hinnant-date"

  # zeem is a required dependency of libzeep 7.3.x and has no Homebrew formula,
  # so build it from source and bundle it into the keg.
  resource "zeem" do
    url "https://github.com/mhekkel/zeem/archive/refs/tags/v2.1.1.tar.gz"
    sha256 "4321aecbdd97f650e3cba062a2ce4f61c4b86f7eaa1d13601638d0174f97e9d3"
  end

  # zeem fetches fast_float via CMake FetchContent; provide the source locally
  # so no network access is required during the build.
  resource "fast_float" do
    url "https://github.com/fastfloat/fast_float/archive/refs/tags/v8.0.2.tar.gz"
    sha256 "e14a33089712b681d74d94e2a11362643bd7d769ae8f7e7caefe955f57f7eacd"
  end

  def install
    fast_float_source = buildpath/"fast_float-src"
    resource("fast_float").stage(fast_float_source)

    # Build and install the bundled zeem dependency. It uses Howard Hinnant's
    # date (found via find_package) and fast_float (provided locally).
    # HOMEBREW_ALLOW_FETCHCONTENT lets CPM consume the local fast_float source
    # instead of downloading it.
    resource("zeem").stage do
      system "cmake", "-S", ".", "-B", "build",
             "-DHOMEBREW_ALLOW_FETCHCONTENT=ON",
             "-DCPM_fast_float_SOURCE=#{fast_float_source}",
             "-DZEEM_BUILD_EXAMPLES=OFF",
             "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
             *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    # macOS 14's libc++ (Xcode 15) lacks P0960 parenthesized aggregate
    # initialization in std::construct_at, so emplace_back on the aggregate
    # lang_score fails to compile. Construct the element explicitly instead.
    inreplace "src/request.cpp",
              "scores.emplace_back(std::move(lang), std::move(region), score, loc);",
              "scores.push_back(lang_score{ std::move(lang), std::move(region), score, loc });"

    # zeem and date are both discoverable via find_package now, so libzeep needs
    # no FetchContent. Build shared so the static zeem is absorbed into libzeep.
    system "cmake", "-S", ".", "-B", "build",
           "-DBUILD_SHARED_LIBS=ON",
           "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
           "-DZEEP_BUILD_EXAMPLES=OFF",
           "-DCMAKE_PREFIX_PATH=#{prefix}",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>

      #include <zeep/http/controller.hpp>
      #include <zeep/http/daemon.hpp>

      namespace zh = zeep::http;

      class hello_controller : public zh::controller
      {
        public:
        /* Specify the root path as prefix, will handle any request URI */
        hello_controller()
          : controller("/")
        {
        }

        bool handle_request([[maybe_unused]] zh::request &req, zh::reply &rep)
        {
          /* Construct a simple reply with status OK (200) and content string */
          rep = zh::reply::stock_reply(zh::ok);
          rep.set_content("Hello", "text/plain");
          return true;
        }
      };

      int main(int argc, char *const argv[])
      {
        using namespace std::literals;

        if (argc != 2)
        {
          std::cout << "No command specified, use of of start, stop, status or reload";
          exit(1);
        }

        // --------------------------------------------------------------------

        std::string command = argv[1];

        zh::daemon server([&]()
          {
          auto s = new zeep::http::server(/*sc*/);

          s->add_controller(new hello_controller());

          return s; },
          "hello-daemon");

        int result;

        if (command == "start")
        {
          std::string address = "127.0.0.1";
          unsigned short port = 10330;
          std::string user = "www-data";
          std::cout << "starting server at http://" << address << ":" << port << "";
          result = server.start(address, port, 1, 16, user);
        }
        else if (command == "stop")
          result = server.stop();
        else if (command == "status")
          result = server.status();
        else if (command == "reload")
          result = server.reload();
        else
        {
          std::clog << "Invalid command";
          result = 1;
        }

        return result;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
           "-std=c++20", "-I#{include}",
           "-I#{formula_opt_include("boost")}",
           "-I#{formula_opt_include("howard-hinnant-date")}",
           "-L#{lib}", "-lzeep"
    assert_match "server is not running", shell_output("./test status 2>&1", 1)
  end
end
