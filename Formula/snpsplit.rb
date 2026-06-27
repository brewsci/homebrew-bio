class Snpsplit < Formula
  desc "Allele-specific alignment sorter for allele-specific sequencing"
  homepage "https://github.com/FelixKrueger/SNPsplit"
  url "https://github.com/FelixKrueger/SNPsplit/archive/refs/tags/0.6.0.tar.gz"
  sha256 "6b4b66db6871982f728f41b0d564f958f5fa962a234f04b3707cf4e8bac616df"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "samtools"
  uses_from_macos "perl"

  def install
    # The scripts locate their siblings via FindBin's $RealBin (which resolves
    # symlinks), so install them into libexec and symlink the executables.
    scripts = %w[SNPsplit SNPsplit_genome_preparation tag2sort]
    libexec.install scripts
    scripts.each { |s| bin.install_symlink libexec/s }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/SNPsplit --version")
    assert_match version.to_s, shell_output("#{bin}/SNPsplit_genome_preparation --version")
  end
end
