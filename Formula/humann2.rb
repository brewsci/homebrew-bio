class Humann2 < Formula
  # cite Abubucker_2012: "https://doi.org/10.1371/journal.pcbi.1002358"
  desc "HMP Unified Metabolic Analysis Network"
  homepage "https://huttenhower.sph.harvard.edu/humann"

  url "https://bitbucket.org/biobakery/humann2/get/0.11.1.tar.bz2"
  sha256 "c84e98a486b995ad9a934f06d9ffd180d36e768d01b366ada98e31011510011a"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "40584007fa77ebf9a6b5443f34dc0dff14c51d6ccdc9ebae2488a16f16729d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "85a765927ad6e378b793d07e12a25a9207e4f441ca5b5b106d1f09153e243428"
  end

  depends_on "bowtie2"
  depends_on "diamond"
  depends_on "metaphlan"
  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *(Language::Python.setup_install_args(libexec) + ["--bypass-dependencies-install"])
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"]
  end

  test do
    system "#{bin}/humann2", "--version"
  end
end
