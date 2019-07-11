class Bam2fastx < Formula
  desc "Convert and demultiplex PacBio BAM files to fasta and fastq format"
  homepage "https://github.com/PacificBiosciences/bam2fastx"
  url "https://github.com/PacificBiosciences/bam2fastx/archive/1.3.0.tar.gz"
  sha256 "be5639807f1ffd2fb972e570068173971026300a79e879384fbf6ad20b5ab762"

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "htslib"
  uses_from_macos "zlib"

  resource "pbbam" do
    url "https://github.com/PacificBiosciences/pbbam/archive/0.23.0.tar.gz"
    sha256 "a9c812324fb925a84108b346befae1cf96192fa0708a547c39c70e0e3f40479e"
  end

  resource "pbcopper" do
    url "https://github.com/PacificBiosciences/pbcopper/archive/v0.4.2.tar.gz"
    sha256 "9f5a7c03c3691cdc883239bdf1cb6b9c6bfe411403dc0111cd782df71848c81d"
  end

  def install
    resources.each do |r|
      r.stage(buildpath/"subprojects/#{r.name}")
    end

    flags = ["-v"]
    # Reduce memory usage for CircleCI
    flags << "-j4" if ENV["HOMEBREW_CIRCLECI"]

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "--wrap-mode=nodownload", ".."
      system "ninja", *flags
      system "ninja", "install", *flags
    end

    pkgshare.install "tests/data"
  end

  test do
    system "#{bin}/bam2fasta", pkgshare/"data/RSII.bam", "-o", "fa"
    system "#{bin}/bam2fastq", pkgshare/"data/RSII.bam", "-o", "fq"
  end
end
