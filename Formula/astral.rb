class Astral < Formula
  # cite Zhang_2017: "https://doi.org/10.1007/978-3-319-67979-2_4"
  desc "Estimate species tree given set of unrooted gene trees"
  homepage "https://github.com/smirarab/ASTRAL"
  url "https://github.com/smirarab/ASTRAL/archive/v5.7.1.tar.gz"
  sha256 "8aa6fd4324efca325d3dde432517090fac314bea95f407b1dd59977181fec77e"
  head "https://github.com/smirarab/ASTRAL.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "8244a801d3e6ff3571e13c0d9fe7149e0b28260f254ef2c3b5208bce660852e3" => :sierra
    sha256 "b8bc5a4cf097a1b7787534cafbc7d9dbfb65549804a48df4e86a93962d12360a" => :x86_64_linux
  end

  depends_on :java

  def install
    inreplace "make.sh" do |s|
      s.gsub! /version=.*/, "version=#{version}"
      s.gsub! "-source 1.6", "-source 1.7"
      s.gsub! "-target 1.6", "-target 1.7"
      s.gsub! /^zip/, "echo" # no need to zip anything
    end
    system "./make.sh"
    libexec.install "lib", "astral.#{version}.jar"
    pkgshare.install "main/test_data"
    bin.write_jar_script libexec/"astral.#{version}.jar", "astral"
  end

  test do
    system bin/"astral", "-i", pkgshare/"test_data/simulated_14taxon.gene.tre"
  end
end
