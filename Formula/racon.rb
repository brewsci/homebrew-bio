class Racon < Formula
  # cite Vaser_2017: "https://doi.org/10.1101/gr.214270.116"
  desc "Compute consensus sequence of a genome assembly of long uncorrected reads"
  homepage "https://github.com/lbcb-sci/racon"
  url "https://github.com/lbcb-sci/racon/releases/download/1.4.13/racon-v1.4.13.tar.gz"
  sha256 "4220e98bf84768483bd94eef62a0821cffc74f4e7139c74685c08161909263b0"
  license "MIT"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "9a36412582dbf860ad19aa1d9795af7f6f6c326e4642fc0a8d6325431f363d5d" => :catalina
    sha256 "d5925954884d8e3f99266f30a7d28dfc0113740fa5baca55ccc90d3c3683d73a" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "python@3.8"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  # Update spoa from 3.0.2 to 3.1.1 to fix 'invalid_argument' error
  # https://github.com/rvaser/spoa/pull/28
  resource "spoa" do
    url "https://github.com/rvaser/spoa.git",
      revision: "06d58ef50ab19184bb1d905443e091310de9ce2c"
  end

  def install
    rm_rf "vendor/spoa"
    (buildpath/"vendor/spoa").install resource("spoa")
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
    bin.install Dir["scripts/*.py"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/racon --version 2>&1")
    assert_match "usage", shell_output("#{bin}/racon --help")
  end
end
