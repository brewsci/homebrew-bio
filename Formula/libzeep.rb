class Libzeep < Formula
  desc "Web application framework written in C++"
  homepage "https://github.com/mhekkel/libzeep"
  url "https://github.com/mhekkel/libzeep/archive/refs/tags/v6.0.13.tar.gz"
  sha256 "4d304986b39a54975bae263f8de9e1ecedd8e2b05bee7a9b637225dae63a6e56"
  license "BSL-1.0"
  head "https://github.com/mhekkel/libzeep.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, monterey:     "a3dea66429a4da315f1951c45b6febd841bb3dbfda0e4727cff69fea59e5ca66"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8712c2089d5d8d8beeb8858a42c987790bf6e2569ba1022c44843501358cd50a"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "howard-hinnant-date"

  resource "libmcfp" do
    url "https://github.com/mhekkel/libmcfp/archive/refs/tags/v1.3.3.tar.gz"
    sha256 "d35e83e660c3cb443d20246fea39e78d2a11faebe3205ab838614f0280c308d0"
  end

  def install
    resource("libmcfp").stage do
      system "cmake", "-S", ".", "-B", "build",
                      *std_cmake_args(install_prefix: prefix/"libmcfp")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
    inreplace "CMakeLists.txt", "date 3.0.1 QUIET NAMES date", "date 3.0.0 REQUIRED NAMES date"
    date_cmake_prefix = Formula["howard-hinnant-date"].opt_lib/"cmake"
    system "cmake", "-S", ".", "-B", "build",
                  "-Dlibmcfp_DIR=#{prefix/"libmcfp/lib/cmake/libmcfp"}",
                  "-DCMAKE_MODULE_PATH=#{date_cmake_prefix}",
                  "-DCMAKE_BUILD_TYPE=Release",
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
    system ENV.cxx, "test.cpp",  "-o", "test",
                    "-std=c++17", "-I#{include}",
                    "-I#{Formula["boost"].opt_include}",
                    "-L#{lib}", "-lzeep"
    assert_match "server is not running", shell_output("./test status 2>&1", 1)
  end
end
