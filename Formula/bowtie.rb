class Bowtie < Formula
  include Language::Python::Shebang

  # cite Langmead_2009: "https://doi.org/10.1186/gb-2009-10-3-r25"
  desc "Ultrafast memory-efficient short read aligner"
  homepage "https://bowtie-bio.sourceforge.io/"
  url "https://github.com/BenLangmead/bowtie/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "147d9fe9652f7c5f351bfc0eb012e06981986fb43bd6bdfe88a95c02eabc6573"
  license "Artistic-2.0"
  head "https://github.com/BenLangmead/bowtie.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "097544d5656a7fab72b8d36e08bc7e2be4032fdd573fa205ad4da9ad5d7bf56a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cf888db0331e61e96ebc6ea51418af5a1f9045d83c49c560d65cb396a448ac4d"
  end

  depends_on "python"
  depends_on "tbb"

  def install
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
