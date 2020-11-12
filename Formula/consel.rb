class Consel < Formula
  # cite Shimodaira_2001: "https://doi.org/10.1093/bioinformatics/17.12.1246"
  desc "Assessing the confidence of phylogenetic tree selection"
  homepage "http://stat.sys.i.kyoto-u.ac.jp/prog/consel/"
  url "http://stat.sys.i.kyoto-u.ac.jp/prog/consel/pub/cnsls020.tgz"
  version "0.20"
  sha256 "cc6e8ee6077693817db475229aa47b9d9fb66bf5f48a3aace63e4b525f05238b"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "a27d35514c4c834befc6bf71f9beb91a09369190c73830c34f6fecba817857be" => :sierra
    sha256 "d8a7fd3a42022107b4fd61b490be3cfbc2248ccae15fd580853ab705ad9b6e2b" => :x86_64_linux
  end

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
