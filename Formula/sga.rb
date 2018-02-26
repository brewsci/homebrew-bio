class Sga < Formula
  # cite Simpson_2011: "https://doi.org/10.1101/gr.126953.111"
  desc "De novo genome assembler based on the concept of string graphs"
  homepage "https://github.com/jts/sga"
  url "https://github.com/jts/sga/archive/v0.10.15.tar.gz"
  sha256 "1b18996e6ec47985bc4889a8cbc3cd4dd3a8c7d385ae9f450bd474e36342558b"
  revision 1
  head "https://github.com/jts/sga.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "google-sparsehash" => :build
  depends_on "bamtools"
  depends_on "zlib" unless OS.mac?

  def install
    cd "src" do
      system "./autogen.sh"
      system "./configure",
        "--disable-dependency-tracking",
        "--prefix=#{prefix}",
        "--with-bamtools=#{Formula["bamtools"].prefix}",
        "--with-sparsehash=#{Formula["google-sparsehash"].prefix}"
      system "make", "install"
      bin.install Dir["bin/*"] - Dir["bin/Makefile*"]
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/sga --help")
  end
end
