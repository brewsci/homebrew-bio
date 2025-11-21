class Muscle < Formula
  # cite Edgar_2004: "https://doi.org/10.1186/1471-2105-5-113"
  # cite Edgar_2022: "https://doi.org/10.1038/s41467-022-34630-w"
  desc "Multiple sequence alignment program"
  homepage "https://www.drive5.com/muscle/"
  url "https://github.com/rcedgar/muscle/archive/refs/tags/v5.3.tar.gz"
  sha256 "74b22a94e630b16015c2bd9ae83aa2be2c2048d3e41f560b2d4a954725c81968"
  license "GPL-3.0-only"
  head "https://github.com/rcedgar/muscle.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_tahoe:   "cfd474743359f49522cd872de75fa49436f20ff7d2959e21060ecea622ce53b2"
    sha256 cellar: :any,                 arm64_sequoia: "bef222ee7ceea33f53a906304c99b986ab558375eda4120c426775e8578d7675"
    sha256 cellar: :any,                 arm64_sonoma:  "4e80557f09db9f42b87301ca3dde456babc5300bda158d28bf559e56d986ff00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f83164696d49a71d24ddeea34a5b15e5b00b09dc0c1e3b6d34ba65a5f62dcbb4"
  end

  depends_on "python@3.14" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
    depends_on "libomp"
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with :clang do
    build 1699
    cause "Requires C++20"
  end

  resource "vcxproj_make" do
    url "https://raw.githubusercontent.com/rcedgar/vcxproj_make/806d016/vcxproj_make.py"
    sha256 "902735703004c47705ffa389329378f237fecb154945b489edf6abe260c6694f"
  end

  def python3
    which("python3.14")
  end

  def install
    resource("vcxproj_make").stage buildpath/"src"
    cd "src" do
      if OS.mac?
        ENV["CPPFLAGS"] = "-Xpreprocessor -I#{Formula["libomp"].opt_include}"
        ENV["LDFLAGS"] = "-L#{Formula["libomp"].opt_lib} -lomp"
      else
        inreplace "vcxproj_make.py", "-static", ""
      end
      system python3, "vcxproj_make.py", "--openmp", "--cppcompiler", ENV.cxx, "--ccompiler", ENV.cc
    end
    bin.install "bin/muscle"
    pkgshare.install "test_scripts", "test_data", "test_results"
  end

  test do
    assert_match "muscle", shell_output("#{bin}/muscle -version")
    system "#{bin}/muscle", "-super5", "#{pkgshare}/test_data/fa/BB11001", "-output", "test_output.fna"
    assert_match "MKKLKKHPDFPKKPLTPYFRFFMEKRAKYAKLHPEMS--NLDLTKILSKKYKELPEKKKMKYIQDFQREKQEFERNLAR-",
                 File.read("test_output.fna")
  end
end
