class Yaha < Formula
  # cite Faust_2012: "https://doi.org/10.1093/bioinformatics/bts456"
  desc "Optimal split-read alignment for single reads from 100bp to 32kb"
  homepage "https://github.com/GregoryFaust/yaha"
  url "https://github.com/GregoryFaust/yaha/releases/download/v0.1.83/yaha-0.1.83.tar.gz"
  sha256 "76e052cd92630c6e9871412e37e46f18bfbbf7fc5dd2f345b3b9a73eb74939ef"

  def install
    # https://github.com/GregoryFaust/yaha/issues/2
    inreplace "Makefile", "-MMD -MP", "-MMD -MP -fpermissive"

    system "make"
    bin.install "bin/yaha"
    doc.install Dir["*.pdf"]
    pkgshare.install "testdata"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yaha -h 2>&1")
  end
end
