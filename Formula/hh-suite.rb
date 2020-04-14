class HhSuite < Formula
  # cite Steinegger_2019: "https://doi.org/10.1186/s12859-019-3019-7"
  desc "Remote protein homology detection suite"
  homepage "https://github.com/soedinglab/hh-suite"
  url "https://github.com/soedinglab/hh-suite/archive/v3.2.0.tar.gz"
  sha256 "6b870dcfbc1ffb9dd664a45415fcd13cf5970f49d1c7b824160c260fa138e6d6"
  revision 2

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "145cff156ee16d6ab8cf0b335cc93b53fc4d4c028a9b6733b02585f8f0565791" => :catalina
    sha256 "c14d716a6c586cd1e6fe2cd2745bf3d4606f810a89eff0cc14cdfe70cb624a2a" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "python"

  uses_from_macos "perl"

  on_macos do
    depends_on "gcc" # needs openmp
  end
  fails_with :clang # needs openmp

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "HHalign 3.1.0", shell_output("#{bin}/hhalign -h | head -1")
    assert_match "HHblits 3.1.0", shell_output("#{bin}/hhblits -h | head -1")
    assert_match "HHconsensus 3.1.0", shell_output("#{bin}/hhconsensus -h | head -1")
    assert_match "HHfilter 3.1.0", shell_output("#{bin}/hhfilter -h | head -1")
    assert_match "HHmake 3.1.0", shell_output("#{bin}/hhmake -h | head -1")
    assert_match "HHsearch 3.1.0", shell_output("#{bin}/hhsearch -h | head -1")
  end
end
