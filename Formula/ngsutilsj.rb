class Ngsutilsj < Formula
  # cite Breese_2013: "http://dx.doi.org/10.1093/bioinformatics/bts731"
  desc "Java port of the NGSUtils toolkit"
  homepage "https://compgen.io/ngsutilsj/"
  url "https://github.com/compgen-io/ngsutilsj/archive/ngsutilsj-0.3.4.tar.gz"
  sha256 "b1be440e35318fd0810cdb4bcb42c85f5f74687bc3126dac26d98361373904df"

  depends_on "ant" => :build
  depends_on :java

  def install
    system "ant"
    name = "ngsutilsj"
    libexec.install Dir["dist/#{name}*"]
    bin.install_symlink libexec/name => name
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ngsutilsj help 2>&1")
  end
end
