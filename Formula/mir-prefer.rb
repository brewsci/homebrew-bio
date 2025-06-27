class MirPrefer < Formula
  # cite Lei_2014: "https://doi.org/10.1093/bioinformatics/btu380"
  desc "MicroRNA prediction from small RNA-seq data"
  homepage "https://github.com/hangelwen/miR-PREFeR"
  url "https://github.com/hangelwen/miR-PREFeR/archive/v0.24.tar.gz"
  sha256 "457545478e2d3bc7497d350f3972cf0855b82fa7cb0263a6d91756732f487faf"
  revision 1
  head "https://github.com/hangelwen/miR-PREFeR.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "2152b59ff4a486a8fbc2b30048165ed96f9aeab02dedbd1d18cfcad5179bee93"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "43d16a0495132ea407473ca736a7c5f83298649a936665d9784c062d1f79c3b9"
  end

  depends_on :macos # needs python@2

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    inreplace "miR_PREFeR.py", /^import sys$/, "#!/usr/bin/env python2.7\nimport sys"
    chmod 0755, "miR_PREFeR.py"
    prefix.install Dir["*"]
    bin.install_symlink "../miR_PREFeR.py"
    bin.install_symlink "miR_PREFeR.py" => "miR_PREFeR"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/miR_PREFeR -h")
  end
end
