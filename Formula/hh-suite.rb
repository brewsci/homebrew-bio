class HhSuite < Formula
  # cite Steinegger_2019: "https://doi.org/10.1186/s12859-019-3019-7"
  desc "Remote protein homology detection suite"
  homepage "https://github.com/soedinglab/hh-suite"
  url "https://github.com/soedinglab/hh-suite/archive/v3.2.0.tar.gz"
  sha256 "6b870dcfbc1ffb9dd664a45415fcd13cf5970f49d1c7b824160c260fa138e6d6"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "145cff156ee16d6ab8cf0b335cc93b53fc4d4c028a9b6733b02585f8f0565791" => :catalina
    sha256 "c14d716a6c586cd1e6fe2cd2745bf3d4606f810a89eff0cc14cdfe70cb624a2a" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "python"

  uses_from_macos "perl"

  fails_with :clang # needs openmp

  on_macos do
    depends_on "gcc" # needs openmp
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  def caveats
    "HH-suite requires at least SSE4.1 CPU instruction support." unless Hardware::CPU.sse4?
  end

  test do
    assert_match "Usage", shell_output("#{bin}/hhalign -h")
    assert_match "Usage", shell_output("#{bin}/hhblits -h")
    assert_match "Usage", shell_output("#{bin}/hhconsensus -h")
    assert_match "Usage", shell_output("#{bin}/hhfilter -h")
    assert_match "Usage", shell_output("#{bin}/hhmake -h")
    assert_match "Usage", shell_output("#{bin}/hhsearch -h")
  end
end
