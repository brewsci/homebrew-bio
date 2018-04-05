class Astral < Formula
  # cite Zhang_2017: "https://doi.org/10.1007/978-3-319-67979-2_4"
  desc "Estimate species tree given set of unrooted gene trees"
  homepage "https://github.com/smirarab/ASTRAL"
  url "https://github.com/smirarab/ASTRAL/archive/5.5.6.tar.gz"
  sha256 "dc7d6b09a15db7ebdc676f354b3e3300beba8bf104c4366a61f31535044b58b7"
  head "https://github.com/smirarab/ASTRAL.git"

  depends_on :java

  def install
    inreplace "make.sh" do |s|
      s.gsub! /version=.*/, "version=#{version}"
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
