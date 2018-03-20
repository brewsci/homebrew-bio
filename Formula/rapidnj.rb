class Rapidnj < Formula
  # cite Simonsen_2008: "https://doi.org/10.1007/978-3-540-87361-7_10"
  desc "Rapid canonical neighbor-joining tree construction"
  homepage "https://birc.au.dk/Software/RapidNJ/"
  url "http://users-birc.au.dk/cstorm/software/rapidnj/rapidnj-src-2.3.2.zip"
  sha256 "80a30a42cb5390920b4dd2132801083ae67146f9821807b40a4ee9160292e070"

  def install
    system "make"
    bin.install "bin/rapidnj"
  end

  test do
    assert_match "Kimura", shell_output("#{bin}/rapidnj -h 2>&1", 1)
  end
end
