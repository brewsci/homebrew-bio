class Germline2 < Formula
  # cite NaitSaada_2020: "https://doi.org/10.1038/s41467-020-19588-x"
  desc "Efficiently identify shared genetic segments in large-scale data"
  homepage "https://github.com/gusevlab/germline2"
  url "https://github.com/gusevlab/germline2/archive/refs/tags/v1.0.tar.gz"
  sha256 "0b4e0c9a6fac211f605c5e6de7f2b4e0a34c1dd68e9238514bb6fd125504275a"
  license "MIT"
  head "https://github.com/gusevlab/germline2.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5dad3239b998d3b04195c28b42b5ad2b7dd8d3ad21523e63eb70b70373cc385"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "916405e8bc4e696a8401284458f50da48971fd879da5cea5e5201016ef572a1d"
    sha256 cellar: :any_skip_relocation, ventura:       "f329f11a7477e539e44a6cfa67a668de9e418f7b92c7ff0497aa676a49dcb2b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73a9eeab1afc45dc9c8065387c4c55570ac0f2f0b1093f0d16a3817a300b4d9c"
  end

  depends_on "gawk" => :test if OS.mac?
  depends_on "boost"

  # https://github.com/gusevlab/germline2/pull/4
  patch do
    url "https://github.com/gusevlab/germline2/commit/082aa16b1955dc0c0726cd49b0985b37b6746bfe.patch?full_index=1"
    sha256 "ccce0d3ba0b4d57c306117ec382b247695acdb6b95dad27446c0d3955e55b471"
  end

  # https://github.com/gusevlab/germline2/pull/4
  patch do
    url "https://github.com/gusevlab/germline2/commit/ff751a008801dac80e48fb6d09ff19f5602e7f35.patch?full_index=1"
    sha256 "39c21041a1ab4060a395e2cc7af92fa47b9ee24a7219d2cacfdfb4872b191906"
  end

  def install
    # FIXME: remove when https://github.com/gusevlab/germline2/pull/4 is merged
    rm "g2"
    rm "example/accuracy"

    system "make", "all"
    bin.install "g2"

    prefix.install "example"
  end

  test do
    ENV.prepend_path "PATH", Formula["gawk"].libexec/"gnubin" if OS.mac?

    cp_r prefix/"example", testpath

    system "#{bin}/g2", "-m", "0.9",
      "example/SIM.NE_20000.MATCH_FREQ.SHAPEIT.haps",
      "example/SIM.NE_20000.MATCH_FREQ.SHAPEIT.sample",
      "example/genMap.1KG.b37.chr1.map",
      "example/SIM.NE_20000.MATCH_FREQ.INFERRED.match"
    # system "diff", "-s",
    #  "example/SIM.NE_20000.MATCH_FREQ.INFERRED.match",
    #  "example/SIM.NE_20000.MATCH_FREQ.INFERRED.match.TESTED"
    system "bash", "example/accuracy.sh",
      "example/SIM.NE_20000.TRUE.match",
      "example/SIM.NE_20000.MATCH_FREQ.INFERRED.match",
      "example/SIM.NE_20000.MATCH_FREQ.INFERRED.accuracy"
  end
end
