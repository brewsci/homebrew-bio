class Last < Formula
  # cite Kielbasa_2011: "https://doi.org/10.1101/gr.113985.110"
  desc "Find similar regions between sequences"
  homepage "http://last.cbrc.jp/"
  url "http://last.cbrc.jp/last-1133.zip"
  sha256 "58ba97538ee3c2913bb2c485a994a2d17cdebe218fcbdf15f5a156efc205c028"
  license "GPL-3.0"
  head "http://last.cbrc.jp/last", using: :hg

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "66dccf49e7f904abd138fbfc83d0bdaf4800884a76d2f8aa55bc625432b2295d" => :catalina
    sha256 "36f3304a2a5d139dc3192c6126b8ed281fa7882ad2712f65e9576139dfb2dad8" => :x86_64_linux
  end

  uses_from_macos "zlib"

  def install
    system "make", "install", "prefix=#{prefix}"
    doc.install Dir["doc/*"]
    pkgshare.install "data", "examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lastal -V")
    system "#{bin}/lastdb", testpath/"db", pkgshare/"examples/mouseMito.fa"
    assert_predicate testpath/"db.suf", :exist?
    assert_match "lambda=",
      shell_output("#{bin}/lastal #{testpath}/db #{pkgshare}/examples/chickenMito.fa")
  end
end
