class Busco < Formula
  # cite Waterhouse_2017: "https://doi.org/10.1093/molbev/msx319"
  # cite Sim_o_2015: "https://doi.org/10.1093/bioinformatics/btv351"
  desc "Assess genome assembly completeness with single-copy orthologs"
  homepage "https://busco.ezlab.org"
  url "https://gitlab.com/ezlab/busco/repository/3.0.2/archive.tar.bz2"
  sha256 "cd0699545a126c7cc94604eef7c8dc50379b5d11becbad3a0f55d995a4c5e1c0"
  revision 1
  head "https://gitlab.com/ezlab/busco.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "594cc8b36a46aebaaa2d3041fb0283b8c431933a73624958d7abc26a19f18ce0" => :sierra
    sha256 "f77caa27c9ea8e866682a00cd93bbb626f6139b6a95e1c7354b0268ad806a253" => :x86_64_linux
  end

  depends_on "python"
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
