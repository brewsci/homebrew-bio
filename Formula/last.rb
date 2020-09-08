class Last < Formula
  # cite Kielbasa_2011: "https://doi.org/10.1101/gr.113985.110"
  desc "Find similar regions between sequences"
  homepage "http://last.cbrc.jp/"
  url "http://last.cbrc.jp/last-1061.zip"
  sha256 "ddb6c04e3e4e84913d115d839ab1cca972af4c5bc045b830482ef7e25d677bc9"
  license "GPL-3.0"
  head "http://last.cbrc.jp/last", using: :hg

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "26a9965e1ac0c66c7ca8e77947356b13304b61080e1b1d7f81d783e092977398" => :catalina
    sha256 "37812f372df4253a73c1d24a4df7a14582d3a85963e2273655a611a23ac57e2f" => :x86_64_linux
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
