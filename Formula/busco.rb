class Busco < Formula
  desc "Assess genome assembly completeness with single-copy orthologs"
  homepage "http://busco.ezlab.org"
  url "https://gitlab.com/ezlab/busco/repository/3.0.2/archive.tar.bz2"
  sha256 "cd0699545a126c7cc94604eef7c8dc50379b5d11becbad3a0f55d995a4c5e1c0"
  head "https://gitlab.com/ezlab/busco.git"
  # cite "http://doi.org/10.1093/bioinformatics/btv351"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "cdb14d393a9791cd121756fd74f6677f2e4d577cc268036fa7fb708a1e65edd2" => :sierra_or_later
    sha256 "d5fc62e2ab2d5cf248d6cac19de3be8c69b6ec4ebbcd8d132974dbf0add3d6ca" => :x86_64_linux
  end

  depends_on "python3"
  depends_on "blast" => :recommended
  # Also depends on augustus and hmmer

  def install
    inreplace Dir["scripts/*.py"], "#!/usr/bin/env python", "#!#{HOMEBREW_PREFIX}/bin/python3"
    system "python3", "setup.py", "install", "--prefix=#{prefix}"
    bin.install Dir["scripts/*"]
    bin.install_symlink "run_BUSCO.py" => "busco"
    doc.install "BUSCO_v3_userguide.pdf"
    prefix.install "config/config.ini.default"
  end

  test do
    assert_match "usage", shell_output("#{bin}/busco --help")
  end
end
