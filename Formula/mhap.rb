class Mhap < Formula
  # cite Berlin_2015: "https://doi.org/10.1038/nbt.3238"
  desc "MinHash Alignment Process"
  homepage "https://github.com/marbl/MHAP"
  url "https://github.com/marbl/MHAP/releases/download/2.1.3/mhap-2.1.3.jar.gz"
  version "2.1.3"
  sha256 "665c0da4f2c94ddc405b291cb088b1377229249a6f2c1b80eebb8b85aebfa983"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "9dc80ffe3fc5ee5056b59dc444207aa5be09c2191cca955387be3c49c462c359" => :sierra
    sha256 "17714c9a0a868298fe64d13cae37640ecae28323e9fc748c5696af93326a8e35" => :x86_64_linux
  end

  depends_on :java

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
