class Paml < Formula
  # cite Yang_2007: "https://doi.org/10.1093/molbev/msm088"
  desc "Phylogenetic analysis by maximum likelihood"
  homepage "http://abacus.gene.ucl.ac.uk/software/paml.html"
  url "http://abacus.gene.ucl.ac.uk/software/paml4.9j.tgz"
  version "4.9j"
  sha256 "9b00fbd37fe825129a160599372ba4c8e88b22d14c0388044a711fb281a0191d"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, sierra:       "e06d36db51df737038660dfec71f75d26dd86ad1061072fba9c60b7a7b324986"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6fd44750c1a4ada0f8689c3e7364c23a1a0934ab7599b89250d0eb959a5d01f9"
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
