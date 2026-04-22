class Paml < Formula
  # cite Yang_2007: "https://doi.org/10.1093/molbev/msm088"
  desc "Phylogenetic analysis by maximum likelihood"
  homepage "https://www.ucl.ac.uk/life-sciences/yang-lab/resources"
  url "https://github.com/abacus-gene/paml/archive/refs/heads/master.tar.gz"
  version "4.10.10"
  sha256 "d54899c0195034857a87fbd5ff61a6986ecaf6eada85079c3e9bf9442675bf0b"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a0b7ce7de714bf0327156f434d03f53125b5b87d12305af109c4266a4a184aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b9b25b4a59f163e6ef68bcdcb98ca3b9988bf6fd9c0f9bfa3c2eb5a5060b0f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "715940b45cb781b1d61cb55187b40fcc0656cd841418f41053ddd89ad2308a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abae1aea01fae2aa93a27ec992147bad1eba055f25a4f115ce323a054ec901a3"
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
