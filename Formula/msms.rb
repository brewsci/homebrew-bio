class Msms < Formula
  desc "Compute molecular surfaces (MSMS)"
  homepage "http://mgltools.scripps.edu/packages/MSMS/"
  version "2.6.1"

  bottle :unneeded

  on_macos do
    url "https://ccsb.scripps.edu/msms/download/950/"
    sha256 "aa9c6fcdffd78f20a48990d7ce6cbe19394bb88071e2a9cc26c675171eccfcc8"
  end

  on_linux do
    url "https://ccsb.scripps.edu/msms/download/933/"
    sha256 "5f0ca50360b5938e74c538e0399d582abc4a40ef4cf410e66f31a1f91e6e3e1f"
  end

  def install
    lib.install "atmtypenumbers"

    inreplace "pdb_to_xyzr",
              'numfile = "./atmtypenumbers"',
              "numfile = \"#{lib}/atmtypenumbers\""
    inreplace "pdb_to_xyzrn",
              'numfile = "./atmtypenumbers"',
              "numfile = \"#{lib}/atmtypenumbers\""

    bin.install "pdb_to_xyzr", "pdb_to_xyzrn"
    bin.install Dir["msms.*.#{version}"] => "msms"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/msms -h")
  end
end
