class Freesasa < Formula
  # Mitternacht_2016: "https://doi.org/10.12688/f1000research.7931.1"
  desc "C-library for calculating Solvent Accessible Surface Areas"
  homepage "https://freesasa.github.io/"
  url "https://github.com/mittinatten/freesasa/releases/download/2.1.2/freesasa-2.1.2.zip"
  sha256 "a031c4eb8cd59e802d715a37ef72930ec2d90ec53dfcf1bea0b0255980490fd5"
  license "MIT"
  head "https://github.com/mittinatten/freesasa.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sequoia: "c40ff23944747b9fa9189486d16131795aea21af6f71822a67968a20d4c7a56f"
    sha256 cellar: :any,                 arm64_sonoma:  "8ded8b3061c458d895d6958486d65ba653ad5829515a1d417f1d69886e84756b"
    sha256 cellar: :any,                 ventura:       "21c128c20c6f1aea59ab3e66aaf45d8c672954c422b1b080c7f56c37c1a3684c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13158ef0a4ec170a9c7edb4cf37d6c0f94831c0c670dbafb9ca5f2c2b8c098a6"
  end

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
