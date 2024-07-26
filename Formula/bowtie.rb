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
    sha256 cellar: :any_skip_relocation, catalina:     "42de0f90a500103a2736bf4728d267a0e729096bc8ce45b6d3ef9a21cd86d87d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a4bd1d75bc2a132f22122093a993a53c174a3a80045df118016b58dbdca4a869"
  end

  depends_on "python@3.12"
  depends_on "tbb"

  uses_from_macos "zlib"

  def install
    # Fix compilation error
    # ./VERSION:1:1: error: expected unqualified-id
    rm "VERSION" # VERSION file is not used
    ENV["VERSION"] = version
    inreplace "processor_support.h", "#elif defined(__GNUC__)", "#elif defined(__GNUC__) && !defined(__arm64__)"
    if OS.mac? && DevelopmentTools.clang_build_version >= 1500
      # Work around a bug in Xcode 15's new linker (FB13038083)
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
