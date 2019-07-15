class Last < Formula
  # cite Kielbasa_2011: "https://doi.org/10.1101/gr.113985.110"
  desc "Find similar regions between sequences"
  homepage "http://last.cbrc.jp/"
  url "http://last.cbrc.jp/last-982.zip"
  sha256 "2affa2ff2285f76e00431412429caa59ae3846f92b4d2b0524906cb470ca20d1"
  head "http://last.cbrc.jp/last", :using => :hg

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "1079d4290ae07bbc6c7fc82dc15e8999c5864c6b958b6f94f18f25bbba9db8b9" => :sierra
    sha256 "cdfb9576c6e776fa2a338322a08a80156ee767348d3921ed49ba850f132b0a18" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

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
