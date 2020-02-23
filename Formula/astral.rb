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
    sha256 "639cf19cf7371e03cbb4092a3d5ec470628817dd3878f9ac0bb20b9b20ed1eba" => :catalina
    sha256 "0e0f15952cbf659a6a6654c5f11fbc4fe96d74f6c3c6843baba33d89073eacca" => :x86_64_linux
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
