class Seqerr < Formula
  # cite Browning_2013: "https://doi.org/10.1016/j.ajhg.2013.09.014"
  desc "Estimate rate at which homozygous major allele genotypes are mis-called"
  homepage "https://faculty.washington.edu/browning/seqerr.html"
  url "https://faculty.washington.edu/browning/seqerr/seqerr.r1181.zip"
  sha256 "91aefa26289c8dc7e1984ac2742f96906b8a8996a9673f6bbae12946f77300d2"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "2f55adb56dbabdbd5f3eac5ca9b69f5f04d7acb4b4c15922e9dfef082e927c5b"
  end

  depends_on "openjdk"

  def install
    chdir ".." do
      system "#{Formula["openjdk"].bin}/javac", "-cp", "src/", "src/seqerr/SeqErrMain.java"
      system "#{Formula["openjdk"].bin}/jar", "-cfe", "seqerr.jar", "seqerr.SeqErrMain", "-C", "src/", "."

      libexec.install "seqerr.jar"
      bin.write_jar_script libexec/"seqerr.jar", "seqerr"
    end
  end

  test do
    assert_predicate bin/"seqerr", :executable?
    assert_predicate libexec/"seqerr.jar", :exist?
    assert_match "usage: java -jar seqerr.jar", shell_output("#{bin}/seqerr")
  end
end
