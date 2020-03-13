class Masurca < Formula
  # cite Zimin_2013: "https://doi.org/10.1093/bioinformatics/btt476"
  desc "Maryland Super-Read Celera Assembler"
  homepage "https://masurca.blogspot.com/"
  url "https://github.com/alekseyzimin/masurca/releases/download/v3.3.9/MaSuRCA-3.3.9.tar.gz"
  sha256 "0971e481eb4d3682bf13ca611098feb5b97ccd786faa94c94f09fae30b159a6f"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "219584cc8498739e61257cb116127af19ff717b91d36dbe78c301452acd41054" => :x86_64_linux
  end

  depends_on "boost" => :build
  depends_on "jellyfish"
  depends_on :linux
  depends_on "parallel"
  depends_on "perl"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    ENV.deparallelize

    # Reduce memory usage on CircleCI
    ENV["MAKEFLAGS"] = "-j4" if ENV["CIRCLECI"]
    # Respect MAKEFLAGS variable
    inreplace "install.sh", "make -j $NUM_THREADS", "make"
    ENV["DEST"] = libexec
    system "./install.sh"

    bin.install_symlink libexec/"bin/masurca"
    pkgshare.install "sr_config_example.txt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/masurca --version 2>&1")
    system "#{bin}/masurca", "-h"
  end
end
