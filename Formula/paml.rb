class Paml < Formula
  # cite Yang_2007: "https://doi.org/10.1093/molbev/msm088"
  desc "Phylogenetic analysis by maximum likelihood"
  homepage "https://www.ucl.ac.uk/life-sciences/yang-lab/resources"
  url "https://github.com/abacus-gene/paml/archive/refs/heads/master.tar.gz"
  version "4.10.10"
  sha256 "d54899c0195034857a87fbd5ff61a6986ecaf6eada85079c3e9bf9442675bf0b"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "f38a4f56221825dfd56ee64855fc3731c97e38347b3aabafee63541c1926240e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0bb90b5cac3f74c0d03d26fbde658dcd2edca8ea8847662da0e682c56c028cf5"
  end

  def install
    # Restore permissions, as some are wrong in the tarball archives
    chmod_R "u+rw", "."

    cd "src" do
      system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
      bin.install %w[baseml basemlg chi2 codeml evolver infinitesites mcmctree pamp yn00]
    end

    pkgshare.install "dat"
    pkgshare.install Dir["*.ctl"]
    doc.install Dir["doc/*"]
    doc.install "examples"
  end

  def caveats
    <<~EOS
      Documentation and examples:
        #{HOMEBREW_PREFIX}/share/doc/paml
      Dat and ctl files:
        #{HOMEBREW_PREFIX}/share/paml
    EOS
  end

  test do
    cp Dir[doc/"examples/DatingSoftBound/*.*"], testpath
    system "#{bin}/infinitesites"
  end
end
