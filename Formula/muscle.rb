class Muscle < Formula
  # cite Edgar_2004: "https://doi.org/10.1186/1471-2105-5-113"
  # cite Edgar_2022: "https://doi.org/10.1038/s41467-022-34630-w"
  desc "Multiple sequence alignment program"
  homepage "https://www.drive5.com/muscle/"
  url "https://github.com/rcedgar/muscle/archive/refs/tags/v5.3.tar.gz"
  sha256 "74b22a94e630b16015c2bd9ae83aa2be2c2048d3e41f560b2d4a954725c81968"
  license "GPL-3.0-only"
  head "https://github.com/rcedgar/muscle.git", branch: "main"

  depends_on "python@3.14" => :build

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "gcc"
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
