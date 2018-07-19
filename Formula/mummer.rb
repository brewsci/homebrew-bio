class Mummer < Formula
  # cite Mar_ais_2018: "https://doi.org/10.1371/journal.pcbi.1005944"
  desc "Alignment of large-scale DNA and protein sequences"
  homepage "https://mummer4.github.io"
  url "https://github.com/mummer4/mummer/releases/download/v4.0.0beta2/mummer-4.0.0beta2.tar.gz"
  sha256 "cece76e418bf9c294f348972e5b23a0230beeba7fd7d042d5584ce075ccd1b93"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    mv bin/"annotate", bin/"annotate-mummer"
  end

  test do
    assert_match "4.0.0beta2", pipe_output(bin/"mummer -v")
  end
end
