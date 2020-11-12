class BlastAT22 < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  if OS.mac?
    url "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.31/ncbi-blast-2.2.31+-universal-macosx.tar.gz"
    sha256 "b5106c70827af90a7117b4fafee114b964bddaceb941b8047dcbaf0d613619d6"
  else
    url "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.31/ncbi-blast-2.2.31+-x64-linux.tar.gz"
    sha256 "322b951e1bca2e8ef16c76a64d78987443dc13fbbbb7a40f1683a97d98e4f408"
  end
  version "2.2.31"

  bottle :unneeded

  keg_only :versioned_formula

  depends_on "patchelf" => :build if OS.linux?

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    prefix.install Dir["*"]
    if OS.linux?
      bins = Dir[bin/"*"].reject { |f| f.end_with? ".pl" }
      bins.each do |f|
        system "patchelf", f,
          "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
          "--set-rpath", [HOMEBREW_PREFIX/"lib", Formula["bzip2"].lib, Formula["zlib"].lib].join(":")
      end
    end
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    output = shell_output("#{bin}/blastn -query test.fasta -subject test.fasta")
    assert_match "Identities = 70/70", output
  end
end
