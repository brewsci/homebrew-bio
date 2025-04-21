class Smina < Formula
  # cite Koes DR et al. "https://doi.org/10.1021/ci300604z"
  desc "Fork of AutoDock Vina for scoring‑function development and minimization"
  homepage "https://sourceforge.net/projects/smina/"
  # Use the following mirror since the official repository does not provide a download link
  url "https://github.com/eunos-1128/smina/archive/refs/tags/2024.07.10.tar.gz"
  sha256 "a3cc259877a9bca4b67759328c258dd97549c6b21b8ff15b3db877724f6a68d2"
  license all_of: ["Apache-2.0", "GPL-2.0-or-later"]
  head "git://git.code.sf.net/p/smina/code", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sequoia: "f96f13ae0fa70183c18b08d7e8997d9cee2c8ad647e78b81efa852da794d214c"
    sha256 cellar: :any,                 arm64_sonoma:  "9d8cb9c272399142d07f6d3657ebc610119a7bd32a21c1e3286ab69f77af78ee"
    sha256 cellar: :any,                 ventura:       "ee01f6a7baacfd91ffa7c688b76dcc54d3313eb3804c9973d1caa22eebfce9d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dfbfa7c6df12fe6c4a10ea32e7475b4e5fadf5d8b54848a9617f4ca6f9aba3f"
  end

  depends_on "cmake" => :build
  depends_on "boost@1.85"
  depends_on "eigen"
  depends_on "open-babel"

  def install
    # Adapt to newer versions of Boost
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

    inreplace "src/lib/CommandLine2/CommandLine.cpp" do |s|
      s.gsub!("unordered_map<string, Option*>", "boost::unordered_map<string, Option*>")
      s.gsub!("unordered_set<Option*>", "boost::unordered_set<Option*>")
    end

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
    assert_match "Input:", shell_output("#{bin}/smina --help 2>&1")
  end
end
