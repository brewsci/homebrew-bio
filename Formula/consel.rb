class Consel < Formula
  # cite Shimodaira_2001: "https://doi.org/10.1093/bioinformatics/17.12.1246"
  desc "Assessing the confidence of phylogenetic tree selection"
  homepage "http://stat.sys.i.kyoto-u.ac.jp/prog/consel/"
  url "http://stat.sys.i.kyoto-u.ac.jp/prog/consel/pub/cnsls020.tgz"
  version "0.20"
  sha256 "cc6e8ee6077693817db475229aa47b9d9fb66bf5f48a3aace63e4b525f05238b"

  def install
    cd "src" do
      system "make"
      system "make", "install", "bindir=#{bin}"
    end
    pkgshare.install "example"
  end

  test do
    cp pkgshare/"example/mu1.vt", testpath
    system "#{bin}/randrep", "-m", "mu1"
    system "#{bin}/consel", "mu1"
    system "#{bin}/catpv", "mu1"
  end
end
