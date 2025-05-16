class Msms < Formula
  desc "Compute molecular surfaces (MSMS)"
  homepage "http://mgltools.scripps.edu/packages/MSMS/"
  url "http://mgltools.scripps.edu/downloads/tars/releases/MSMSRELEASE/REL2.6.1/msms_i86_64Linux2_2.6.1.tar.gz"
  sha256 "6d2f155322ffe5d9406caf5785d47fadf8710d6c6bcc45d0cf787807657dbaa9"
  version "2.6.1"

  bottle :unneeded

  def install
    lib_msms = lib/"msms"
    lib_msms.mkpath

    lib_msms.install "atmtypenumbers"

    inreplace "pdb_to_xyzr",
              'numfile = "./atmtypenumbers"',
              "numfile = \"#{lib_msms}/atmtypenumbers\""
    inreplace "pdb_to_xyzrn",
              'numfile = "./atmtypenumbers"',
              "numfile = \"#{lib_msms}/atmtypenumbers\""

    bin.install "pdb_to_xyzr", "pdb_to_xyzrn"
    bin.install Dir["msms.*.#{version}"] => "msms"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/msms -h")
  end
end
