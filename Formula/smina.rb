class Smina < Formula
  desc "Fork of AutoDock Vina for scoring‑function development and minimization"
  homepage "https://sourceforge.net/projects/smina/"
  # Use the following mirror since the official repository does not provide a download link
  url "https://github.com/eunos-1128/smina/archive/refs/tags/2024.07.10.tar.gz"
  sha256 "a3cc259877a9bca4b67759328c258dd97549c6b21b8ff15b3db877724f6a68d2"
  license "Apache-2.0"
  head "git://git.code.sf.net/p/smina/code", branch: "master"

  depends_on "cmake" => :build
  depends_on "boost@1.85"
  depends_on "eigen"
  depends_on "open-babel"

  def install
    inreplace "src/main/main.cpp" do |s|
      s.gsub! "#include <boost/filesystem/convenience.hpp>", "#include <boost/filesystem.hpp>"
    end

    inreplace "src/lib/file.h", "#include <boost/filesystem.hpp>", <<~EOS.chomp
      #include <boost/filesystem.hpp>
      #include <boost/filesystem/operations.hpp>

      namespace boost { namespace filesystem {
        inline std::string extension(const path& p) { return p.extension().string(); }
        inline std::string basename(const path& p) { return p.stem().string(); }
      }}
    EOS

    inreplace "CMakeLists.txt" do |s|
      s.gsub! "set (CMAKE_CXX_STANDARD 11)", "set(CMAKE_CXX_STANDARD 14)"
      # Disable server function builds once,
      # as they need to be significantly rewritten with the new Boost
      s.gsub!(/^add_executable\(server .*\)$/, '# \0')
      s.gsub!(/^target_link_libraries\(server .*\)$/, '# \0')
      s.gsub!(/^include_directories\(server\s+.*\)$/, '# \0')
    end

    mkdir "build" do
      # generate version.cpp
      (Pathname.pwd/"version.cpp").write <<~EOS
        const char* GIT_REV = "02b978";
        const char* GIT_TAG = "#{version}";
        const char* GIT_BRANCH = "master";
      EOS

      ENV.append "CXXFLAGS", "-DBOOST_TIMER_ENABLE_DEPRECATED=1"
      system "cmake", "..",
             "-DCMAKE_BUILD_TYPE=Release",
             "-DCMAKE_INSTALL_PREFIX=#{prefix}",
             "-DOPENBABEL_DIR=#{Formula["open-babel"].opt_prefix}",
             *std_cmake_args
      system "make"
      bin.install "smina"
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/smina --help")
  end
end
