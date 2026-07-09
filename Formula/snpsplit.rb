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

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e494427de901c6442179d28df4e023cba390f27f37bc5cf77f7ab9d5a934b312"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e494427de901c6442179d28df4e023cba390f27f37bc5cf77f7ab9d5a934b312"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e494427de901c6442179d28df4e023cba390f27f37bc5cf77f7ab9d5a934b312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d20fdb117f6d6308da5b4d6bc9324b4917cdde4f24600e2a9b276d189d0a3f21"
  end

  depends_on "perl"
  depends_on "samtools"

  def install
    # The scripts locate their siblings via FindBin's $RealBin (which resolves
    # symlinks), so install them into libexec and symlink the executables.
    scripts = %w[SNPsplit SNPsplit_genome_preparation tag2sort]
    libexec.install scripts
    scripts.each do |s|
      # Run under Homebrew's Perl rather than whatever `env perl` finds first.
      inreplace libexec/s, "#!/usr/bin/env perl", "#!#{formula_opt_bin("perl")}/perl"
      bin.install_symlink libexec/s
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/SNPsplit --version")
    assert_match version.to_s, shell_output("#{bin}/SNPsplit_genome_preparation --version")
  end
end
