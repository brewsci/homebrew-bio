class Varscan < Formula
  # cite Koboldt_2012: "https://doi.org/10.1101/gr.129684.111"
  desc "Variant detection in massively parallel sequencing data"
  homepage "https://dkoboldt.github.io/varscan/"
  url "https://github.com/dkoboldt/varscan/raw/master/VarScan.v2.4.6.jar"
  sha256 "e827230b47a96cab035c5c7178e5089921a1e1c8d1e4836a6b02ff88e3a4c2ab"

  livecheck do
    url "https://github.com/dkoboldt/varscan/tree/master"
    strategy :page_match
    regex(/href=.*?VarScan[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ddf94ef137835807cbdae3bfa4613cf5ed4734447ec30002999bbdf54d64a20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28c32dd5f12015a704289f7a0cc45a9830027f50bd898bf86611f7438251fb0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "798d813c5b07ae82e52e941b49cd39cfe76f630d4f13ccc6e70deacba7f79d73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3501f7a458acb12cc5b963c1eb26e3ee78fae3be026c7baf508650c4f2b0ef9"
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
