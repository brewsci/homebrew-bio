class Varscan < Formula
  # cite Koboldt_2012: "https://doi.org/10.1101/gr.129684.111"
  desc "Variant detection in massively parallel sequencing data"
  homepage "https://dkoboldt.github.io/varscan/"
  url "https://github.com/dkoboldt/varscan/raw/master/VarScan.v2.4.4.jar"
  sha256 "fb23b72ab676fb5a89bd02091c2b6c9aff210b96bee04d9dee6aef4d8b72814d"

  livecheck do
    url "https://github.com/dkoboldt/varscan/tree/master"
    strategy :page_match
    regex(/href=.*?VarScan[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "54a78df4e18651c18647c55b16783cf350d92b996943660cc1c2769f5e511fb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "94c247d9491f48ff0bbd71eacd38be4d07b33986015715b53668c083a793508f"
  end

  depends_on "openjdk"

  def install
    jar = "VarScan.v#{version}.jar"
    libexec.install jar
    bin.write_jar_script libexec/jar, "varscan"
  end

  test do
    assert_match "somatic", shell_output("#{bin}/varscan 2>&1")
    assert_match "min-coverage", shell_output("#{bin}/varscan filter -h 2>&1")
  end
end
