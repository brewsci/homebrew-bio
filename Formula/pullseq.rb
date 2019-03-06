class Pullseq < Formula
  desc "Utility program for extracting sequences from a fasta/fastq file"
  homepage "https://github.com/bcthomas/pullseq"
  url "https://github.com/bcthomas/pullseq/archive/1.0.2.tar.gz"
  sha256 "a295d7e0e2d64ed05d293d795d1716376707e465f2c42ede6454f27db586c85f"
  head "https://github.com/bcthomas/pullseq.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "eca75d11a1e178df11521eb98bb73ed9f28fa9989a95e42942db8ac5fabf17f7" => :sierra
    sha256 "3512313f9f64ba8a0cd50e7108059ea6187dc95054aa3d1495bfefd9479de836" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "pcre"

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/pullseq --help 2>&1", 1)
  end
end
