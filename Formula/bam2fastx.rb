class Bam2fastx < Formula
  desc "Convert and demultiplex PacBio BAM files to fasta and fastq format"
  homepage "https://github.com/PacificBiosciences/bam2fastx"
  url "https://github.com/PacificBiosciences/bam2fastx/archive/refs/tags/1.3.1.tar.gz"
  sha256 "4a6e305a631002b2da5bc57341a85f5cf424be832c2c80a6775d0d86965f8ed1"
  license "BSD-3-Clause-Clear"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, sierra:       "5e1053af2b9f378b5176e16bf65387d5e0ddfbec6468a5e21640f39b501bdf16"
    sha256 cellar: :any, x86_64_linux: "2990674c01b517325aeab3d132436bd5bba1bee063112117206ff0ac3b50eb29"
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
