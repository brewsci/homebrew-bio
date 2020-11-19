class HhSuite < Formula
  # cite Steinegger_2019: "https://doi.org/10.1186/s12859-019-3019-7"
  desc "Remote protein homology detection suite"
  homepage "https://github.com/soedinglab/hh-suite"
  url "https://github.com/soedinglab/hh-suite/archive/v3.3.0.tar.gz"
  sha256 "dd67f7f3bf601e48c9c0bc4cf1fbe3b946f787a808bde765e9436a48d27b0964"
  license "GPL-3.0-only"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "cf7755f126cea9f05843022ec5b7e7d193722c568bbecd3bc41f88ac7d32ac28" => :catalina
    sha256 "5a573d69a999513ead717a21b8d0bca07889c174bb1431bb74f4aa05ff879f48" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "python@3.9"

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
