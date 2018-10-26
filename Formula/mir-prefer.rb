class MirPrefer < Formula
  # cite Lei_2014: "https://doi.org/10.1093/bioinformatics/btu380"
  desc "MicroRNA prediction from small RNA-seq data"
  homepage "https://github.com/hangelwen/miR-PREFeR"
  url "https://github.com/hangelwen/miR-PREFeR/archive/v0.24.tar.gz"
  sha256 "457545478e2d3bc7497d350f3972cf0855b82fa7cb0263a6d91756732f487faf"
  revision 1
  head "https://github.com/hangelwen/miR-PREFeR.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "2152b59ff4a486a8fbc2b30048165ed96f9aeab02dedbd1d18cfcad5179bee93" => :sierra
    sha256 "43d16a0495132ea407473ca736a7c5f83298649a936665d9784c062d1f79c3b9" => :x86_64_linux
  end

  unless OS.mac?
    depends_on "patchelf" => :build
    depends_on "ncurses"
    depends_on "python@2"
    depends_on "zlib"
  end

  def install
    inreplace "miR_PREFeR.py", /^import sys$/, "#!/usr/bin/env python2.7\nimport sys"
    chmod 0755, "miR_PREFeR.py"
    prefix.install Dir["*"]
    bin.install_symlink "../miR_PREFeR.py"
    bin.install_symlink "miR_PREFeR.py" => "miR_PREFeR"
    if OS.linux?
      # Use the brewed ncurses rather than the host's.
      system "patchelf",
        "--set-rpath", [HOMEBREW_PREFIX, Formula["ncurses"].lib, Formula["zlib"].lib].join(":"),
        "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
        prefix/"dependency/Linux/x64/samtools"
      system "patchelf",
        "--replace-needed", "libncurses.so.5", "libncurses.so.6",
        "--remove-needed", "libtinfo.so.5",
        prefix/"dependency/Linux/x64/samtools"
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/miR_PREFeR -h")
  end
end
