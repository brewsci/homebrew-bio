class Fraggenescan < Formula
  # cite Rho_2010: "https://doi.org/10.1093/nar/gkq747"
  desc "Predicting genes in short and error-prone reads"
  homepage "https://github.com/COL-IU/FragGeneScan"
  url "https://downloads.sourceforge.net/project/fraggenescan/FragGeneScan1.31.tar.gz"
  sha256 "cd3212d0f148218eb3b17d24fcd1fc897fb9fee9b2c902682edde29f895f426c"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "a82f77a860becbe0c068f8421fecd4f9371abf0342efdd5837aed3635d3612b3" => :sierra
    sha256 "962e3fad1b35d723b39231a27718d16f420332c36d1eb9b132522fedea786d1e" => :x86_64_linux
  end

  depends_on "perl" unless OS.mac?

  def install
    system "make", "clean"
    system "make", "fgs"

    script = "run_FragGeneScan.pl"

    # https://github.com/COL-IU/FragGeneScan/issues/8
    inreplace script, "#!/usr/bin/perl -w",
                      "#!/usr/bin/env perl\nuse warnings;"

    # https://github.com/COL-IU/FragGeneScan/issues/9
    inreplace script, "my $dir = substr($0, 0, length($0)-19);",
                      "use FindBin;\nmy $dir = \"$FindBin::RealBin/\";";

    # https://github.com/COL-IU/FragGeneScan/issues/6
    chmod 0644, [ "README", "releases", Dir["train/*"], Dir["example/*"] ]

    prefix.install "FragGeneScan", script, "train", "example"
    bin.install_symlink Dir["#{prefix}/#{script}"]
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/run_FragGeneScan.pl 2>&1")
  end
end
