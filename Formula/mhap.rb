class Mhap < Formula
  # cite Berlin_2015: "https://doi.org/10.1038/nbt.3238"
  desc "MinHash Alignment Process"
  homepage "https://github.com/marbl/MHAP"
  url "https://github.com/marbl/MHAP/releases/download/2.1.3/mhap-2.1.3.jar.gz"
  version "2.1.3"
  sha256 "665c0da4f2c94ddc405b291cb088b1377229249a6f2c1b80eebb8b85aebfa983"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "9dc80ffe3fc5ee5056b59dc444207aa5be09c2191cca955387be3c49c462c359"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "17714c9a0a868298fe64d13cae37640ecae28323e9fc748c5696af93326a8e35"
  end

  depends_on "openjdk"

  def install
    jar = "mhap-#{version}.jar"
    libexec.install jar
    bin.write_jar_script libexec/jar, "mhap"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mhap --version")
    assert_match "Usage", shell_output("#{bin}/mhap --help")
  end
end
