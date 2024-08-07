class Bowtie < Formula
  include Language::Python::Shebang

  # cite Langmead_2009: "https://doi.org/10.1186/gb-2009-10-3-r25"
  desc "Ultrafast memory-efficient short read aligner"
  homepage "https://bowtie-bio.sourceforge.io/"
  url "https://github.com/BenLangmead/bowtie/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "147d9fe9652f7c5f351bfc0eb012e06981986fb43bd6bdfe88a95c02eabc6573"
  license "Artistic-2.0"
  revision 1
  head "https://github.com/BenLangmead/bowtie.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "a53659f87fd1c9477ca39d60ccf59702db275f84bafd559689ef70a018ab41ca"
    sha256 cellar: :any_skip_relocation, ventura:      "d4ef054f693e33c664220566ff59331b8eb923ce06c632954ef75e7ad2d2aed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "21c1424f1b8d9de37be6f44c5bee0075b8e3487b1e5206f6c6ce8650efde6339"
  end

  depends_on "python@3.12"
  depends_on "tbb"

  uses_from_macos "zlib"

  def install
    # Fix compilation error
    # ./VERSION:1:1: error: expected unqualified-id
    rm "VERSION" # VERSION file is not used
    ENV["VERSION"] = version
    # POPCNT is not supported on ARM
    ENV["POPCNT_CAPABILITY"] = "0" if Hardware::CPU.arm?
    if OS.mac? && DevelopmentTools.clang_build_version >= 1500
      # Workaround a bug in Xcode 15's new linker (FB13038083)
      toolchain_path = "/Library/Developer/CommandLineTools"
      ENV.append_path "CPLUS_INCLUDE_PATH", "#{toolchain_path}/SDKs/MacOSX.sdk/usr/include/c++/v1"
    end

    system "make", "install", "prefix=#{prefix}"
    bin.find { |f| rewrite_shebang detected_python_shebang, f }

    doc.install "MANUAL", "NEWS", "TUTORIAL"
    pkgshare.install "scripts", "genomes", "indexes", "reads"
  end

  test do
    Dir[bin/"*"].each do |exe|
      assert_match "usage", shell_output("#{exe} --help 2>&1")
    end
  end
end
