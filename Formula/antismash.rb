class Antismash < Formula
  # cite Medema_2011: "https://doi.org/10.1093/nar/gkr466"
  # cite Blin_2013: "https://doi.org/10.1093/nar/gkt449"
  # cite Weber_2015: "https://doi.org/10.1093/nar/gkv437"
  # cite Blin_2017: "https://doi.org/10.1093/nar/gkx319"
  # cite Blin_2019: "https://doi.org/10.1093/nar/gkz310"
  # cite Blin_2021: "https://doi.org/10.1093/nar/gkab335"
  # cite Blin_2023: "https://doi.org/10.1093/nar/gkad344"
  include Language::Python::Virtualenv

  desc "Antibiotics & Secondary Metabolite Analysis SHell"
  homepage "https://antismash.secondarymetabolites.org/"
  url "https://github.com/antismash/antismash/archive/refs/tags/7-1-0-1.tar.gz"
  version "7.1.0.1"
  sha256 "1429986c369a81a7c1c60f2cb6efb1a28eacdb0290ec9c933477bad88d2b839d"
  license "AGPL-3.0-or-later"
  head "https://github.com/antismash/antismash.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "2ff34ee73fed805df8886ccd8df52f44954f6571f5784a08f9445c62f2af8080"
    sha256 cellar: :any,                 ventura:      "afaa9fe5de6ba026dc2b24ef5846cdb19c00b3628c395576388e42c626426b7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e55dbefa5f83597be56a296f7e34c4de395e949d57f9428de5d725824224511e"
  end

  depends_on "cmake" => :build # scikit-learn
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build # for nrpys
  depends_on "blast"
  depends_on "brewsci/bio/fasttree"
  depends_on "brewsci/bio/glimmerhmm"
  depends_on "brewsci/bio/hmmer@2"
  depends_on "brewsci/bio/meme@4.11.2"
  depends_on "brewsci/bio/muscle"
  depends_on "ca-certificates"
  depends_on "diamond"
  depends_on "freetype"
  depends_on "hmmer"
  depends_on "jpeg-turbo"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "prodigal"
  depends_on "python@3.12"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "patchelf" => :build
    depends_on "ca-certificates"
  end

  def python3
    which("python3.12")
  end

  def install
    venv = virtualenv_create(libexec, python3)
    site_packages = Language::Python.site_packages(python3)
    system python3, "-m", "pip", "--python=#{venv.root}/bin/python", "install",
                    "git+https://github.com/antismash/antismash.git@7-1-0-1"
    # Fix minor warning in BCBio
    inreplace "#{libexec}/lib/python3.12/site-packages/BCBio/GFF/GFFParser.py",
              "compile(\"\\w+=\")", "compile(r\"\\w+=\")"
    (prefix/site_packages/"homebrew-antismash.pth").write venv.site_packages
    bin.install_symlink libexec/"bin/antismash"
    bin.install_symlink libexec/"bin/download-antismash-databases"
  end

  def caveats
    <<~EOS
      Run `download-antismash-databases` to download the databases into
      #{opt_libexec}/lib/python3.12/site-packages/antismash/databases
      and `antismash --check-prereqs` to check the prerequisites.
    EOS
  end

  test do
    assert_match "antiSMASH", shell_output("#{bin}/antismash -h 2>&1")
    system python3, "-c", "import antismash"
  end
end
