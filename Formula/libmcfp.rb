class Libmcfp < Formula
  desc "Header only Library to collect configuration options from command-line arguments"
  homepage "https://github.com/mhekkel/libmcfp/"
  url "https://github.com/mhekkel/libmcfp/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "dcdf3e81601081b2a9e2f2e1bb1ee2a8545190358d5d9bec9158ad70f5ca355e"
  license "BSD-2-Clause"
  head "https://github.com/mhekkel/libmcfp.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b3cb991d4c205436bdb2f98d28ed95216ebe35c10fc5f0bd26ae387934c414d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b3cb991d4c205436bdb2f98d28ed95216ebe35c10fc5f0bd26ae387934c414d"
    sha256 cellar: :any_skip_relocation, ventura:       "4b3cb991d4c205436bdb2f98d28ed95216ebe35c10fc5f0bd26ae387934c414d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92ef6686bdce6d88aaadb293cfac42c737ceb094b866fba7c3940415b11a1d95"
  end

  depends_on "cmake" => :build

  patch :DATA

  def install
    # To use `std::to_chars`
    ENV.prepend "CXXFLAGS", "-mmacosx-version-min=13.3" if OS.mac?

    system "cmake", "-S", ".", "-B", "build",
      "-DCMAKE_CXX_FLAGS=#{ENV.cxxflags}",
      *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <filesystem>

      #include <mcfp/mcfp.hpp>

      int main(int argc, char * const argv[])
      {
        auto &config = mcfp::config::instance();

        // Initialise the config object. This can be done more than once,
        // e.g. when you have different sets of options depending on the
        // first operand.

        config.init(
          // The first parameter is the 'usage' line, used when printing out the options
          "usage: example [options] file",

          // Flag options (not taking a parameter)
          mcfp::make_option("help,h", "Print this help text"),
          mcfp::make_option("verbose,v", "Verbose level, can be specified more than once to increase level"),

          // A couple of options with parameter
          mcfp::make_option<std::string>("config", "Config file to use"),
          mcfp::make_option<std::string>("text", "The text string to echo"),

          // And options with a default parameter
          mcfp::make_option<int>("a", 1, "first parameter for multiplication"),
          mcfp::make_option<float>("b", 2.0f, "second parameter for multiplication"),

          // You can also allow multiple values
          mcfp::make_option<std::vector<std::string>>("c", "Option c, can be specified more than once"),

          // This option is not shown when printing out the options
          mcfp::make_hidden_option("d", "Debug mode")
        );

        // There are two flavors of calls, ones that take an error_code
        // and return the error in that code in case something is wrong.
        // The alternative is calling without an error_code, in which
        // case an exception is thrown when appropriate

        // Parse the command line arguments here

        std::error_code ec;
        config.parse(argc, argv, ec);
        if (ec)
        {
          std::cerr << "Error parsing arguments: " << ec.message() << std::endl;
          exit(1);
        }

        // First check, to see if we need to stop early on

        if (config.has("help") or config.operands().size() != 1)
        {
          // This will print out the 'usage' message with all the visible options
          std::cerr << config << std::endl;
          exit(config.has("help") ? 0 : 1);
        }

        // Configuration files, read it if it exists. If the users
        // specifies an alternative config file, it is an error if that
        // file cannot be found.

        config.parse_config_file("config", "example.conf", { "." }, ec);
        if (ec)
        {
          std::cerr << "Error parsing config file: " << ec.message() << std::endl;
          exit(1);
        }

        // If options are specified more than once, you can get the count

        int VERBOSE = config.count("verbose");

        // Operands are arguments that are not options, e.g. files to act upon

        std::cout << "The first operand is " << config.operands().front() << std::endl;

        // Getting the value of a string option

        auto text = config.get<std::string>("text", ec);
        if (ec)
        {
          std::cerr << "Error getting option text: " << ec.message() << std::endl;
          exit(1);
        }

        std::cout << "Text option is " << text << std::endl;

        // Likewise for numeric options

        int a = config.get<int>("a");
        float b = config.get<float>("b");

        std::cout << "a (" << a << ") * b (" << b << ") = " << a * b << std::endl;

        // And multiple strings

        for (std::string s : config.get<std::vector<std::string>>("c"))
          std::cout << "c: " << s << std::endl;

        return 0;
      }
    EOS
    (testpath/"example.conf").write <<~EOS
      text=foo
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++17",
                    "-I#{include}", "-L#{lib}"
    assert_match "a (4) * b (5) = 20", shell_output("./test -a 4 -b 5 /dev/null")
  end
end
__END__
diff --git a/include/mcfp/detail/options.hpp b/include/mcfp/detail/options.hpp
index e6d198c..70416c4 100644
--- a/include/mcfp/detail/options.hpp
+++ b/include/mcfp/detail/options.hpp
@@ -28,6 +28,7 @@

 #include <cassert>
 #include <filesystem>
+#include <sstream>
 #include <string>
 #include <type_traits>

@@ -102,10 +103,16 @@ struct option_traits<T, typename std::enable_if_t<std::is_arithmetic_v<T>>>
 	static std::string to_string(const T &value)
 	{
 		char b[32];
-		auto r = std::to_chars(b, b + sizeof(b), value);
-		if (r.ec != std::errc())
-			throw std::system_error(std::make_error_code(r.ec));
-		return { b, r.ptr };
+		#if defined(__APPLE__) && defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) && (__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 130300)
+			std::stringstream ss;
+			ss << value;
+			return ss.str();
+		#else
+			auto r = std::to_chars(b, b + sizeof(b), value);
+			if (r.ec != std::errc())
+				throw std::system_error(std::make_error_code(r.ec));
+			return { b, r.ptr };
+		#endif
 	}
 };

@@ -342,4 +349,4 @@ struct option<void> : public option_base
 	}
 };

-} // namespace mcfp::detail
\ No newline at end of file
+} // namespace mcfp::detail
