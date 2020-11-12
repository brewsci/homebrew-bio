class Fastuniq < Formula
  # cite Xu_2012: "https://doi.org/10.1371%2Fjournal.pone.0052249"
  desc "Fast de novo duplicate removal for paired short reads"
  homepage "https://sourceforge.net/projects/fastuniq/"
  url "https://downloads.sourceforge.net/project/fastuniq/FastUniq-1.1.tar.gz"
  sha256 "9ebf251566d097226393fb5aa9db30a827e60c7a4bd9f6e06022b4af4cee0eae"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "d1102d51ef9544219812a378b24ef165cf1780ba7c2e8806373acc9d5741977b" => :sierra
    sha256 "ee48dc9e66808e87057362b7a5f8fbc7debe1b63aa521b8817cbe1c5a02dc684" => :x86_64_linux
  end

  def install
    inreplace "source/fastq_uniq.c", "FSATQ", "FASTQ" # fix typo
    system "make", "-C", "source"
    bin.install "source/fastuniq"
    doc.install "README.txt"
    pkgshare.install Dir["example/*"]
  end

  test do
    assert_match "read pairs", shell_output("#{bin}/fastuniq 2>&1", 1)
  end
end
