class Bam2fastx < Formula
  desc "Convert and demultiplex PacBio BAM files to fasta and fastq format"
  homepage "https://github.com/PacificBiosciences/bam2fastx"
  url "https://github.com/PacificBiosciences/bam2fastx/archive/refs/tags/1.3.1.tar.gz"
  sha256 "4a6e305a631002b2da5bc57341a85f5cf424be832c2c80a6775d0d86965f8ed1"
  license "BSD-3-Clause-Clear"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, big_sur:      "9a1d282d835b6e909347af9371ffda3b226e9fd2a3e7597776fd5d27ceebf767"
    sha256               x86_64_linux: "14cb097cc61e1a8f74be2ab82eee373f0dc08df4b66766df2cd08a37dd9f31f6"
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "htslib"
  uses_from_macos "zlib"

  resource "pbbam" do
    url "https://github.com/PacificBiosciences/pbbam/archive/refs/tags/v2.1.0.tar.gz"
    sha256 "605944f09654d964ce12c31d67e6766dfb1513f730ef5d4b74829b2b84dd464f"
  end

  resource "pbcopper" do
    url "https://github.com/PacificBiosciences/pbcopper/archive/refs/tags/v2.0.0.tar.gz"
    sha256 "9edbef2fc6e3885c1206b6a9cdf7287bfa826b2b758992526d2f4d3c9b57431e"
  end

  def install
    resources.each do |r|
      r.stage(buildpath/"subprojects/#{r.name}")
    end

    mkdir "build" do
      system "meson", *std_meson_args, "--wrap-mode=nodownload", "-Dtests=false", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    pkgshare.install "tests/data"
  end

  test do
    system "#{bin}/bam2fasta", pkgshare/"data/RSII.bam", "-o", "fa"
    system "#{bin}/bam2fastq", pkgshare/"data/RSII.bam", "-o", "fq"
  end
end
