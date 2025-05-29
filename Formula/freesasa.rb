class Freesasa < Formula
  # Mitternacht_2016: "https://doi.org/10.12688/f1000research.7931.1"
  desc "C-library for calculating Solvent Accessible Surface Areas"
  homepage "https://freesasa.github.io/"
  url "https://github.com/mittinatten/freesasa/releases/download/2.1.2/freesasa-2.1.2.zip"
  sha256 "a031c4eb8cd59e802d715a37ef72930ec2d90ec53dfcf1bea0b0255980490fd5"
  license "MIT"
  head "https://github.com/mittinatten/freesasa.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"

  uses_from_macos "libxml2"

  def install
    system "autoreconf", "-fvi"
    system "./configure", *std_configure_args

    # Refer to https://github.com/mittinatten/freesasa/issues/85#issuecomment-1588979627
    # Already fixed in HEAD
    inreplace "src/Makefile", "-lc++", "-lstdc++" if OS.linux? && !build.head?

    system "make"
    system "make", "install"

    pkgshare.install "tests/data"
    prefix.install_metafiles
  end

  test do
    assert_match "Usage", shell_output("#{bin}/freesasa -h 2>&1")
    assert_match "Total   :   18923.28", shell_output("#{bin}/freesasa #{pkgshare}/data/1a0q.pdb")
  end
end
